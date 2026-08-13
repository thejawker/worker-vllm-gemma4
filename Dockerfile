# Custom RunPod vLLM worker for Gemma 4.
#
# Why this image exists: RunPod's stock worker (v2.25.0 = vLLM 0.27.0) ships
# transformers 5.15.0, whose Gemma 4 config is heterogeneous (per-layer
# head_dim). vLLM 0.27.0/0.27.1 still read the global head_dim and die at
# ModelConfig init with AmbiguousGlobalPerLayerAttributeError, before any
# weights load — see vLLM issue #51744.
#
# The upstream fix (vLLM PR #49797, merged 2026-08-10) is in tag v0.27.2rc0 but
# has no published container yet, and RunPod's worker still tracks 0.27.0. So we
# pin transformers back to 5.14.1 — the workaround confirmed in #51744.
#
# RETIRE THIS IMAGE once RunPod ships a worker built on vLLM >= 0.27.2: then the
# stock image works and gemma-4-26b can move back to the hub-id deploy path.
FROM runpod/worker-v1-vllm:v2.25.0

RUN python3 -m pip install --no-cache-dir 'transformers==5.14.1'
