#!/usr/bin/env bash
# =============================================================================
# Open Local AI Platform - Installer
# =============================================================================
# Supports: Linux, macOS, Windows (Git Bash / WSL)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# --- Dependency checks ---
if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker is not installed."
  echo "  Linux:  https://docs.docker.com/engine/install/"
  echo "  macOS:  https://docs.docker.com/desktop/install/mac-install/"
  echo "  Windows: https://docs.docker.com/desktop/install/windows-install/"
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "ERROR: Docker Compose v2 plugin is required."
  echo "  Install: https://docs.docker.com/compose/install/"
  exit 1
fi

# --- Create .env if missing ---
if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "Created .env from .env.example. Review secrets before external access."
  else
    echo "ERROR: .env.example not found. Cannot create .env."
    exit 1
  fi
fi

# --- Create workspace directory ---
mkdir -p workspace

# --- Validate Compose files ---
echo "Validating Compose files..."
docker compose -f compose/docker-compose.yml config >/dev/null 2>&1 || {
  echo "ERROR: Core compose file is invalid."
  docker compose -f compose/docker-compose.yml config
  exit 1
}

# --- Start core services ---
echo "Starting core services..."
docker compose -f compose/docker-compose.yml up -d

# --- Source .env for variable expansion ---
set -a
# shellcheck disable=SC1091
[ -f .env ] && source .env
set +a

echo ""
echo "Done! Services are starting up."
echo ""
echo "  Open WebUI:  http://localhost:${OPEN_WEBUI_PORT:-3000}"
echo "  Ollama API:  http://localhost:${OLLAMA_PORT:-11434}"
echo "  Perplexica:  http://localhost:${PERPLEXICA_PORT:-3001}"
echo "  SearXNG:     http://localhost:${SEARXNG_PORT:-8080}"
echo ""
echo "Next steps:"
echo "  1. Pull a model:  docker exec -it ollama ollama pull llama3.2"
echo "  2. Open Open WebUI in your browser"
echo "  3. Run 'make coding' or 'make productivity' to enable optional layers"
echo ""
