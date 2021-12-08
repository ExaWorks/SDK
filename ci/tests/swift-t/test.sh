#!/bin/sh
set -eux

# SWIFT/T TEST SANITY
# Simply sanity tests for fresh Docker build

# For OpenMPI
export TURBINE_LAUNCH_OPTIONS=--allow-run-as-root

swift-t -v
swift-t -E 'trace(42);'

echo "Success!"
