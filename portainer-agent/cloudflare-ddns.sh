#!/bin/bash
# Cloudflare Dynamic DNS Update für liora-vm.matthiaskoehler.com
# Token (Zone:DNS:Edit) liegt in ~/.cf_ddns_token (nie ins Git!)
#
# Cron-Setup: crontab -e
#   @reboot sleep 15 && /home/ubuntu/Liora_Learn_Github/portainer-agent/cloudflare-ddns.sh
#   */5 * * * * /home/ubuntu/Liora_Learn_Github/portainer-agent/cloudflare-ddns.sh

TOKEN_FILE="$HOME/.cf_ddns_token"
ZONE_NAME="matthiaskoehler.com"
RECORD_NAME="liora-vm.matthiaskoehler.com"
LOG="$HOME/.cf_ddns.log"

if [ ! -f "$TOKEN_FILE" ]; then
  echo "ERROR: Token-Datei nicht gefunden: $TOKEN_FILE"
  echo "Anlegen mit: echo 'DEIN-CF-TOKEN' > $TOKEN_FILE && chmod 600 $TOKEN_FILE"
  exit 1
fi

TOKEN=$(cat "$TOKEN_FILE")
IP=$(curl -sf https://api.ipify.org)

if [ -z "$IP" ]; then
  echo "$(date): ERROR - Public IP nicht ermittelbar" >> "$LOG"
  exit 1
fi

ZONE_ID=$(curl -sf -X GET "https://api.cloudflare.com/client/v4/zones?name=$ZONE_NAME" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" | python3 -c "import sys,json; print(json.load(sys.stdin)['result'][0]['id'])")

RECORD=$(curl -sf -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD_NAME" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

RECORD_ID=$(echo "$RECORD" | python3 -c "import sys,json; r=json.load(sys.stdin)['result']; print(r[0]['id']) if r else print('')")
CURRENT_IP=$(echo "$RECORD" | python3 -c "import sys,json; r=json.load(sys.stdin)['result']; print(r[0]['content']) if r else print('')")

if [ "$IP" = "$CURRENT_IP" ]; then
  echo "$(date): IP unverändert ($IP)" >> "$LOG"
  exit 0
fi

if [ -z "$RECORD_ID" ]; then
  # Record anlegen
  RESULT=$(curl -sf -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$IP\",\"ttl\":60,\"proxied\":false}")
else
  # Record aktualisieren
  RESULT=$(curl -sf -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"content\":\"$IP\"}")
fi

SUCCESS=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['success'])")
echo "$(date): $CURRENT_IP → $IP | success=$SUCCESS" >> "$LOG"
