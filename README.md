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
- **Paperless-GPT** — AI-assisted document processing
- **Open Notebook** — private research/RAG workspace
- **Blinko** — notes and personal knowledge
- **Karakeep** — bookmarks and saved web content

### Infrastructure & Home Lab
- **Pulse** — infrastructure monitoring and AI-assisted analysis
- **Home Assistant** — optional AI voice/automation layer
- **Frigate** — optional local computer-vision layer

### Coding
- **Open WebUI** for coding chat and model-driven workflows
- **Continue** or other OpenAI-compatible IDE clients can connect to Ollama
- Optional coding model presets are documented for Qwen, DeepSeek, Code Llama-compatible, and other Ollama-supported models

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
          Karakeep, Pulse, Home Assistant, Frigate
```

## Repository layout

```text
open-local-ai-platform/
├── README.md
├── LICENSE
├── .env.example
├── .gitignore
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
│   └── TROUBLESHOOTING.md
├── scripts/
│   ├── install.sh
│   ├── update.sh
│   ├── backup.sh
│   └── healthcheck.sh
└── .github/workflows/
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

Review the variables before starting.

### 3. Start the core platform

```bash
docker compose -f compose/docker-compose.yml up -d
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

## Compose profiles

The repo deliberately separates the platform into layers.

### Core

```bash
docker compose -f compose/docker-compose.yml up -d
```

### Core + coding helper services

```bash
docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml up -d
```

### Productivity services

```bash
docker compose -f compose/docker-compose.yml -f compose/docker-compose.productivity.yml up -d
```

Run only what your hardware can comfortably support.

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
- NVIDIA GPU with 12–16 GB VRAM, or a comparable accelerator

This is a practical starting point for coding models, RAG, web research, and several concurrent services.

### Comfortable local AI workstation
- 12–16+ CPU cores
- 64 GB RAM
- 2 TB+ NVMe
- NVIDIA GPU with 24 GB+ VRAM

Suitable for larger quantized models, coding workloads, RAG pipelines, and multiple containers.

### Serious homelab / AI server
- 16+ CPU cores
- 128 GB+ RAM
- 4 TB+ NVMe/SSD
- 24–48 GB+ VRAM or multiple GPUs
- 10 GbE helpful for shared storage and multi-node setups

See `docs/SYSTEM-REQUIREMENTS.md` for workload-oriented sizing.

## Privacy model

The default architecture keeps model inference on your machine. However, external web search and any third-party APIs you configure can send data outside your environment. Review each service and set network access according to your threat model.

## License

Apache-2.0. See `LICENSE`.
