#!/bin/bash

radical-stack

cd radical.entk
echo '--- smoke test'
./examples/user_guide/get_started.py
ret=$?
echo "--- smoke test $ret"

exit $ret

