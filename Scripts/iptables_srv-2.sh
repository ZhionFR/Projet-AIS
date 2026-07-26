#!/bin/bash
# Ne PAS flush : on préserve les chaînes DOCKER-*, sinon le réseau des conteneurs casse.

# --- INPUT : autoriser uniquement ce qui est nécessaire ---
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp --dport 2222 -m conntrack --ctstate NEW -j ACCEPT
iptables -P INPUT DROP

# Bloque tout accès à 5432 qui ne vient PAS du serveur web
iptables -I DOCKER-USER -p tcp --dport 5432 ! -s 192.168.10.1 -j DROP
