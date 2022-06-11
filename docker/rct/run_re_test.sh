#!/bin/bash

export RMQ_HOSTNAME="rabbitmq"
export RMQ_PORT=5672
export RMQ_USERNAME="guest"
export RMQ_PASSWORD="guest"

# run mongodb, let it settle
echo '--- start MongoDB'
if [[ -f "/etc/mongod.conf" ]]; then
    CONFIG_OPT="--config /etc/mongod.conf"
fi

mongod --fork --logpath /tmp/mongodb.log $CONFIG_OPT

radical-stack

cd radical.entk
echo '--- smoke test'
./examples/user_guide/get_started.py
ret=$?
echo "--- smoke test $ret"

mongod $CONFIG_OPT --shutdown

exit $ret

