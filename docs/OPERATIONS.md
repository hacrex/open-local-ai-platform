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
```

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
