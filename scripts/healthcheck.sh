#!/usr/bin/env bash
# =============================================================================
# Open Local AI Platform - Health Check
# =============================================================================
# Checks connectivity to running services.
# Only checks services that have containers running (detects active overlays).
# Supports: Linux, macOS, Windows (Git Bash / WSL)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- Source .env if it exists ---
if [ -f "$ROOT_DIR/.env" ]; then
  while IFS='=' read -r key value; do
    key="$(echo "$key" | xargs)"
    [[ -z "$key" || "$key" == \#* ]] && continue
    export "$key=$value" 2>/dev/null || true
  done < "$ROOT_DIR/.env"
fi

ERRORS=0
CHECKED=0

check_url() {
  local name="$1"
  local url="$2"
  CHECKED=$((CHECKED + 1))
  if curl -fsS --max-time 8 "$url" >/dev/null 2>&1; then
    echo "  OK   $name ($url)"
  else
    echo "  FAIL $name ($url)"
    ERRORS=$((ERRORS + 1))
  fi
}

# --- Detect running services via docker compose ps ---
is_running_overlay() {
  local file="$1"
  local service="$2"
  docker compose -f compose/docker-compose.yml -f "$file" ps --format '{{.Name}}' 2>/dev/null | grep -q "$service"
}

echo "=== Open Local AI Platform - Health Check ==="
echo ""

echo "Core services:"
check_url "Ollama"     "http://localhost:${OLLAMA_PORT:-11434}/api/tags"
check_url "Open WebUI" "http://localhost:${OPEN_WEBUI_PORT:-3000}"
check_url "SearXNG"    "http://localhost:${SEARXNG_PORT:-8080}"
check_url "Perplexica" "http://localhost:${PERPLEXICA_PORT:-3001}"
echo ""

if is_running_overlay "compose/docker-compose.productivity.yml" "paperless"; then
  echo "Productivity services:"
  check_url "Paperless"     "http://localhost:${PAPERLESS_PORT:-8000}"
  check_url "Blinko"        "http://localhost:${BLINKO_PORT:-1111}"
  check_url "Karakeep"      "http://localhost:${KARAKEEP_PORT:-3002}"
  check_url "Pulse"         "http://localhost:${PULSE_PORT:-7655}"
  check_url "Open Notebook" "http://localhost:${OPEN_NOTEBOOK_PORT:-8502}"
  echo ""
fi

if is_running_overlay "compose/docker-compose.coding.yml" "code-server"; then
  echo "Coding services:"
  check_url "Code Server" "http://localhost:${CODE_SERVER_PORT:-8443}"
  echo ""
fi

if is_running_overlay "compose/docker-compose.vibecoding.yml" "tabby"; then
  echo "Vibecoding services:"
  check_url "TabbyML" "http://localhost:${TABBY_PORT:-8080}"
  echo ""
fi

if is_running_overlay "compose/docker-compose.daily.yml" "n8n"; then
  echo "Daily driver services:"
  check_url "n8n"         "http://localhost:${N8N_PORT:-5678}"
  check_url "Khoj"        "http://localhost:${KHOJ_PORT:-42110}"
  check_url "LibreChat"   "http://localhost:${LIBRECHAT_PORT:-3080}"
  echo ""
fi

if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: $ERRORS/$CHECKED service(s) unreachable"
  exit 1
else
  echo "RESULT: All $CHECKED services healthy"
fi
