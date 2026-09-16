#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${ROOT_DIR}/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Export Compose configuration and env template. Application volumes should be backed up
# using your storage platform, restic, Borg, snapshots, or another tested backup system.
cp "$ROOT_DIR/.env.example" "$BACKUP_DIR/.env.example"
cp -r "$ROOT_DIR/compose" "$BACKUP_DIR/compose"
cp -r "$ROOT_DIR/config" "$BACKUP_DIR/config"

echo "Configuration backup created at: $BACKUP_DIR"
echo "Remember to back up Docker volumes and databases with application-aware procedures."
