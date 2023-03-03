#!/bin/bash

if which radical-pilot-version >/dev/null; then
    rp_version="$(radical-pilot-version)"
    if [[ -z $rp_version ]]; then
        echo "RADICAL-Pilot version unknown"
        exit 1
    fi
else
    echo "RADICAL-Pilot not installed"
    exit 1
fi

# each ci job runs in a private runner environment
mkdir -p .radical/pilot/configs
cp ci/tests/rp-flux/resource_flux.json .radical/pilot/configs/resource_flux.json
export RADICAL_CONFIG_USER_DIR=$(pwd)

if [[ ! -d "./radical.pilot" ]]; then
    git clone -b v$rp_version --single-branch \
    https://github.com/radical-cybertools/radical.pilot.git
fi
cd radical.pilot

echo '--- smoke test'
./examples/00_getting_started.py 'flux.localhost_flux'
ret=$?
echo "--- smoke test $ret"

test "$ret" = 0 && echo "Success!"
exit $ret
