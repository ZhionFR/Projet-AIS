# Sur la machine HOST

## 1. Générer la CA
mkdir -p ~/ssh-ca && cd ~/ssh-ca
ssh-keygen -t ed25519 -f ssh_ca -C "homelab-ssh-ca" -N ""

## 2. Récupérer les clés d'hôte des serveurs
scp thomas@192.168.100.10:/etc/ssh/ssh_host_ed25519_key.pub srv1_host_key.pub
scp -P 2222 thomas@192.168.100.2:/etc/ssh/ssh_host_ed25519_key.pub srv2_host_key.pub

## 3. Signer les clés d'hôte
ssh-keygen -s ssh_ca -I "srv1-host" -h -n 192.168.100.10,192.168.10.1,srv1 -V +52w srv1_host_key.pub
ssh-keygen -s ssh_ca -I "srv2-host" -h -n 192.168.100.2,192.168.10.2,srv2 -V +52w srv2_host_key.pub

## 4. Déployer les certificats d'hôte
scp srv1_host_key-cert.pub thomas@192.168.100.10:/tmp/
scp -P 2222 srv2_host_key-cert.pub thomas@192.168.100.2:/tmp/

## 5. Générer et signer la clé utilisateur
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_homelab -C "thomas@host" -N ""
ssh-keygen -s ssh_ca -I "thomas-user" -n thomas -V +12w ~/.ssh/id_ed25519_homelab.pub

## 6. Déployer la clé publique CA sur SRV-2
scp -P 2222 ~/ssh-ca/ssh_ca.pub thomas@192.168.100.2:/tmp/

## 7. Faire confiance à la CA côté client
echo "@cert-authority * $(cat ~/ssh-ca/ssh_ca.pub)" >> ~/.ssh/known_hosts

## 8. Nettoyer les anciennes entrées known_hosts
ssh-keygen -R 192.168.100.10
ssh-keygen -R 192.168.100.2



# Sur SRV-2

## 1. Déployer le certificat d'hôte
sudo mv /tmp/srv2_host_key-cert.pub /etc/ssh/
sudo chown root:root /etc/ssh/srv2_host_key-cert.pub
sudo chmod 644 /etc/ssh/srv2_host_key-cert.pub

## 2. Déclarer le certificat d'hôte dans sshd_config
echo "HostCertificate /etc/ssh/srv2_host_key-cert.pub" | sudo tee -a /etc/ssh/sshd_config

## 3. Déployer la clé publique CA et déclarer TrustedUserCAKeys
sudo mv /tmp/ssh_ca.pub /etc/ssh/ssh_ca.pub
sudo chown root:root /etc/ssh/ssh_ca.pub
sudo chmod 644 /etc/ssh/ssh_ca.pub
echo "TrustedUserCAKeys /etc/ssh/ssh_ca.pub" | sudo tee -a /etc/ssh/sshd_config

## 4. Redémarrer sshd
sudo systemctl restart sshd



# Signer une nouvelle clé

scp user@sa_machine:~/.ssh/id_ed25519_homelab.pub ~/ssh-ca/nouvel_user.pub

cd ~/ssh-ca
ssh-keygen -s ssh_ca -I "nouvel_user-user" -n nom_unix_sur_les_serveurs -V +12w nouvel_user.pub

scp ~/ssh-ca/nouvel_user-cert.pub user@sa_machine:~/.ssh/id_ed25519_homelab-cert.pub



# Nouvelle VM

## 1. Récupérer la clé d'hôte du nouveau serveur
scp -P 22 thomas@IP_NOUVEAU:/etc/ssh/ssh_host_ed25519_key.pub nouveau_srv_host_key.pub

## 2. Signer
ssh-keygen -s ssh_ca -I "nouveau-srv-host" -h -n IP,hostname -V +52w nouveau_srv_host_key.pub

## 3. Déployer le certificat sur le serveur
scp nouveau_srv_host_key-cert.pub thomas@IP_NOUVEAU:/tmp/
ssh thomas@IP_NOUVEAU "sudo mv /tmp/nouveau_srv_host_key-cert.pub /etc/ssh/ && \
  sudo chown root:root /etc/ssh/nouveau_srv_host_key-cert.pub && \
  sudo chmod 644 /etc/ssh/nouveau_srv_host_key-cert.pub"

## 4. Configurer sshd_config sur le nouveau serveur
ssh thomas@IP_NOUVEAU "echo 'HostCertificate /etc/ssh/nouveau_srv_host_key-cert.pub' | sudo tee -a /etc/ssh/sshd_config && \
  sudo cp /etc/ssh/ssh_ca.pub /etc/ssh/ && \
  echo 'TrustedUserCAKeys /etc/ssh/ssh_ca.pub' | sudo tee -a /etc/ssh/sshd_config && \
  sudo systemctl restart sshd"
