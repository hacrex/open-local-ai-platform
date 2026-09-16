# Systemd Auto-Start (Linux)

For headless Linux servers, you can auto-start the platform on boot using systemd.

## Prerequisites

- Docker Engine installed and enabled
- This repository cloned to a fixed path (e.g., `/opt/open-local-ai-platform`)

## Create the service

```bash
sudo tee /etc/systemd/system/open-local-ai.service << 'EOF'
[Unit]
Description=Open Local AI Platform
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/open-local-ai-platform
ExecStart=/usr/bin/docker compose -f compose/docker-compose.yml up -d
ExecStop=/usr/bin/docker compose -f compose/docker-compose.yml down
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
EOF
```

## Optional: Include overlays

If you always run coding or productivity overlays, add them:

```bash
# For coding overlay
ExecStart=/usr/bin/docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml up -d
ExecStop=/usr/bin/docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml down

# For all overlays
ExecStart=/usr/bin/docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml -f compose/docker-compose.productivity.yml up -d
ExecStop=/usr/bin/docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml -f compose/docker-compose.productivity.yml down
```

## Enable and start

```bash
sudo systemctl daemon-reload
sudo systemctl enable open-local-ai.service
sudo systemctl start open-local-ai.service

# Check status
sudo systemctl status open-local-ai.service
```

## View logs

```bash
journalctl -u open-local-ai.service -f
```

## Note on restart behavior

The compose files use `restart: unless-stopped`, which means Docker will automatically restart containers if the Docker daemon restarts. The systemd service is an additional safety net for ensuring the full stack comes up cleanly on boot.

If you prefer Docker's restart policy alone (without systemd), you can skip the systemd setup entirely — just ensure Docker is enabled:

```bash
sudo systemctl enable docker
```
