#!/bin/bash
# DuckDNS IP-Update für liora-vm-mk.duckdns.org
# Token liegt in ~/.duckdns_token (nie ins Git!)
# Cron-Setup: crontab -e
#   @reboot sleep 10 && /home/ubuntu/Liora_Learn_Github/portainer-agent/duckdns-update.sh
#   */5 * * * * /home/ubuntu/Liora_Learn_Github/portainer-agent/duckdns-update.sh

TOKEN_FILE="$HOME/.duckdns_token"

if [ ! -f "$TOKEN_FILE" ]; then
  echo "ERROR: Token-Datei nicht gefunden: $TOKEN_FILE"
  echo "Anlegen mit: echo 'DEIN-TOKEN' > $TOKEN_FILE && chmod 600 $TOKEN_FILE"
  exit 1
fi

TOKEN=$(cat "$TOKEN_FILE")
DOMAIN="liora-vm-mk"
RESULT=$(curl -sf "https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=")

echo "$(date): DuckDNS update → $RESULT" >> "$HOME/.duckdns_update.log"
