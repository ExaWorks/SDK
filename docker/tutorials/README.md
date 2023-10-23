# Docker container with tutorial notebooks

## Build container image

SDK Tutorials container is based on 
[jupyter/minimal-notebook](https://github.com/jupyter/docker-stacks) image.

```shell
./docker/tutorials/build.sh
```

**NOTE**: for ARM platform, please, pull the image from the DockerHub directly

```shell
# use a specific tag if needed, otherwise "latest" is used (by default)
docker pull exaworks/sdk-tutorials:latest
```

## Run container image

```shell
docker run --rm -it -p 8888:8888 exaworks/sdk-tutorials
# OR
#   run.sh [tag_name]
# OR with mounted tutorials directory
#   run-local.sh [tag_name]
```

