# RADICAL-Pilot

RADICAL-Pilot tests (smoke and integration testings) are included into SDK CI.

# RADICAL-EnTK

RADICAL-EnTK (Ensemble Toolkit) smoke test is included into SDK CI.

RADICAL-EnTK uses RADICAL-Pilot and relies on such services 
as MongoDB and RabbitMQ to manage and control workload execution within defined 
workflows. RabbitMQ was not included into SDK container, thus we provide a 
recipe of how to run an EnTK application using SDK docker container (examples 
of EnTK apps are in the container).

## Launch RabbitMQ service
```bash
# create a network to communicate with the service
docker network create rabbitnet
# run the service
docker run -d --hostname rabbitmq --name rabbitmq -p 15672:15672 -p 5672:5672 --network rabbitnet rabbitmq:3-management
```

## Run SDK docker container
```bash
docker run --rm -it --network rabbitnet exaworks/sdk bash 
```

## Run RADICAL-EnTK apps

### Setup environment
```bash
# run MongoDB service:
if [[ -f "/etc/mongod.conf" ]]; then
    CONFIG_OPT="--config /etc/mongod.conf"
fi
mongod --fork --logpath /tmp/mongodb.log $CONFIG_OPT
# stop MongoDB service:
#   mongod $CONFIG_OPT --shutdown
```
```bash
# set RabbitMQ environment variables
export RMQ_HOSTNAME="rabbitmq"
export RMQ_PORT="5672"
export RMQ_USERNAME="guest"
export RMQ_PASSWORD="guest"
```

### Run examples
Examples are located in `/radical.entk/examples`
```bash
python3 /radical.entk/examples/user_guide/get_started.py
```

