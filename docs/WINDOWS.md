# Windows Support Guide

This platform runs on Windows via **Docker Desktop**. All compose files, scripts, and the PowerShell runner work natively on Windows.

## Prerequisites

1. **Docker Desktop for Windows** — https://www.docker.com/products/docker-desktop/
   - Enable **WSL 2 backend** (recommended) or Hyper-V
   - Ensure Docker Desktop is running before any commands
2. **Git** (for cloning) — https://git-scm.com/download/win
3. **PowerShell 5.1+** (comes with Windows 10/11)

## Quick start

### Option A: Double-click (easiest)

1. Download or clone the repository
2. Double-click `run.bat`
3. Choose a command from the menu

### Option B: PowerShell

```powershell
cd open-local-ai-platform

# First-time setup
.\run.ps1 install

# Start everything
.\run.ps1 all
```

### Option C: Docker commands directly

```powershell
# Create .env
Copy-Item .env.example .env

# Start core
docker compose -f compose/docker-compose.yml up -d

# Start all
docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml -f compose/docker-compose.productivity.yml -f compose/docker-compose.vibecoding.yml -f compose/docker-compose.daily.yml up -d
```

## All available commands

| Command | What it does |
|---------|-------------|
| `.\run.ps1 install` | First-time setup |
| `.\run.ps1 up` | Start core services |
| `.\run.ps1 down` | Stop and remove containers |
| `.\run.ps1 stop` | Stop containers without removing |
| `.\run.ps1 logs` | Tail all logs |
| `.\run.ps1 logs ollama` | Tail specific service logs |
| `.\run.ps1 ps` | Show running containers |
| `.\run.ps1 pull` | Pull latest images |
| `.\run.ps1 coding` | Start core + code-server |
| `.\run.ps1 coding-down` | Stop code-server |
| `.\run.ps1 productivity` | Start core + productivity apps |
| `.\run.ps1 prod-down` | Stop productivity apps |
| `.\run.ps1 vibecoding` | Start core + TabbyML, Open Interpreter |
| `.\run.ps1 vibe-down` | Stop vibecoding apps |
| `.\run.ps1 daily` | Start core + n8n, Khoj, LibreChat |
| `.\run.ps1 daily-down` | Stop daily apps |
| `.\run.ps1 all` | Start everything |
| `.\run.ps1 update` | Pull + recreate |
| `.\run.ps1 backup` | Back up config |
| `.\run.ps1 health` | Check service health |
| `.\run.ps1 validate` | Validate compose files |

Or use `run.bat` with the same commands (without `.\` prefix):

```powershell
run.bat install
run.bat all
run.bat down
```

## Windows-specific notes

### File paths

Docker Desktop on Windows translates paths automatically. The `workspace/` directory maps correctly between Windows and containers.

If you need to mount a Windows path (e.g., `D:\my-projects`), edit `.env`:

```bash
WORKSPACE_DIR=D:/my-projects
```

Use forward slashes (`/`) in `.env` — Docker handles the conversion.

### GPU support

NVIDIA GPU passthrough works on Windows with:
1. Latest NVIDIA GPU driver installed
2. Docker Desktop with WSL 2 backend enabled
3. NVIDIA Container Toolkit installed in the WSL 2 distribution

```powershell
# In WSL 2:
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
```

Then in `.env`:

```bash
NVIDIA_VISIBLE_DEVICES=0
NVIDIA_DEVICE_COUNT=1
```

### Performance tips

- **WSL 2 backend** is significantly faster than Hyper-V for file I/O
- Store the project on an **SSD** (not HDD)
- Allocate at least **4GB RAM** to Docker Desktop (Settings > Resources)
- Enable **VirtIOFS** file sharing if available (Settings > General)

### Firewall

Windows Firewall may prompt for network access when Docker containers expose ports. Allow access for the services you need.

### Ports in use

If a port is already in use, change it in `.env`:

```bash
OPEN_WEBUI_PORT=3001
OLLAMA_PORT=11435
```

## Troubleshooting

### "Docker is not running"

- Open Docker Desktop and wait for it to fully start (green icon in system tray)
- Check WSL 2 is enabled: `wsl --status`

### Containers fail to start

- Check Docker Desktop resources (Settings > Resources): increase memory to 8GB+
- Check port conflicts: `netstat -ano | findstr :3000`

### Slow performance

- Switch to WSL 2 backend if using Hyper-V
- Move the project to an SSD
- Increase Docker Desktop memory allocation

### Path issues

- Use forward slashes in `.env` files: `WORKSPACE_DIR=D:/my-projects` (not `D:\my-projects`)
- Docker Desktop handles path translation automatically for compose files

## Comparison: Linux vs Windows

| Feature | Linux (Docker Engine) | Windows (Docker Desktop) |
|---------|----------------------|-------------------------|
| Performance | Native | ~5-10% overhead (WSL 2) |
| GPU passthrough | Native | Via WSL 2 + NVIDIA toolkit |
| Makefile | `make <target>` | `.\run.ps1 <target>` or `run.bat <target>` |
| Shell scripts | Bash | Git Bash / PowerShell |
| Auto-start | systemd | Docker Desktop startup + WSL 2 |
| File I/O | Native | WSL 2 bridge (use SSD) |
