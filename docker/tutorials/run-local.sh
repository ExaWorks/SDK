#!/bin/bash

TAG="exaworks/sdk-tutorials:"
if [[ -z $1 ]]; then
    TAG+="${SDK_TUTORIALS_TAG:-latest}"
else
    TAG+=$1
fi

echo "Run docker container $TAG"

# Runs docker but mounts the git /tutorials dir in /tutorials such that changes
# in the notebook are saved
docker run --rm -it -p 8888:8888 --mount type=bind,source="$(pwd)/../../docs/source/tutorials",target=/tutorials -w /tutorials "$TAG"
