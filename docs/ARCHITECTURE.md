# Architecture

## Design principles

1. **Local-first** — inference stays on your infrastructure by default.
2. **Composable** — applications consume a shared inference service.
3. **Open protocols** — prefer APIs that allow different clients and models.
4. **Replaceable components** — any application or model can be swapped.
5. **Observable** — treat AI workloads like platform workloads.
6. **Least privilege** — AI agents should not automatically inherit host or cluster admin access.

## Planes

### Inference plane
Ollama, models, embeddings, optional GPU acceleration.

### Experience plane
Open WebUI and coding clients.

### Knowledge plane
Paperless, Open Notebook, Blinko, Karakeep, vector/RAG components.

### Web intelligence plane
SearXNG + Perplexica.

### Operations plane
Pulse plus your normal Prometheus/Grafana/OpenTelemetry stack.

## Future extensions

- LiteLLM gateway
- OpenAI-compatible model routing
- Qdrant or pgvector
- MinIO/S3-compatible object storage
- Prometheus + Grafana
- OpenTelemetry
- Vault / SOPS / age
- Kubernetes deployment
- GPU scheduling
- multi-node inference
- MCP servers
