#!/bin/bash
# Ne PAS flush : on préserve les chaînes DOCKER-*, sinon le réseau des conteneurs casse.

# --- INPUT : autoriser uniquement ce qui est nécessaire ---
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp --dport 2222 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.101.3 --dport 5432 -j ACCEPT
iptables -P INPUT DROP
