#!/bin/bash
#
# borg-backup-postgres.sh
# Backup automatisé de la base PostgreSQL (SRV-2) depuis SRV-Backup,
# via SSH (authentification PKI), archivage Borg, rétention.
#
# Prérequis :
#   - Certificat SSH utilisateur signé par la CA, présent sur SRV-Backup
#   - Repo Borg déjà initialisé (borg init --encryption=repokey-blake2 $BORG_REPO)
#   - Passphrase Borg stockée dans un fichier lisible uniquement par root (600)
#   - thomas dans le groupe docker sur SRV-2
#
# À placer par ex. dans /usr/local/bin/borg-backup-postgres.sh (chmod 700, owner root)

set -euo pipefail

# --- Configuration ---
SRV2_HOST="192.168.102.3"
SRV2_PORT="2222"
SRV2_USER="thomas"
DOCKER_CONTAINER="mur_postgres"
PG_USER="mur"
PG_DB="mur_messages"
PG_PASSWORD_FILE="/root/.pg_backup_password"   # fichier contenant uniquement le mot de passe, chmod 600

BORG_REPO="/mnt/backups/postgres-repo"
BORG_PASSCOMMAND="cat /root/.borg-passphrase"  # fichier chmod 600, owner root

DUMP_DIR="/tmp"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
DUMP_FILE="${DUMP_DIR}/dump_${TIMESTAMP}.sql"

LOG_TAG="borg-backup-postgres"

# --- Fonctions ---
log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') [$LOG_TAG] $*"
	logger -t "$LOG_TAG" "$*"
}

cleanup() {
	if [[ -f "$DUMP_FILE" ]]; then
		rm -f "$DUMP_FILE"
		log "Fichier temporaire supprimé : $DUMP_FILE"
		fi
}
trap cleanup EXIT

fail() {
	log "ERREUR : $*"
	exit 1
}

# --- 1. Vérifications préalables ---
[[ -f "$PG_PASSWORD_FILE" ]] || fail "Fichier mot de passe PostgreSQL introuvable : $PG_PASSWORD_FILE"
PG_PASSWORD="$(cat "$PG_PASSWORD_FILE")"

export BORG_REPO
export BORG_PASSCOMMAND

# --- 2. Dump PostgreSQL via SSH (PKI) ---
log "Démarrage du dump PostgreSQL depuis $SRV2_HOST..."

umask 077
if ! ssh -p "$SRV2_PORT" "${SRV2_USER}@${SRV2_HOST}" \
	"docker exec -e PGPASSWORD='${PG_PASSWORD}' ${DOCKER_CONTAINER} pg_dump -U ${PG_USER} ${PG_DB}" \
	> "$DUMP_FILE"
	then
	fail "Échec du dump PostgreSQL via SSH"
	fi
	
	chmod 600 "$DUMP_FILE"
	
	# Vérifier que le dump n'est pas vide / suspect
	DUMP_SIZE=$(stat -c%s "$DUMP_FILE")
	if [[ "$DUMP_SIZE" -lt 100 ]]; then
		fail "Dump anormalement petit (${DUMP_SIZE} octets) — abandon avant archivage"
		fi
		log "Dump réussi : $DUMP_FILE (${DUMP_SIZE} octets)"
		
		# --- 3. Archivage Borg ---
		log "Création de l'archive Borg..."
		
		if ! borg create --stats --compression zstd \
			"::backup-${TIMESTAMP}" \
			"$DUMP_FILE"
			then
			fail "Échec de la création de l'archive Borg"
			fi
			
			log "Archive créée : backup-${TIMESTAMP}"
			
			# --- 4. Rétention ---
			log "Application de la politique de rétention..."
			
			if ! borg prune --list \
				--keep-daily=7 \
				--keep-weekly=4 \
				--keep-monthly=6 \
				::
				then
				log "AVERTISSEMENT : échec du prune (non bloquant, à vérifier manuellement)"
				fi
				
				# --- 5. Vérification d'intégrité périodique (léger, pas à chaque run si repo volumineux) ---
				# Décommenter pour un check complet (peut être long) :
				# borg check --repository-only ::
				
				log "Backup terminé avec succès."
				exit 0
