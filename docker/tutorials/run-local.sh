#!/bin/bash

# Runs docker but mounts the git /tutorials dir in /tutorials such that changes in the notebook are saved
docker run --rm -it -p 8888:8888 --mount type=bind,source="$(pwd)/../../docs/source/tutorials",target=/tutorials -w /tutorials exaworks/sdk-tutorials