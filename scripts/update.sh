#!/usr/bin/env bash
# =============================================================================
# Open Local AI Platform - Update
# =============================================================================
# Pulls latest images and recreates containers.
# Detects active compose overlays and updates them too.
# Supports: Linux, macOS, Windows (Git Bash / WSL)
set -euo pipefail

trap 'echo "ERROR on line $LINENO. Update failed." >&2' ERR

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# --- Source .env for variable expansion ---
if [ -f .env ]; then
  while IFS='=' read -r key value; do
    key="$(echo "$key" | xargs)"
    [[ -z "$key" || "$key" == \#* ]] && continue
    export "$key=$value" 2>/dev/null || true
  done < .env
fi

# --- Detect running compose files ---
COMPOSE_FILES="-f compose/docker-compose.yml"

OVERLAY_FILES=(
  "compose/docker-compose.coding.yml:code-server"
  "compose/docker-compose.productivity.yml:paperless"
  "compose/docker-compose.vibecoding.yml:tabby"
  "compose/docker-compose.daily.yml:n8n"
)

for entry in "${OVERLAY_FILES[@]}"; do
  IFS=':' read -r file service <<< "$entry"
  if docker compose -f compose/docker-compose.yml -f "$file" ps --format '{{.Name}}' 2>/dev/null | grep -q "$service"; then
    COMPOSE_FILES="$COMPOSE_FILES -f $file"
    echo "Detected overlay: $(basename "$file" .yml)"
  fi
done

echo "Pulling latest images..."
eval docker compose "$COMPOSE_FILES" pull

echo "Recreating containers..."
eval docker compose "$COMPOSE_FILES" up -d

echo "Pruning unused images..."
docker image prune -f

echo ""
echo "Update complete. Check status with: make ps"
echo ""
