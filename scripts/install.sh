#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required. Install Docker Engine and Compose v2 first."
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example. Review secrets before external access."
fi

mkdir -p workspace

echo "Validating Compose..."
docker compose -f compose/docker-compose.yml config >/dev/null

echo "Starting core services..."
docker compose -f compose/docker-compose.yml up -d

echo "Done. Open http://localhost:${OPEN_WEBUI_PORT:-3000}"
