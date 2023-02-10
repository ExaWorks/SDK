#!/bin/bash

SDK_BASE_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )/../../" &> /dev/null && pwd 2> /dev/null; )"

TAG="exaworks/sdk-tutorials:"
if [[ -z $1 ]]; then
    TAG+="${SDK_TUTORIALS_TAG:-latest}"
else
    TAG+=$1
fi

echo "Push docker container $TAG"

# push to the DockerHub registry
docker buildx create --use --name sdk_builder
docker buildx build \
    --output=type=registry \
    --platform linux/amd64,linux/arm64 \
    -t "$TAG" \
    -f "$SDK_BASE_DIR/docker/tutorials/Dockerfile" \
    "$SDK_BASE_DIR/docs/source/tutorials/"
