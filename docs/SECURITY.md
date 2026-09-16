# Security

## Threat model

This platform combines private data, powerful models, network access, code execution, and potentially sensitive infrastructure telemetry. Treat it as an internal platform, not as a toy web app.

## Rules

- Bind administrative services to trusted interfaces.
- Use strong secrets.
- Put internet-facing access behind TLS and authentication.
- Prefer VPN/Tailscale/WireGuard for remote access.
- Never mount `/` into AI containers.
- Avoid mounting `/var/run/docker.sock` unless the service requires it.
- Keep Docker images updated and review image provenance.
- Scan images where practical.
- Back up application data separately from model caches.
- Do not put cloud credentials in prompts or persistent chat history.
- Treat web search results as untrusted input.
- Require human review for destructive coding or infrastructure actions.

## Public exposure

Ollama's API is not a replacement for an authenticated API gateway. If remote clients need access, place a proper gateway or reverse proxy in front of it.
