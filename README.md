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

### Coding
- **code-server** — browser-based VS Code IDE
- **TabbyML** — self-hosted GitHub Copilot alternative (code completion + chat)
- **Open Interpreter** — AI code execution in terminal

### Daily Driver
- **n8n** — workflow automation with 1500+ integrations and AI agents
- **Khoj** — AI personal assistant with memory and document indexing
- **LibreChat** — multi-model chat platform (Ollama, OpenAI, Anthropic, Gemini)

### Infrastructure & Home Lab
- **Pulse** — infrastructure monitoring and AI-assisted analysis

## Architecture

```text
                         +----------------------+
                         |      Your Browser     |
                         +----------+-----------+
                                    |
              +---------------------+---------------------+
              |                     |                     |
     +--------v--------+  +--------v--------+  +---------v--------+
     |   Open WebUI    |  |    LibreChat    |  |     TabbyML      |
     |   Chat / RAG    |  |  Multi-model    |  |  Code Completion |
     +--------+--------+  +--------+--------+  +---------+--------+
              |                     |                     |
              +----------+----------+----------+----------+
                         |                     |
                +--------v--------+  +---------v--------+
                |  Ollama Runtime |  |   Perplexica     |
                | Local LLMs      |  |  AI Search       |
                +---+------+------+  +---+--------------+
                    |      |             |
           +--------v--+ +-v--------+ +--v---------+
           |  SearXNG  | | n8n      | | Khoj       |
           |  Search   | | Workflows| | Assistant  |
           +-----------+ +----------+ +------------+

  Optional: Paperless, Blinko, Karakeep, Pulse,
  Open Notebook, code-server, Open Interpreter
```

## Repository layout

```text
open-local-ai-platform/
├── README.md
├── LICENSE
├── Makefile              # Linux/macOS commands
├── run.ps1               # Windows PowerShell commands
├── run.bat               # Windows double-click quick start
├── .env.example
├── .gitignore
├── .editorconfig
├── compose/
│   ├── docker-compose.yml
│   ├── docker-compose.coding.yml
│   ├── docker-compose.productivity.yml
│   ├── docker-compose.vibecoding.yml
│   └── docker-compose.daily.yml
├── config/
│   └── open-webui/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── BACKUP.md
│   ├── CODING.md
│   ├── INSTALL.md
│   ├── MODELS.md
│   ├── OPERATIONS.md
│   ├── REVERSE-PROXY.md
│   ├── ROADMAP.md
│   ├── SECURITY.md
│   ├── STORAGE.md
│   ├── SYSTEM-REQUIREMENTS.md
│   ├── SYSTEMD.md
│   ├── TROUBLESHOOTING.md
│   ├── VIBECODING.md
│   └── WINDOWS.md
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

## Commands

### Linux / macOS

```bash
make help    # Show all available commands
```

```
  up                    Start core services
  down                  Stop and remove core containers
  coding                Start core + coding overlay
  productivity          Start core + productivity overlay
  vibecoding            Start core + vibecoding overlay
  daily                 Start core + daily driver overlay
  all                   Start all overlays
  install               Run the installer
  update                Pull latest images and recreate containers
  health                Check health of running services
```

### Windows

```powershell
.\run.ps1 help    # Show all available commands
```

```powershell
.\run.ps1 up              # Start core
.\run.ps1 all             # Start everything
.\run.ps1 down            # Stop everything
.\run.ps1 health          # Check health
```

Or double-click `run.bat` for a menu.

## Compose overlays

The repo separates the platform into modular layers. Mix and match based on your hardware.

| Overlay | Linux | Windows | Services added |
|---------|-------|---------|----------------|
| Core | `make up` | `.\run.ps1 up` | Ollama, Open WebUI, SearXNG, Perplexica |
| Coding | `make coding` | `.\run.ps1 coding` | code-server (browser VS Code) |
| Vibecoding | `make vibecoding` | `.\run.ps1 vibecoding` | TabbyML, Open Interpreter |
| Productivity | `make productivity` | `.\run.ps1 productivity` | Paperless, Blinko, Karakeep, Pulse, Open Notebook |
| Daily | `make daily` | `.\run.ps1 daily` | n8n, Khoj, LibreChat |
| All | `make all` | `.\run.ps1 all` | Everything |

## Hardware recommendations (32GB RAM + 2GB GPU)

| Overlay | RAM needed | Runs well? |
|---------|-----------|------------|
| Core only | ~17G | Yes, comfortably |
| Core + coding | ~19G | Yes |
| Core + vibecoding | ~27G | Yes (TabbyML needs 8G) |
| Core + productivity | ~29G | Tight, reduce Ollama limit |
| Core + daily | ~23G | Yes |
| Everything | ~40G+ | Reduce limits, run selectively |

For 32GB RAM, use `OLLAMA_MEMORY_LIMIT=4G` and run overlays selectively.

## Installation

### Windows (Docker Desktop)

1. Install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) (enable WSL 2 backend)
2. Clone the repo:

```powershell
git clone https://github.com/YOUR_USERNAME/open-local-ai-platform.git
cd open-local-ai-platform
```

3. Start everything:

```powershell
# Option A: PowerShell
.\run.ps1 install

# Option B: Double-click run.bat
```

4. Open `http://localhost:3000`

See `docs/WINDOWS.md` for detailed Windows setup, GPU support, and troubleshooting.

### Linux (Docker Engine)

```bash
# Install Docker Engine (Ubuntu/Debian)
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

#### NVIDIA GPU support (optional)

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

#### Quick install

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

Usable for small quantized models, embeddings, Open WebUI, and lightweight services.

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

## Additional documentation

- `docs/ARCHITECTURE.md` — system design and service interactions
- `docs/INSTALL.md` — detailed installation guide
- `docs/WINDOWS.md` — Windows Docker Desktop setup and troubleshooting
- `docs/CODING.md` — coding setup with Continue, Aider, and IDE clients
- `docs/VIBECODING.md` — TabbyML and Open Interpreter setup
- `docs/MODELS.md` — model selection guidance
- `docs/SECURITY.md` — threat model and security rules
- `docs/STORAGE.md` — recommended directory layout
- `docs/OPERATIONS.md` — day-to-day operations guide
- `docs/BACKUP.md` — backup and restore procedures
- `docs/TROUBLESHOOTING.md` — common issues and fixes
- `docs/SYSTEMD.md` — auto-start on Linux boot
- `docs/REVERSE-PROXY.md` — TLS and remote access setup
- `docs/ROADMAP.md` — development roadmap

## License

Apache-2.0. See `LICENSE`.
