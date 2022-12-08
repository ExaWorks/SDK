# Docker container with tutorial notebooks

## Build container image

Jupyter Docker images - https://github.com/jupyter/docker-stacks 

```shell
./docker/tutorials/build.sh
```

## A. Run container image (base)

```shell
docker run --rm -it -p 8888:8888 exaworks/sdk-tutorials
```

## B. Run container image (extended - for RADICAL-EnTK)

Docker network
```shell
# create a network to communicate with services
docker network create sdk-network
```

Launch MongoDB service
```shell
docker run -d --hostname mongodb --name mongodb -p 27017:27017 \
           -e MONGO_INITDB_ROOT_USERNAME=root_user \
           -e MONGO_INITDB_ROOT_PASSWORD=root_pass \
           -e MONGO_INITDB_USERNAME=guest \
           -e MONGO_INITDB_PASSWORD=guest \
           -e MONGO_INITDB_DATABASE=default \
           --network sdk-network mongo:4.4

docker exec mongodb bash -c \
  "mongo --authenticationDatabase admin -u root_user -p root_pass default \
   --eval \"db.createUser({user: 'guest', \
                           pwd: 'guest', \
                           roles: [{role: 'readWrite', db: 'default'}]});\""
```

Launch RabbitMQ service
```shell
# run the service
docker run -d --hostname rabbitmq --name rabbitmq -p 15672:15672 -p 5672:5672 \
           --network sdk-network rabbitmq:3-management
```

Run container with network
```shell
docker run --rm -it -p 8888:8888 --network sdk-network exaworks/sdk-tutorials
```

## C. Run `docker-compose`

```shell
docker compose up -d
docker compose logs -f sdk-tutorials
# stop containers
#   docker compose stop
```

