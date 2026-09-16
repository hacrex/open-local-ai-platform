# Local AI Coding Setup

## Goal

Use the same local inference layer for:

- code explanation
- code generation
- refactoring
- test generation
- shell commands
- debugging
- repository Q&A
- documentation

## Recommended pattern

```text
IDE (VS Code / JetBrains / Neovim)
          |
      local client
          |
   Ollama OpenAI-compatible API
          |
      coding model
```

Ollama exposes a local API at:

```text
http://localhost:11434
```

Many coding clients can connect to an OpenAI-compatible endpoint. Check the client's current documentation for the exact provider settings.

## Model strategy

Keep at least two local models:

1. **Fast model** for autocomplete, short edits, and routine explanations.
2. **Stronger coding/reasoning model** for architecture, debugging, tests, and larger refactors.

Use a separate embedding model for repository/document retrieval when your tool supports it.

## Coding workflow

```text
Git repository
   |
   +--> IDE / code-server
   |
   +--> local coding model
   |
   +--> tests / linters / type checker
   |
   +--> human review
   |
   +--> git commit / PR
```

Local AI should propose changes; deterministic tooling should validate them.

## Useful tools

- VS Code + Continue
- code-server
- Aider
- Open WebUI
- Neovim clients
- JetBrains AI-compatible integrations

Check each project’s current documentation before configuring endpoints because client UX and supported protocols change over time.

## Safety for coding agents

Do not grant a local coding agent unrestricted shell, Docker socket, production credentials, SSH keys, or Kubernetes admin access. Prefer a disposable workspace, least-privilege credentials, and explicit review before destructive commands.
