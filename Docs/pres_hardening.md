Qu'est ce que le hardening ?
    - Le durcissement/hardening est l'ensemble des mesures visant à réduire la surface d'attaque d'un système


Concrètement, on fait quoi ?
    - **Réduire les services actifs :** désactiver tout ce qui n'est pas strictement nécessaire (services, ports, daemons)
    - **Restreindre les accès :** gestion stricte des permissions, principe du moindre privilège, désactivation du login root direct en SSH
    - **Mettre à jour et patcher :** appliquer les correctifs de sécurité systématiquement
    - **Configurer le pare-feu :** n'autoriser que les flux nécessaires (iptables ou autres pare-feux)
    - **Chiffrement :** disques, communications (TLS), clés SSH plutôt que mots de passe
    - **Audit et logs :** surveiller les accès et les tentatives d'intrusion (fail2ban)
    - **Isolation :** conteneurs, machines virtuelles, cloisonnement des services
    - **Suppression des comptes/fichiers inutiles** et changement des identifiants par défaut


