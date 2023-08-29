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

wget -q "https://raw.githubusercontent.com/radical-cybertools/radical.pilot/v$rp_version/examples/config.json"
wget -q "https://raw.githubusercontent.com/radical-cybertools/radical.pilot/v$rp_version/examples/00_getting_started.py"
chmod +x 00_getting_started.py

radical-stack
./00_getting_started.py 'flux.localhost_flux'
ret=$?
echo "--- smoke test $ret"

SID=$(ls -rt | grep rp.session)
test -z "$SID" || rm -rf "$HOME/radical.pilot.sandbox/$SID"
echo '--- cleaned pilot sandbox'

test "$ret" = 0 && echo "Success!"
exit $ret

