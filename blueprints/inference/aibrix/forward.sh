#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

# Option 2: Dev environment without LoadBalancer support. Use port forwarding way instead
kubectl -n envoy-gateway-system port-forward service/envoy-aibrix-system-aibrix-eg-903790dc 8888:80 &
ENDPOINT="localhost:8888"

