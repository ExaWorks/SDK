#!/bin/bash

set -euo pipefail

HERE=$(dirname $(readlink -f $0))

retc=0

python3 -c 'import smartsim; smartsim.Experiment' || retc=$?
if [ $retc -ne 0 ]; then
    echo "Failed to import SmartSim"
    exit 1
fi

python3 "$HERE/test.py" --device=cpu || retc=$?
if [ $retc -ne 0 ]; then
    echo "Failed to run a simple SmartSim experiment"
    exit 1
fi

echo "Success"
exit 0
