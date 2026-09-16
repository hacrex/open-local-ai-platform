# Installation Guide

## 1. Host OS

Recommended: Ubuntu 24.04 LTS or another current Linux distribution with Docker Engine.

Windows and macOS can run the stack through Docker Desktop, but Linux is preferable for GPU passthrough, storage, and home-lab operations.

## 2. Install Docker

On Ubuntu, use Docker's official installation method. Verify:

```bash
docker --version
docker compose version
```

The repository assumes Docker Compose v2.

## 3. Clone and configure

```bash
git clone https://github.com/YOUR_USERNAME/open-local-ai-platform.git
cd open-local-ai-platform
cp .env.example .env
```

Generate strong secrets before exposing services beyond localhost.

## 4. Start core services

```bash
docker compose -f compose/docker-compose.yml up -d
```

Check:

```bash
docker compose -f compose/docker-compose.yml ps
```

## 5. Download a model

```bash
docker exec -it ollama ollama pull llama3.2
```

For coding, choose a model appropriate to your RAM/VRAM. See `MODELS.md`.

## 6. Start productivity services

```bash
docker compose \
  -f compose/docker-compose.yml \
  -f compose/docker-compose.productivity.yml up -d
```

## 7. Start coding environment

```bash
mkdir -p workspace

docker compose \
  -f compose/docker-compose.yml \
  -f compose/docker-compose.coding.yml up -d
```

Then use VS Code/Continue or the browser-based code-server. Point clients at:

```text
http://localhost:11434
```

## 8. NVIDIA GPU support

Install the NVIDIA driver and NVIDIA Container Toolkit on the host. Then validate GPU visibility:

```bash
nvidia-smi
docker run --rm --gpus all nvidia/cuda:12.6.3-base-ubuntu24.04 nvidia-smi
```

Exact CUDA image tags evolve; choose a currently supported tag for your host driver.

## 9. Production note

Do not expose Open WebUI, Ollama, SearXNG, Paperless, or code-server directly to the public internet without authentication, TLS, network isolation, and a reverse proxy. Prefer Tailscale/WireGuard for private remote access.
