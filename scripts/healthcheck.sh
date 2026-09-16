#!/usr/bin/env bash
set -euo pipefail

for url in \
  "http://localhost:${OLLAMA_PORT:-11434}/api/tags" \
  "http://localhost:${OPEN_WEBUI_PORT:-3000}" \
  "http://localhost:${SEARXNG_PORT:-8080}"; do
  echo "Checking $url"
  curl -fsS --max-time 8 "$url" >/dev/null || echo "WARNING: $url is not reachable"
done
