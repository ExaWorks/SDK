#!/bin/bash

if [[ -z $1 ]]; then
    echo "Must provide Package Manager that you want to install" 1>&2
    exit 1
fi

<<<<<<< HEAD
function centos_major_version() {
    cat /etc/centos-release | cut -f 4 -d " " | cut -f 1 -d .
}

if [[ "$1" == "conda" ]]; then
    if [[ $(centos_major_version) == "7" ]]; then
        curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh
        bash /tmp/miniconda.sh -bfp /usr/local/
        rm -rf /tmp/miniconda.sh
        conda create -y -p ${VIRTUAL_ENV} python=3.6
        conda update conda
        conda clean --all --yes
        conda install -y -p $VIRTUAL_ENV pip setuptools pytest
        # Flux python deps
        conda install -y -p $VIRTUAL_ENV cffi six pyyaml jsonschema
        # Parsl python deps
        conda install -y -p $VIRTUAL_ENV "cryptography==3.3.2"

    else
        echo "Unknown CentOS version. Exiting" 1>&2
        exit 1
    fi

elif [[ "$1" == "pip" ]]; then
  python3 -m venv ${VIRTUAL_ENV}
  pip install --upgrade pip setuptools pytest
  # Flux python deps
  pip install cffi six pyyaml jsonschema
  # Parsl python deps
  pip install "cryptography==3.3.2"
=======
# Get distribution info
if [[ -f "/etc/centos-release" ]]; then
    DISTRO_ID="centos"
    DISTRO_MAJOR_VERSION=$(cat /etc/centos-release | cut -f 4 -d " " | cut -f 1 -d .)
elif [[ -f "/etc/lsb-release" ]]; then
    DISTRO_ID=$(cat /etc/lsb-release | grep DISTRIB_ID | cut -f 2 -d "=" | awk '{print tolower($0)}')
    DISTRO_MAJOR_VERSION=$(cat /etc/lsb-release | grep DISTRIB_RELEASE | cut -f 2 -d "=" | cut -f 1 -d .)
else
    echo "Unknown Linux distro. Exiting" 1>&2
    exit 1
fi

if [[ "$1" == "conda" ]]; then
    # if [[ ${DISTRO_ID} == "centos" ]] && [[ ${DISTRO_MAJOR_VERSION} == "8" ]]; then
    #     echo "Unsupported: Centos8 + Conda" 1>&2
    #     exit 1
    # fi

    curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh
    bash /tmp/miniconda.sh -bfp /usr/local/
    rm -rf /tmp/miniconda.sh
    conda env create --prefix ${VIRTUAL_ENV} --file /scripts/environment.yml
    conda init bash
    echo "conda activate ${VIRTUAL_ENV}" >> ~/.bashrc
    source ~/.bashrc
    conda update conda
    conda clean --all --yes
    conda install -y pip setuptools pytest
    # Flux python deps
    conda install -c asmeurer aspell
    conda install -y cffi six pyyaml jsonschema
    # Parsl python deps
    conda install -y "cryptography==3.3.2"


elif [[ "$1" == "pip" ]]; then
    python3 -m venv ${VIRTUAL_ENV}
    pip install --upgrade pip setuptools pytest
    # Flux python deps
    pip install cffi six pyyaml jsonschema
    # Parsl python deps
    pip install "cryptography==3.3.2"
>>>>>>> Rebased from master

else
    printf "Unknown/unsupported Python Package Manager '%s'. Exiting without installing.\n" "$1"
    exit 1
fi
