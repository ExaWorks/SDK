#!/bin/bash

set -e

if [[ -z $1 ]]; then
    echo "Must provide Package Manager that you want to install" 1>&2
    exit 1
fi

if [[ "$1" == "conda" ]]; then
    curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh
    bash /tmp/miniconda.sh -bfp /usr/local && rm -rf /tmp/miniconda.sh
    source /usr/local/etc/profile.d/conda.sh
    conda update -y -n base conda
    conda env create -p ${VIRTUAL_ENV} -f /scripts/environment.yml
    conda activate ${VIRTUAL_ENV}
    conda env config vars set BOOST_LIBDIR="$VIRTUAL_ENV/lib" \
                              LUA_INCLUDE="-I$VIRTUAL_ENV/include" \
                              LUA_LIB="$(pkg-config --libs lua)" \
                              C_INCLUDE_PATH="$VIRTUAL_ENV/include" \
                              CPLUS_INCLUDE_PATH="$VIRTUAL_ENV/include" \
                              LDFLAGS="-Wl,-rpath,$VIRTUAL_ENV/lib -L$VIRTUAL_ENV/lib"
    # finalize
    conda clean -y -a
    conda init --system
    echo "conda activate $VIRTUAL_ENV" >> ~/.bashrc
    echo "conda activate $VIRTUAL_ENV" >> /etc/profile.d/conda.sh

elif [[ "$1" == "pip" ]]; then
    python3 -m venv ${VIRTUAL_ENV}
    source $VIRTUAL_ENV/bin/activate
    pip install --upgrade pip setuptools pytest
    # Flux python deps
    pip install cffi jsonschema pyyaml
    # Parsl python deps
    pip install "cryptography==3.3.2"
    echo "source $VIRTUAL_ENV/bin/activate" >> ~/.bashrc
    echo "source $VIRTUAL_ENV/bin/activate" >> /etc/profile.d/conda.sh

else
    printf "Unknown/unsupported Python Package Manager '%s'. Exiting without installing.\n" "$1"
    exit 1
fi
