# Open Local AI Platform

> A self-hosted, open-source local AI platform for chat, coding, research, documents, knowledge management, web search, and infrastructure operations.

Run capable AI workloads on your own hardware using Docker Compose. The stack is designed around one principle:

**Run the model once. Turn it into a platform capability for many applications.**

## What this repo provides

### Core AI
- **Ollama** — local model runtime
- **Open WebUI** — web interface for local LLMs
- **SearXNG** — privacy-friendly metasearch backend
- **Perplexica** — AI-powered web research connected to local models

### Knowledge & Documents
- **Paperless-ngx** — document archive and OCR
- **Open Notebook** — private research/RAG workspace
- **Blinko** — notes and personal knowledge
- **Karakeep** — bookmarks and saved web content

### Infrastructure & Home Lab
- **Pulse** — infrastructure monitoring and AI-assisted analysis

### Coding
- **code-server** — browser-based VS Code IDE
- **Open WebUI** for coding chat and model-driven workflows
- **Continue** or other OpenAI-compatible IDE clients can connect to Ollama

## Architecture

```text
                         +----------------------+
                         |      Your Browser     |
                         +----------+-----------+
                                    |
                       +------------v-------------+
                       |       Open WebUI         |
                       |  Chat / RAG / Documents  |
                       +------------+-------------+
                                    |
                      +-------------v--------------+
                      |        Ollama Runtime     |
                      | Local LLMs + Embeddings   |
                      +---+----------+---------+---+
                          |          |         |
                 +--------v--+  +----v----+ +--v----------+
                 | Research  |  | Coding  | | Knowledge   |
                 |Perplexica |  | IDE/API | | RAG Apps    |
                 +-----+-----+  +----+----+ +------+------+
                       |             |             |
                 +-----v-----+  +----v----+  +-----v------+
                 |  SearXNG  |  | Git/IDE |  | Docs/Notes |
                 +-----------+  +---------+  +------------+

          Optional services: Paperless, Open Notebook, Blinko,
          Karakeep, Pulse
```

## Repository layout

```text
open-local-ai-platform/
├── README.md
├── LICENSE
├── Makefile
├── .env.example
├── .gitignore
├── .editorconfig
├── compose/
│   ├── docker-compose.yml
│   ├── docker-compose.coding.yml
│   └── docker-compose.productivity.yml
├── config/
│   └── open-webui/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── INSTALL.md
│   ├── SYSTEM-REQUIREMENTS.md
│   ├── CODING.md
│   ├── MODELS.md
│   ├── SECURITY.md
│   ├── STORAGE.md
│   ├── OPERATIONS.md
│   ├── ROADMAP.md
│   └── TROUBLESHOOTING.md
├── scripts/
│   ├── install.sh
│   ├── update.sh
│   ├── backup.sh
│   └── healthcheck.sh
├── workspace/
│   └── README.md
└── .github/
    └── workflows/
        └── compose-validate.yml
```

## Quick start

### 1. Clone

```bash
git clone https://github.com/YOUR_USERNAME/open-local-ai-platform.git
cd open-local-ai-platform
```

### 2. Configure

```bash
cp .env.example .env
```

Review the variables in `.env` before starting. All secrets have safe defaults for local use only.

### 3. Start the core platform

```bash
docker compose -f compose/docker-compose.yml up -d
```

Or use the Makefile:

```bash
make install
```

### 4. Pull a model

```bash
docker exec -it ollama ollama pull llama3.2
```

For coding, see `docs/CODING.md`.

### 5. Open the UI

- Open WebUI: `http://localhost:3000`
- Ollama API: `http://localhost:11434`
- Perplexica: `http://localhost:3001`
- SearXNG: `http://localhost:8080`

## Makefile

Run `make help` to see all available targets:

```
  up                    Start core services
  down                  Stop and remove core containers
  stop                  Stop core containers without removing
  logs                  Tail core service logs
  ps                    Show running containers
  pull                  Pull latest images for core services
  validate              Validate all compose files
  coding                Start core + coding overlay
  productivity          Start core + productivity overlay
  install               Run the installer
  update                Pull latest images and recreate containers
  backup                Back up compose config and env template
  health                Check health of all services
  lint                  Lint shell scripts (requires shellcheck)
  compose-lint          Lint compose files
```

## Compose profiles

The repo deliberately separates the platform into layers.

### Core

```bash
docker compose -f compose/docker-compose.yml up -d
# or
make up
```

### Core + coding helper services

```bash
docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml up -d
# or
make coding
```

### Productivity services

```bash
docker compose -f compose/docker-compose.yml -f compose/docker-compose.productivity.yml up -d
# or
make productivity
```

Run only what your hardware can comfortably support.

## Linux installation

### Prerequisites

```bash
# Docker Engine (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add your user to the docker group (logout/login required)
sudo usermod -aG docker $USER
```

### NVIDIA GPU support (optional)

```bash
# Install NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### Quick install

```bash
git clone https://github.com/YOUR_USERNAME/open-local-ai-platform.git
cd open-local-ai-platform
make install
```

## Minimum hardware

### Minimum / CPU-only lab
- 4 physical CPU cores
- 16 GB RAM
- 100 GB SSD free space
- Linux host recommended
- Docker Engine + Compose v2

Usable for small quantized models, embeddings, Open WebUI, and lightweight services. Expect slower generation and limited concurrency.

### Recommended developer workstation
- 8+ CPU cores
- 32 GB RAM
- 1 TB NVMe SSD
- NVIDIA GPU with 12-16 GB VRAM, or a comparable accelerator

This is a practical starting point for coding models, RAG, web research, and several concurrent services.

### Comfortable local AI workstation
- 12-16+ CPU cores
- 64 GB RAM
- 2 TB+ NVMe
- NVIDIA GPU with 24 GB+ VRAM

Suitable for larger quantized models, coding workloads, RAG pipelines, and multiple containers.

### Serious homelab / AI server
- 16+ CPU cores
- 128 GB+ RAM
- 4 TB+ NVMe/SSD
- 24-48 GB+ VRAM or multiple GPUs
- 10 GbE helpful for shared storage and multi-node setups

See `docs/SYSTEM-REQUIREMENTS.md` for workload-oriented sizing.

## Privacy model

The default architecture keeps model inference on your machine. However, external web search and any third-party APIs you configure can send data outside your environment. Review each service and set network access according to your threat model.

## License

Apache-2.0. See `LICENSE`.
