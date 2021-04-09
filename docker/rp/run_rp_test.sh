#!/bin/sh

# run mongodb, let it settle
mongod --fork --logpath /tmp/mongodb.log

cd radical.pilot
./examples/00_getting_started.py
# pytest -vvv tests


