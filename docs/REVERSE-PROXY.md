# Reverse Proxy and TLS

All services bind to localhost by default. For remote access, use a reverse proxy with TLS.

## Recommended: Caddy (simplest)

Caddy auto-provisions HTTPS via Let's Encrypt.

### Install Caddy

```bash
# Ubuntu/Debian
sudo apt install -y caddy

# Or see https://caddyserver.com/docs/install
```

### Configure

```bash
sudo tee /etc/caddy/Caddyfile << 'EOF'
# Open WebUI
chat.example.com {
    reverse_proxy localhost:3000
}

# Ollama API (internal use only — protect with auth)
api.example.com {
    reverse_proxy localhost:11434
}

# Perplexica
search.example.com {
    reverse_proxy localhost:3001
}

# Paperless
docs.example.com {
    reverse_proxy localhost:8000
}

# Code Server
ide.example.com {
    reverse_proxy localhost:8443
}
EOF
```

### Start

```bash
sudo systemctl reload caddy
```

## Alternative: Nginx

```nginx
server {
    listen 443 ssl http2;
    server_name chat.example.com;

    ssl_certificate /etc/letsencrypt/live/chat.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/chat.example.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## Alternative: Traefik (Docker-native)

Add labels to your compose services and run Traefik as a container. See [Traefik docs](https://doc.traefik.io/traefik/) for Docker provider setup.

## Security reminders

- **Never** expose Ollama (11434) publicly without authentication — it has no auth layer.
- Use IP allowlisting or HTTP basic auth for internal services.
- Prefer Tailscale/WireGuard for private remote access over public TLS.
- See [SECURITY.md](SECURITY.md) for the full threat model.
