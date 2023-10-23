#!/bin/bash

radical-stack

cd /radical.pilot
echo '--- smoke test'
./examples/00_getting_started.py
ret=$?
echo "--- smoke test $ret"

exit $ret

