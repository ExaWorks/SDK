#!/bin/bash

TAG="exaworks/sdk-tutorials:"
if [[ -z $1 ]]; then
    TAG+="${SDK_TUTORIALS_TAG:-latest}"
else
    TAG+=$1
fi

echo "Run docker container $TAG"

docker run --rm -it -p 8888:8888 -w /tutorials "$TAG"
