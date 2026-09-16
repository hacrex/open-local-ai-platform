# Troubleshooting

## Ollama is slow

Check CPU/RAM/GPU utilization:

```bash
docker stats
nvidia-smi
```

Test the model directly:

```bash
docker exec -it ollama ollama list
docker exec -it ollama ollama run llama3.2
```

## Open WebUI cannot see Ollama

From the Open WebUI container:

```bash
docker exec -it open-webui sh -lc 'wget -qO- http://ollama:11434/api/tags'
```

## Disk fills up

Find large Docker volumes/images:

```bash
docker system df
```

Remove unused resources carefully. Model volumes can be large.

## GPU is unavailable

Verify host GPU first:

```bash
nvidia-smi
```

Then verify Docker GPU support. If the host cannot see the GPU, the container cannot fix it.
