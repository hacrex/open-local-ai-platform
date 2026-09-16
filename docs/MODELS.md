# Model Strategy

The platform is model-agnostic. Ollama can host whichever local models your hardware supports.

## Suggested roles

| Role | What to optimize |
|---|---|
| General chat | Quality/latency balance |
| Coding | Code reasoning + instruction following |
| Embeddings | Retrieval quality + low memory |
| Vision | OCR/image understanding |
| Small utility | Very low latency |
| Large reasoning | Maximum quality within available VRAM/RAM |

## Examples to evaluate

Model families change frequently. At setup time, compare current Ollama catalog options such as Llama, Qwen, Gemma, DeepSeek, Mistral, and other maintained families.

Pull examples with:

```bash
ollama pull llama3.2
```

Do not treat a specific model as permanently "best". Benchmark on your actual workloads, context sizes, and hardware.

## Quantization

Use quantized variants when you need to fit larger models into local memory. Benchmark quality and throughput against your real prompts; smaller memory usage can come with quality trade-offs.
