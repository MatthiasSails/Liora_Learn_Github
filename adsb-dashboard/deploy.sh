#!/bin/bash
set -e
source /Volumes/Rocket_2/DEV/airline-data-platform/.env
ssh Liora_VM "cd ~/Liora_Learn_Github && git fetch origin && git reset --hard origin/main && cd adsb-dashboard && MONGO_URI='${MONGO_URI}' docker compose up -d --build"
echo "Done — http://liora-vm.matthiaskoehler.com:8502"
