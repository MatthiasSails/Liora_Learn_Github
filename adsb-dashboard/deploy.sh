#!/bin/bash
set -e
ssh Liora_VM "cd ~/Liora_Learn_Github && git pull && cd adsb-dashboard && MONGO_URI='mongodb://datascientest:dst123@localhost:27017' docker compose up -d --build"
echo "Done — http://liora-vm.matthiaskoehler.com:8502"
