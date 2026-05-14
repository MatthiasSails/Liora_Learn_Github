#!/usr/bin/env bash
set -euo pipefail

# Deploy corolla-run to Liora_VM
# Usage: ./deploy.sh
# Requires: SSH key at ~/.ssh/data_enginering_machine.pem

REMOTE="ubuntu@108.129.115.52"
KEY="$HOME/.ssh/data_enginering_machine.pem"
REPO="https://github.com/MatthiasSails/Liora_Learn_Github.git"
APP_DIR="/home/ubuntu/corolla-run"

echo "==> Connecting to Liora_VM..."
ssh -i "$KEY" "$REMOTE" bash <<EOF
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
cd "$APP_DIR/corolla-run"
docker compose down --remove-orphans 2>/dev/null || true

echo "==> Building and starting..."
docker compose up -d --build

echo "==> Done. Running containers:"
docker compose ps
EOF

echo ""
echo "Deployed! Open: http://108.129.115.52:8080"
