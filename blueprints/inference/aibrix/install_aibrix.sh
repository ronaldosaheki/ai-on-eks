#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

#https://aibrix.readthedocs.io/latest/getting_started/installation/installation.html#
#https://github.com/vllm-project/aibrix/releases/download/v0.3.0/aibrix-dependency-v0.3.0.yaml

# Install component dependencies
kubectl create -f https://github.com/vllm-project/aibrix/releases/download/v0.3.0/aibrix-dependency-v0.3.0.yaml || true

# Install aibrix components
kubectl create -f https://github.com/vllm-project/aibrix/releases/download/v0.3.0/aibrix-core-v0.3.0.yaml


