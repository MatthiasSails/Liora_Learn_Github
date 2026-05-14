#!/bin/bash
# Cloudflare Dynamic DNS Update für liora-vm.matthiaskoehler.com
# Token (Zone:DNS:Edit) liegt in ~/.cf_ddns_token (nie ins Git!)
#
# Cron-Setup: crontab -e
#   @reboot sleep 15 && /home/ubuntu/Liora_Learn_Github/portainer-agent/cloudflare-ddns.sh
#   */5 * * * * /home/ubuntu/Liora_Learn_Github/portainer-agent/cloudflare-ddns.sh

set -euo pipefail

TOKEN_FILE="$HOME/.cf_ddns_token"
ZONE_NAME="matthiaskoehler.com"
RECORD_NAME="liora-vm.matthiaskoehler.com"
LOG="$HOME/.cf_ddns.log"

die() { echo "$(date): ERROR - $1" >> "$LOG"; echo "ERROR: $1"; exit 1; }

[ -f "$TOKEN_FILE" ] || die "Token-Datei nicht gefunden: $TOKEN_FILE"

TOKEN=$(cat "$TOKEN_FILE" | tr -d '[:space:]')
IP=$(curl -s --max-time 10 https://api.ipify.org) || die "Public IP nicht ermittelbar"
[ -n "$IP" ] || die "Public IP leer"

cf() { curl -s --max-time 10 "$@" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"; }

ZONE_RESP=$(cf "https://api.cloudflare.com/client/v4/zones?name=$ZONE_NAME")
ZONE_ID=$(echo "$ZONE_RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['result'][0]['id']) if d['success'] else exit(1)") \
  || die "Zone nicht gefunden. API-Antwort: $ZONE_RESP"

RECORD=$(cf "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD_NAME")
RECORD_ID=$(echo "$RECORD" | python3 -c "import sys,json; r=json.load(sys.stdin)['result']; print(r[0]['id']) if r else print('')")
CURRENT_IP=$(echo "$RECORD" | python3 -c "import sys,json; r=json.load(sys.stdin)['result']; print(r[0]['content']) if r else print('')")

if [ "$IP" = "$CURRENT_IP" ]; then
  echo "$(date): IP unverändert ($IP)" >> "$LOG"
  exit 0
fi

if [ -z "$RECORD_ID" ]; then
  RESULT=$(cf -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$IP\",\"ttl\":60,\"proxied\":false}")
else
  RESULT=$(cf -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    --data "{\"content\":\"$IP\"}")
fi

SUCCESS=$(echo "$RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['success'])")
echo "$(date): ${CURRENT_IP:-neu} → $IP | success=$SUCCESS" >> "$LOG"
