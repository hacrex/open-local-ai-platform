# Backup and Restore

## What gets backed up

The `make backup` command backs up **configuration only**:

- Compose files (compose/)
- Environment template (.env.example)
- Active environment (.env) — contains secrets, secure after backup
- Custom configuration (config/)
- Scripts (scripts/)
- Makefile

Backups are stored in `backups/YYYYMMDD-HHMMSS/`.

## What is NOT backed up

Docker volumes contain all application data. These must be backed up separately.

| Service | Volume(s) | Backup method |
|---------|-----------|---------------|
| Ollama | `ollama` | Re-pull from registry, or backup `/var/lib/docker/volumes/open-local-ai-platform_ollama` |
| Open WebUI | `open-webui` | Export via UI settings, or backup volume |
| Paperless | `paperless-db`, `paperless-data`, `paperless-media`, `paperless-export` | `docker exec paperless document_exporter ../export` then backup export volume |
| Perplexica | `perplexica` | Re-index from search history |
| Blinko | `blinko` | Backup volume |
| Karakeep | `karakeep` | Backup volume |
| Open Notebook | `open-notebook` | Backup volume |

## Backup strategies

### 1. Docker volume snapshots (simplest)

If your host supports filesystem snapshots (LVM, ZFS, Btrfs, Proxmox, cloud provider snapshots):

```bash
# Stop containers for consistent snapshot
make down

# Take snapshot of all volumes
# (example for LVM)
sudo lvcreate -L 10G -s -n platform-backup /dev/vg0/docker-volumes

# Restart
make up
```

### 2. restic (recommended for remote backup)

```bash
# Install restic
sudo apt install restic  # Linux
brew install restic       # macOS

# Initialize repository (e.g., on external drive or S3)
restic -r /mnt/backup/init

# Backup volumes
docker run --rm -v open-local-ai-platform_ollama:/data:ro -v /mnt/backup:/backup \
  restic backup /data --repo /backup

# Or backup all volumes at once
for vol in $(docker volume ls --format '{{.Name}}' | grep open-local-ai); do
  docker run --rm -v "$vol":/data:ro -v /mnt/backup:/backup \
    restic backup /data --repo /backup
done
```

### 3. Paperless-specific backup

Paperless has a built-in exporter:

```bash
# Export all documents
docker exec paperless document_exporter ../export

# Backup the export volume
docker run --rm -v open-local-ai-platform_paperless-export:/data:ro \
  -v $(pwd)/backups:/backup alpine tar czf /backup/paperless-export.tar.gz -C /data .
```

## Restore procedures

### Restore configuration

```bash
# Copy backup contents back to project root
cp -r backups/YYYYMMDD-HHMMSS/compose/* compose/
cp backups/YYYYMMDD-HHMMSS/.env .env
cp -r backups/YYYYMMDD-HHMMSS/config/* config/

# Validate and start
make validate
make up
```

### Restore Docker volumes

```bash
# Stop containers
make down

# Restore a volume (example: ollama)
docker run --rm -v open-local-ai-platform_ollama:/data -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/ollama-backup.tar.gz -C /data

# Restart
make up
```

### Restore Paperless

```bash
# 1. Start Paperless
make up

# 2. Copy export files into consume directory
docker cp backups/YYYYMMDD-HHMMSS/paperless-export/. paperless:/usr/src/paperless/export/

# 3. Trigger import via UI or CLI
docker exec paperless document_importer ../export
```

## Automated backups

### cron (Linux)

```bash
# Edit crontab
crontab -e

# Daily backup at 2 AM
0 2 * * * cd /path/to/open-local-ai-platform && make backup >> /var/log/platform-backup.log 2>&1

# Weekly full volume backup (requires restic)
0 3 * * 0 cd /path/to/open-local-ai-platform && ./scripts/backup-volumes.sh >> /var/log/platform-backup.log 2>&1
```

### systemd timer (Linux)

See the systemd documentation in the repo for a service/timer pair.

## Security notes

- `.env` contains secrets. If backing up to a shared location, encrypt the backup.
- Docker volume backups may contain database credentials, API keys, or user data.
- Test restores periodically to verify backup integrity.
