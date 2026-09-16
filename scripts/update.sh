#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
docker compose -f compose/docker-compose.yml pull
docker compose -f compose/docker-compose.yml up -d
docker image prune -f
