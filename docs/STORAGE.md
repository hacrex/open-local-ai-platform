# Storage

## Recommended layout

```text
/opt/open-local-ai-platform/
├── compose/
├── config/
├── workspace/
└── backups/

/mnt/ai-models/
└── ollama/
```

Use fast SSD/NVMe for model storage and application databases.

## Backup priorities

Back up:

- Open WebUI application data
- Paperless database and media
- Open Notebook data
- Blinko data
- Karakeep data
- configuration and secrets (encrypted)

Model caches generally do not need backup if they can be re-downloaded.
