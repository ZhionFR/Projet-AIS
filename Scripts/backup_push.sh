#!/bin/bash
set -euo pipefail

export BORG_REPO="ssh://borgpush@192.168.103.3:2222/mnt/backups/postgres-repo"
export BORG_RSH="ssh -i /home/thomas/.ssh/id_ed25519_backup-push"
export BORG_PASSPHRASE="$(cat /home/thomas/.borg-passphrase)"
export PGPASSWORD="$(cat /home/thomas/.pg_backup_password)"  #    copier depuis Backup si pas d  j   fait

docker exec -e PGPASSWORD="$PGPASSWORD" mur_postgres pg_dump -U mur mur_messages \
  | borg create --stats --compression zstd \
    "::backup-{now:%Y-%m-%d_%H-%M-%S}" -

borg prune --list --keep-hourly=24 --keep-daily=7 --keep-weekly=4




