#!/bin/bash

output=$(flux start flux mini run echo Success)
if [[ "$output" != "Success" ]]; then
    exit 1
fi

set -e

cd /tmp/
git clone https://github.com/flux-framework/flux-core.git
cd flux-core
if [[ -n "$FLUX_CORE_VERSION" ]]; then
    git checkout tags/"v${FLUX_CORE_VERSION}"
fi
./autogen.sh
./configure
make -j 2
make -C src/common/libtap check
cd t
export MPI_TESTS="t2610-job-shell-mpir.t t3000-mpi-basic.t t3001-mpi-personalities.t t3003-mpi-abort.t"
FLUXION_QMANAGER_RC_NOOP=t FLUXION_RESOURCE_RC_NOOP=t FLUX_TEST_INSTALLED_PATH=/usr/bin FLUX_TEST_MPI=t make check TESTS="$MPI_TESTS"

echo "All tests ran successfully!"
