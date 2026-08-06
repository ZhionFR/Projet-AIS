| ID | Source | Destination | Port/Protocole | Résultat attendu | Commande / Outil | Résultat |
|---|---|---|---|---|---|---|
| 1 | Hôte | SRV-1 | 80/tcp | ACCEPT (redirigé vers 5000) | `nmap -Pn -p 80 IP_SRV1` puis `curl -v http://IP_SRV1/` | OK |
| 2 | Hôte | SRV-1 | 5000/tcp direct | DROP (port 5000 non exposé publiquement) | `nmap -Pn -p 5000 IP_SRV1` | OK |
| 3 | SRV-1 | SRV-2 | 5432/tcp | ACCEPT | `nc -zv -w3 IP_SRV2 5432 && date` | OK |
| 4 | SRV-Backup | SRV-2 | 5432/tcp | DROP | `nc -zv -w3 IP_SRV2 5432 && date` | OK |
| 5 | SRV-1 | SRV-2 | 5432/tcp, lien direct hors PfSense | Échec de connexion si testé au niveau réseau (pas de lien direct) | `ip r && ip a && date` sur SRV-1 et SRV-2 | OK |
| 6 | Toutes zones | PfSense (interfaces) | — | Deny-all par défaut visible | Capture des règles PfSense (Firewall > Rules) par interface | OK | 

