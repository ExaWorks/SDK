#!/bin/bash

echo "--- start MongoDB"
if [[ -f "/etc/mongod.conf" ]]; then
    CONFIG_OPT="--config /etc/mongod.conf"
fi

mongod --fork --logpath /tmp/mongodb.log $CONFIG_OPT

radical-stack

if [[ ! -d "/radical.pilot" ]]; then
    git clone -b "v$(radical-pilot-version)" --single-branch \
    https://github.com/radical-cybertools/radical.pilot.git
fi
cd /radical.pilot

# ensure path to flux-package
PY_VER=$(python3 -c "import sys; print (sys.version[:3])")
if [[ ! "$PY_VER" == *"$PYTHONPATH"* ]]; then
  export PYTHONPATH="/usr/lib/flux/python$PY_VER${PYTHONPATH:+:}${PYTHONPATH:-}"
fi

echo "--- smoke test"
./examples/00_getting_started.py "flux.localhost_flux"
ret=$?
echo "--- smoke test $ret"

test "$ret" = 0 && echo "Success!"

mongod $CONFIG_OPT --shutdown

exit $ret

