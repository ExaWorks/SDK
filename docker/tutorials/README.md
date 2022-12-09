# Docker container with tutorial notebooks

Follow either method A, B or C to run the tutorial notebooks. Note that if you
want to run the RADICAL-Cybertools tutorial, you will have to follow either
method B or C.

## Build container image

Jupyter Docker images - https://github.com/jupyter/docker-stacks

```shell
./docker/tutorials/build.sh
```

## A. Run container image (base)

```shell
docker run --rm -it -p 8888:8888 exaworks/sdk-tutorials
```

## B. Run container image (with MongoDB and RabbitMQ services)

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

Launch RabbitMQ service:

```shell
docker run -d --hostname rabbitmq --name sdk-rabbitmq -p 15672:15672 \
           -p 5672:5672 --network sdk-network rabbitmq:3-management
```

Run container with network:

```shell
docker run --rm -it -p 8888:8888 --network sdk-network exaworks/sdk-tutorials
```

Stop services after work is done:

```shell
# stop containers
docker stop sdk-mongodb sdk-rabbitmq
# stop and remove containers
#   docker rm -f sdk-mongodb sdk-rabbitmq
```

## C. Run `docker-compose`

```shell
cd docker/tutorials

docker compose up -d
docker compose logs -f sdk-tutorials
# stop containers
#   docker compose stop
# remove containers
#   docker compose rm -f
```
