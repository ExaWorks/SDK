# Docker container with tutorial notebooks

Follow either method A, B or C to run the tutorial notebooks. Note that if you
want to run the RADICAL-Cybertools tutorial, you will have to follow either
method B or C.

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

## A. Run container image (base)

```shell
docker run --rm -it -p 8888:8888 exaworks/sdk-tutorials
# OR
#   run.sh [tag_name]
# OR with mounted tutorials directory
#   run-local.sh [tag_name]
```

## B. Run `docker-compose` (extended)

It starts `sdk-tutorials` container with an auxiliary service - MongoDB - which
is used by the RADICAL-Cybertools components (part of a communication layer).

```shell
cd docker/tutorials
# if a specific tag is needed, then export the following env variable, e.g.,
#   export SDK_TUTORIALS_TAG=ecp-tutorials-2023

docker compose up -d
docker compose logs -f sdk-tutorials
# stop containers
#   docker compose stop
# remove containers
#   docker compose rm -f
```

## C. Run container image with MongoDB service manually

These steps do the same as `docker-compose`, but all necessary commands are
executed manually.

Docker network to communicate with services:

```shell
docker network create sdk-network
```

Launch MongoDB service:

```shell
docker run -d --hostname mongodb --name sdk-mongodb -p 27017:27017 \
           -e MONGO_INITDB_ROOT_USERNAME=root_user \
           -e MONGO_INITDB_ROOT_PASSWORD=root_pass \
           -e MONGO_INITDB_USERNAME=guest \
           -e MONGO_INITDB_PASSWORD=guest \
           -e MONGO_INITDB_DATABASE=default \
           --network sdk-network mongo:4.4

docker exec sdk-mongodb bash -c \
  "mongo --authenticationDatabase admin -u root_user -p root_pass default \
   --eval \"db.createUser({user: 'guest', pwd: 'guest', \
                           roles: [{role: 'readWrite', db: 'default'}]});\""
```

Run container with network:

```shell
docker run --rm -it -p 8888:8888 --network sdk-network exaworks/sdk-tutorials
```

Stop an auxiliary service after work is done:

```shell
# stop container
docker stop sdk-mongodb
# stop and remove container
#   docker rm -f sdk-mongodb
```

