#!/bin/bash

python ci/tests/parsl/test.py | tee /tmp/test-output

cat <<EOF >/tmp/expected-output
Hello World from Python!
Hello World!

EOF

if diff /tmp/test-output /tmp/expected-output; then
	echo "Output matches"
else
	echo "Output does not match"
	exit 1
fi

echo "Success!"
