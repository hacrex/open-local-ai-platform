# Vibecoding Setup

Guide for AI-powered coding tools in this platform.

## TabbyML — Self-hosted GitHub Copilot

Tabby provides code completion, chat, and repository indexing without sending code to external servers.

### Start

```bash
make vibecoding
# or
docker compose -f compose/docker-compose.yml -f compose/docker-compose.vibecoding.yml up -d tabby
```

### First-time setup

1. Open `http://localhost:8080` in your browser
2. Create an admin account
3. Go to **Settings > Models**
4. Select a model (recommend `StarCoder-1B` for 32GB RAM, or `Deepseek-Coder-1.3B` for less)
5. Wait for the model to download

### Connect your IDE

**VS Code:**
1. Install the [Tabby extension](https://marketplace.visualstudio.com/items?itemName=TabbyML.vscode-tabby)
2. Set endpoint to `http://localhost:8080`
3. Enable inline completions

**JetBrains:**
1. Install the Tabby plugin from marketplace
2. Configure the endpoint URL

**Vim/Neovim:**
Tabby provides a Vim plugin. See [Tabby docs](https://tabby.tabbyml.com/docs/ide/vim).

### Configuration

Tabby uses a TOML config file. Mount a custom config:

```yaml
# In docker-compose.override.yml:
services:
  tabby:
    volumes:
      - ./config/tabby/config.toml:/config/config.toml:ro
```

Example `config/tabby/config.toml`:

```toml
[model]
backend = "local"
name = "StarCoder-1B"

[chat]
model = "StarCoder-1B"
```

### Resource usage

| Model | RAM | VRAM | Speed |
|-------|-----|------|-------|
| StarCoder-1B | 3G | Optional | Fast |
| Deepseek-Coder-1.3B | 3G | Optional | Fast |
| StarCoder-7B | 8G | Recommended | Medium |

## Open Interpreter — Terminal AI Coding

Open Interpreter lets you run code locally via natural language. It connects to Ollama.

### Usage

```bash
# Start an interactive session
docker exec -it open-interpreter bash

# Or run a one-shot command
docker run --rm -v ./workspace:/workspace --network open-local-ai-platform_inference \
  python:3.12-slim sh -c "pip install -q open-interpreter && interpreter --api_base http://ollama:11434/v1 --model ollama/codellama:7b-code -t 'write a hello world in python'"
```

### Connect to Ollama

Open Interpreter uses the OpenAI-compatible API. Any model in Ollama works:

```bash
# Use a different model
docker exec -it open-interpreter bash -c \
  "pip install -q open-interpreter && interpreter --api_base http://ollama:11434/v1 --model ollama/llama3.2"
```

## Continue.dev — IDE Extension (not a service)

Continue is a VS Code/JetBrains extension that connects to Ollama. It runs inside your IDE, not as a Docker service.

### Setup

1. Install [Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue) in VS Code
2. Open Continue settings (Ctrl+Shift+P > "Continue: Open Settings")
3. Configure the Ollama provider:

```json
{
  "models": [
    {
      "title": "Local LLM",
      "provider": "ollama",
      "model": "llama3.2"
    }
  ]
}
```

4. The extension will automatically connect to `http://localhost:11434`

## Aider — Terminal Pair Programming (not a service)

Aider is a CLI tool for AI pair programming. Run it outside Docker, connecting to Ollama.

### Setup

```bash
pip install aider-chat

# Use with Ollama
aider --model ollama/deepseek-coder --no-auto-commits
```

See `docs/CODING.md` for more details on Aider and other IDE clients.
