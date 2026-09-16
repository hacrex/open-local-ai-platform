#!/usr/bin/env bash
# =============================================================================
# Open Local AI Platform - Health Check
# =============================================================================
# Checks connectivity to all running services.
# Supports: Linux, macOS, Windows (Git Bash / WSL)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- Source .env if it exists ---
if [ -f "$ROOT_DIR/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT_DIR/.env"
  set +a
fi

ERRORS=0

check_url() {
  local name="$1"
  local url="$2"
  if curl -fsS --max-time 8 "$url" >/dev/null 2>&1; then
    echo "  OK   $name ($url)"
  else
    echo "  FAIL $name ($url)"
    ERRORS=$((ERRORS + 1))
  fi
}

echo "=== Open Local AI Platform - Health Check ==="
echo ""

echo "Core services:"
check_url "Ollama"     "http://localhost:${OLLAMA_PORT:-11434}/api/tags"
check_url "Open WebUI" "http://localhost:${OPEN_WEBUI_PORT:-3000}"
check_url "SearXNG"    "http://localhost:${SEARXNG_PORT:-8080}"
check_url "Perplexica" "http://localhost:${PERPLEXICA_PORT:-3001}"
echo ""

echo "Productivity services:"
check_url "Paperless"     "http://localhost:${PAPERLESS_PORT:-8000}"
check_url "Blinko"        "http://localhost:${BLINKO_PORT:-1111}"
check_url "Karakeep"      "http://localhost:${KARAKEEP_PORT:-3002}"
check_url "Pulse"         "http://localhost:${PULSE_PORT:-7655}"
check_url "Open Notebook" "http://localhost:${OPEN_NOTEBOOK_PORT:-8502}"
echo ""

echo "Coding services:"
check_url "Code Server" "http://localhost:${CODE_SERVER_PORT:-8443}"
echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: $ERRORS service(s) unreachable"
  exit 1
else
  echo "RESULT: All services healthy"
fi
