#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

# Option 2: Dev environment without LoadBalancer support. Use port forwarding way instead
ENDPOINT="localhost:8888"

# list models
curl -v http://${ENDPOINT}/v1/models

# completion api
curl -v http://${ENDPOINT}/v1/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "deepseek-r1-distill-llama-8b",
        "prompt": "San Francisco is a",
        "max_tokens": 128,
        "temperature": 0
    }'

# chat completion api
curl http://${ENDPOINT}/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{
    "model": "deepseek-r1-distill-llama-8b",
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "help me write a random generator in python"}
    ]
}'
