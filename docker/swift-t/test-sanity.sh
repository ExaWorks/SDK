#!/bin/bash
set -eux

# SWIFT/T TEST SANITY
# Simply sanity tests for fresh Docker build

# For OpenMPI
if [[ $MPI_FLAVOR == "openmpi" ]]; then
  export TURBINE_LAUNCH_OPTIONS=--allow-run-as-root
fi

swift-t -v
swift-t -E 'trace(42);'
