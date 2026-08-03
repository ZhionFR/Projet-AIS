#!/bin/bash
# Ne PAS flush : on préserve les chaînes DOCKER-*, sinon le réseau des conteneurs casse.

# --- NAT/PREROUTING : redirection 80 -> 5000 ---
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 5000

# --- INPUT : autoriser uniquement ce qui est nécessaire ---
iptables -F INPUT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp --dport 2222 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 80  -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT

# --- Policy ---
iptables -P INPUT DROP
