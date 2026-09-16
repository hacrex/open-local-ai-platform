# Open WebUI Configuration

Place custom Open WebUI configuration files in this directory.

**Note:** This directory is not currently mounted into the container by default.
To use custom configuration, add a volume mount to your compose file or
`.env` override:

```yaml
# In a custom compose override file:
services:
  open-webui:
    volumes:
      - ./config/open-webui:/app/backend/config:ro
```

See: https://docs.open-webui.com/configuration
