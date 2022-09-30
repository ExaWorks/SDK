#!/bin/bash

SDK_BASE_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )/../../" &> /dev/null && pwd 2> /dev/null; )"

docker build \
    -t exaworks/sdk-tutorials \
    -f "$SDK_BASE_DIR/docker/tutorials/Dockerfile" \
    "$SDK_BASE_DIR/docs/source/tutorials/"

