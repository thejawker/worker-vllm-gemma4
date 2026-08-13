# worker-gemma4 — custom vLLM worker image

Stock `runpod/worker-v1-vllm` cannot load any Gemma 4 checkpoint: its
transformers 5.15.0 exposes Gemma 4's `head_dim` per layer, and the bundled
vLLM 0.27.0 reads it globally → `AmbiguousGlobalPerLayerAttributeError` at
`ModelConfig` init ([vLLM #51744](https://github.com/vllm-project/vllm/issues/51744)).

This image is the stock worker plus `transformers==5.14.1`.

## Build and push

```sh
docker buildx build --platform linux/amd64 \
  -t <registry>/worker-vllm-gemma4:v2.25.0-tf5.14.1 \
  --push runpod/worker-gemma4
```

`--platform linux/amd64` matters: RunPod GPUs are x86, and a Mac would
otherwise build arm64. Push to Docker Hub if you can — the 9 GB of base layers
are already there, so the registry mounts them instead of re-uploading.

Keep the image public, or add registry credentials to the RunPod endpoint.

## Retire it

When RunPod ships a worker on vLLM >= 0.27.2 (which contains
[PR #49797](https://github.com/vllm-project/vllm/pull/49797)), delete this
directory, drop the template, and recreate the endpoint on the stock hub
listing like the other models.
