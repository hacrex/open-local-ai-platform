# System Requirements

Sizing depends more on model size, quantization, context length, concurrency, embeddings, and storage than on application count alone.

## Minimum viable setup

| Component | Minimum |
|---|---|
| CPU | 4 cores |
| RAM | 16 GB |
| Storage | 100 GB SSD |
| GPU | Optional |
| OS | Linux recommended |
| Docker | Engine + Compose v2 |
| Network | 1 GbE |

Good for: 3B–8B quantized models, basic chat, small RAG experiments, and one or two lightweight services.

## Recommended developer machine

| Component | Recommended |
|---|---|
| CPU | 8+ cores |
| RAM | 32 GB |
| Storage | 1 TB NVMe |
| GPU | 12–16 GB VRAM |
| Network | 1 GbE |

Good for: coding assistants, RAG, web research, document processing, and moderate container concurrency.

## 24 GB VRAM workstation

| Component | Target |
|---|---|
| CPU | 12+ cores |
| RAM | 64 GB |
| Storage | 2 TB NVMe |
| GPU | 24 GB VRAM |
| Network | 2.5/10 GbE helpful |

Good for: larger quantized models, long contexts, coding, embeddings, reranking, and multiple AI applications.

## 48 GB+ / server class

| Component | Target |
|---|---|
| CPU | 16+ cores |
| RAM | 128 GB+ |
| Storage | 4 TB+ NVMe |
| GPU | 48 GB+ VRAM or multiple GPUs |
| Network | 10 GbE |

Good for: larger MoE models, multi-user inference, parallel workflows, and a broader self-hosted AI platform.

## Storage planning

Reserve separate fast storage for model files. Model size can quickly exceed application data. Keep backups of Paperless media, Open WebUI data, databases, and configuration separately from model caches.

## GPU sizing rule of thumb

VRAM requirements are workload dependent. Quantization reduces memory use, but KV cache and context length can still dominate for long prompts. Leave headroom for the OS and containers rather than sizing the GPU to the theoretical minimum.
