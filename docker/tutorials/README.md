# Docker container with tutorial notebooks

## Build container image

Jupyter Docker images - https://github.com/jupyter/docker-stacks 

```shell
./docker/tutorials/build.sh
```

## Run container image

Run without `sdk` image
```shell
docker run --rm -it -p 8888:8888 exaworks/sdk-tutorials
```

Run with `sdk` using `docker compose`
```shell
cd docker/tutorials
docker compose up
```

