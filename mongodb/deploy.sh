#!/usr/bin/env bash
set -euo pipefail

# Deploy mongodb to Liora_VM
# Usage: ./deploy.sh
# Requires: SSH key at ~/.ssh/data_enginering_machine.pem

REMOTE="Liora_VM"
REPO="https://github.com/MatthiasSails/Liora_Learn_Github.git"
APP_DIR="/home/ubuntu/Liora_Learn_Github"

echo "==> Connecting to Liora_VM..."
ssh "$REMOTE" bash <<EOF
set -euo pipefail
export GIT_TERMINAL_PROMPT=0

echo "==> Pulling latest code..."
if [ -d "$APP_DIR/.git" ]; then
  git -C "$APP_DIR" pull
else
  rm -rf "$APP_DIR"
  git clone "$REPO" "$APP_DIR"
fi

echo "==> Stopping old container (if running)..."
cd "$APP_DIR/mongodb"
docker compose down --remove-orphans 2>/dev/null || true

echo "==> Starting MongoDB..."
docker compose up -d

echo "==> Done. Running containers:"
docker compose ps
EOF

echo ""
echo "MongoDB läuft auf Liora_VM:27017"
echo "Verbinden: mongosh 'mongodb://datascientest:<password>@liora-vm.matthiaskoehler.com:27017'"
