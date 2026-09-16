#!/usr/bin/env bash
# =============================================================================
# Open Local AI Platform - Update
# =============================================================================
# Pulls latest images and recreates containers.
# Supports: Linux, macOS, Windows (Git Bash / WSL)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# --- Source .env if it exists ---
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

echo "Pulling latest images..."
docker compose -f compose/docker-compose.yml pull

echo "Recreating containers..."
docker compose -f compose/docker-compose.yml up -d

echo "Pruning unused images..."
docker image prune -f

echo ""
echo "Update complete. Check status with: make ps"
echo ""
