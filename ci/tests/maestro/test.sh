#!/bin/bash

# python3 -m virtualenv maestroenv

# source maestroenv/bin/activate

# pip install maestrowf


> /tmp/test-output
echo y | maestro run ci/tests/maestro/study.yaml >> /tmp/test-output

cat <<EOF >/tmp/expected-output
Would you like to launch the study? [yn] Study launched successfully.
EOF

if diff /tmp/test-output /tmp/expected-output; then
    echo "Output matches"
else
    echo "Output does not match"
    echo "--- diff ---"
    diff /tmp/test-output /tmp/expected-output
    echo "------------"
    exit 1
fi

echo "Success!"
