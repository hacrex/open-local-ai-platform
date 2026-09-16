# Operations

## Common commands

```bash
# status
docker compose -f compose/docker-compose.yml ps

# logs
docker compose -f compose/docker-compose.yml logs -f ollama

# restart a service
docker compose -f compose/docker-compose.yml restart open-webui

# update images
docker compose -f compose/docker-compose.yml pull
docker compose -f compose/docker-compose.yml up -d

# check disk usage
docker system df

# prune unused resources
docker system prune -f
```

Or use the Makefile shortcuts:

```bash
make ps           # show running containers
make logs         # tail all core logs
make logs-ollama  # tail ollama logs only
make update       # pull + recreate
make health       # check all services
```

## Adding/removing services

### Adding a service from an overlay

Start the overlay alongside core:

```bash
# Add coding services
make coding

# Add productivity services
make productivity

# Add everything
make all
```

### Removing an overlay

Stop and remove overlay containers without affecting core:

```bash
make coding-down
make productivity-down
```

### Adding a new service

1. Add the service definition to the appropriate compose file
2. Add a port variable to `.env.example`
3. Add a healthcheck
4. Add `security_opt`, `cap_drop`, and `logging` blocks
5. Add the service to `healthcheck.sh`
6. Update documentation

## Resource management

### Checking resource usage

```bash
# Docker stats (live)
docker stats --no-stream

# Per-container memory/CPU
docker stats --format "table {{.Name}}\t{{.MemUsage}}\t{{.CPUPerc}}"
```

### Adjusting Ollama resources

Edit `.env`:

```bash
# Limit Ollama to 16GB RAM
OLLAMA_MEMORY_LIMIT=16G
OLLAMA_MEMORY_RESERVE=4G

# Allow 4 parallel requests
OLLAMA_NUM_PARALLEL=4
```

Then recreate: `docker compose -f compose/docker-compose.yml up -d`

### GPU configuration

For NVIDIA GPUs, ensure `nvidia-container-toolkit` is installed, then in `.env`:

```bash
NVIDIA_VISIBLE_DEVICES=0    # GPU index (0 for single GPU)
NVIDIA_DEVICE_COUNT=1       # Number of GPUs to expose
```

## Disk management

### Log rotation

All services are configured with log rotation (10MB, 3 files). To adjust, edit the `logging` section in compose files.

### Cleaning up

```bash
# Remove unused images
docker image prune -f

# Remove unused volumes (WARNING: destroys data)
docker volume prune -f

# Full cleanup (WARNING: removes everything unused)
docker system prune -af --volumes
```

### Backup and restore

See [BACKUP.md](BACKUP.md) for backup and restore procedures.

## Monitoring

### Container health

```bash
# Quick health check
make health

# Docker health status
docker inspect --format '{{.State.Health.Status}}' ollama
```

### Service-specific operations

| Service | Data location | Backup command |
|---------|--------------|----------------|
| Ollama | `ollama` volume | Re-pull models from registry |
| Open WebUI | `open-webui` volume | Export via UI settings |
| Paperless | `paperless-*` volumes | `docker exec paperless document_exporter ../export` |
| Perplexica | `perplexica` volume | Re-index from search history |

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.

## Capacity

Watch:

- CPU utilization
- RAM pressure/swap
- GPU VRAM and utilization
- model load time
- tokens/sec
- request queue depth
- context length
- disk free space
- container restarts

AI quality and infrastructure reliability are connected: latency spikes often originate from memory pressure, oversubscription, or context growth rather than the model alone.
