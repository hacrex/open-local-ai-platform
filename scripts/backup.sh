#!/usr/bin/env bash
# =============================================================================
# Open Local AI Platform - Backup
# =============================================================================
# Backs up compose configuration and env template.
# Docker volumes should be backed up separately using restic, Borg, or snapshots.
# Supports: Linux, macOS, Windows (Git Bash / WSL)
set -euo pipefail

trap 'echo "ERROR on line $LINENO. Backup failed. Partial backup at: $BACKUP_DIR" >&2' ERR

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${ROOT_DIR}/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# --- Backup compose config ---
cp -r "$ROOT_DIR/compose" "$BACKUP_DIR/compose"

# --- Backup .env.example if it exists ---
if [ -f "$ROOT_DIR/.env.example" ]; then
  cp "$ROOT_DIR/.env.example" "$BACKUP_DIR/.env.example"
fi

# --- Backup .env with warning (contains secrets) ---
if [ -f "$ROOT_DIR/.env" ]; then
  cp "$ROOT_DIR/.env" "$BACKUP_DIR/.env"
  echo "WARNING: .env backed up (contains secrets). Secure or delete after restore."
fi

# --- Backup config directory if it exists ---
if [ -d "$ROOT_DIR/config" ]; then
  cp -r "$ROOT_DIR/config" "$BACKUP_DIR/config"
fi

# --- Backup scripts ---
cp -r "$ROOT_DIR/scripts" "$BACKUP_DIR/scripts"

# --- Backup Makefile ---
cp "$ROOT_DIR/Makefile" "$BACKUP_DIR/Makefile"

echo ""
echo "Configuration backup created at: $BACKUP_DIR"
echo ""
echo "WARNING: This backs up configuration only."
echo "  For Docker volume data, use application-aware backup tools:"
echo "    - restic, Borg, or Proxmox/Docker snapshots"
echo "    - Paperless: docker exec paperless document_exporter ../export"
echo "    - Ollama models: re-pull from registry or backup /var/lib/docker/volumes/"
echo ""
echo "To restore:"
echo "  1. Copy compose/, .env.example, .env back to the project root"
echo "  2. Run: make up"
echo "  3. See docs/BACKUP.md for detailed restore procedures"
echo ""
