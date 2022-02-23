#!/bin/bash

output=$(flux start flux mini run echo Success)
if [[ "$output" != "Success" ]]; then
    exit 1
fi

# When running with `flux start --test-size`, as the flux integration tests are,
# openmpi hangs. This is because when Flux is started with `--test-size`, the
# job-shell setting `pmi.clique` defaults to singleton, which means Flux's PMI
# tells OpenMPI that all ranks are on the same node, even when you use `flux mini
# run -N2`. This causes OpenMPI to hang. To solve this, add a job-shell plugin
# that forces Flux's PMI to "lie" to OpenMPI that each shell is running on a
# different node. OpenMPI properly bootstraps under this config.
FLUX_LUA_D_DIR="$(dirname $(flux start flux getattr conf.shell_initrc))/lua.d"
SHELL_PLUGIN_PATH="$FLUX_LUA_D_DIR/pmi-clique.lua"
cat << EOF > $SHELL_PLUGIN_PATH
pmiopt = shell.options.pmi or {}
pmiopt["clique"] = "pershell"
shell.options.pmi = pmiopt
EOF
chmod +x $SHELL_PLUGIN_PATH

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
exit_code=$?

if [[ $exit_code -gt 0 ]]; then
    bash /tests/flux/checks-annotate.sh
fi

rm $SHELL_PLUGIN_PATH

echo "Exiting with $exit_code"
exit $exit_code
