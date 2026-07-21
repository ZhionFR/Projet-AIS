# Commandes utilisées 



## Misc/Outils

### apt 

#### apt install
    Contexte :
    - Installer les paquets nécessaires au fonctionnement de la virutalisation


### systemctl

#### systemctl start
Contexte :
    - Lancer le démon libvirt pour créer et utiliser les premières VM

#### systemctl enable
Contexte :
    - Activer le démon libvirt pour la première VM

#### systemctl restart
Contexte :
    - Relancer le démon "networking" lors de la tentative de bridge sur le wifi host


### touch
Contexte :
    - Création de fichiers


### echo

#### echo "texte" > file
Contexte :
    - Mettre texte dans un fichier

#### echo "texte" >> file
Contexte :
    - Ajouter texte dans un fichier


### source

#### source <file>
Contexte :
    - Éxecuter le code d'un fichier pour rendre les fonction disponibles
    - Sourcer le ~/.bashrc pour changer le $PATH


### mv

#### mv /path/to/destination /path/to/source
Contexte :
    - Déplacer un fichier
    - Recommer un fichier (déplacement vers un autre nom mais même chemin)


## SSH/Accès distant

### ssh

#### ssh <user>@<host> -p <port>
Contexte :
    - Connection à une VM en simulant un accès distant

#### ssh -i /path/to/ssh_key <user>@<host> -p <port>
Contexte :
    - Connection en utilisant une clé privée ssh


### ssh-copy-id

#### ssh-copy-id -f -i /path/to/ssh_key.pub -p <port> <user>@<host>
Contexte :
    - Ajout d'une cĺé publique par laquelle on peut se connecter à cet user sur le serveur


### ssh-keygen

#### ssh-keygen -t id_25519 -i <user>@<domain>
Contexte :
    - Génération d'une pare de clés ssh en id_25519


### sftp

#### !get /path/to/file
Contexte :
    - télécharger vers l'hôte (-r si dossier)

#### !reget /path/to/file
Contexte :
    - reprendre un téléchargement interrompu (-r si dossier)

#### !put /path/to/file
Contexte:
    - télécharger depuis l'hôte (-r si dossier)

#### !reput /path/to/file
Contexte
    - reprendre un téléchargement interrompu (-r si dossier)

#### mget
Contexte :
    - get multiple fichiers

#### mput
Contexte :
    - put multiple fichiers


### ngrok

#### ngrok tcp <port>
Contexte :
    - Ouverture du port par un canal ngrok (tcp)

## Gestion d'utilisateurs

### tmux

#### tmux new-session -s <name> 
Contexte :
    - Création de session tmux

#### tmux attach-session -t <name>
Contexte :
    - S'attacher à une session tmux existante

#### tmux send-keys -t <name> ["command" Enter]
Contexte :
    - Utiliser une commande dans une session tmux sans l'ouvrir


## Versionnement

### git

#### git commit -a
Contexte :
    - Créer un commit git

#### git add <files>
Contexte :
    - Activer le versionnement des fichiers selectionnés

#### git push
Contexte :
    - Push les commits sur le repo


## Réseau

### ip

#### ip r
Contexte :
    - Lister les IP du client et les interfaces liées (avec adresses de routeurs)

#### ip link set
Contexte : 
    - Tentative de bridge de l'interface de la VM sur le wifi du host


### nmcli

#### nmcli connection add
Contexte :
    - Ajouter une interface virtuelle a network manager

#### nmcli connection show
Contexte :
    - Lister les interface de la machine

#### nmcli device show
Contexte :
    - Lister les cartes réseau et leurs specs


