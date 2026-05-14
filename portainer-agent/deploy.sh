#!/bin/bash
# Bootstrap: einmalig ausführen um den Portainer Agent auf Liora_VM zu starten.
# Danach wird der Agent über Home-Portainer (GitOps) verwaltet.
set -e

REMOTE="ubuntu@108.129.115.52"
KEY="$HOME/.ssh/data_enginering_machine.pem"
REPO="https://github.com/MatthiasSails/Liora_Learn_Github.git"
DIR="/home/ubuntu/Liora_Learn_Github"

ssh -i "$KEY" "$REMOTE" "
  if [ ! -d '$DIR' ]; then
    git clone $REPO $DIR
  else
    cd $DIR && git pull
  fi
  cd $DIR/portainer-agent
  docker compose up -d
"

echo "Portainer Agent läuft auf 108.129.115.52:9001"
