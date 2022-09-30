# Docker container with tutorial notebooks

## Build container image

Jupyter Docker images - https://github.com/jupyter/docker-stacks 

```shell
./docker/tutorials/build.sh
```

## Run container image

```shell
docker run --rm -it -p 8888:8888 exaworks/sdk-tutorials
```

