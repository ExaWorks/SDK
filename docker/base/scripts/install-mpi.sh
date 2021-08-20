#!/bin/bash

if [[ -z $1 ]]; then
    echo "Must provide MPI that you want to install" 1>&2
    exit 1
fi

function centos_major_version() {
    cat /etc/centos-release | cut -f 4 -d " " | cut -f 1 -d .
}

# Install only the dependencies for a given package
# Source: https://serverfault.com/questions/429123/howto-get-yum-to-install-only-dependencies-for-a-given-pakage
yum_install_only_deps () {
    if [[ -z "$1" ]]; then
        echo "Package required for installing deps" 1>&2
        exit 1
    fi
    PACKAGE="$1"
    yum deplist $PACKAGE | grep provider | awk '{print $2}' | sort | uniq | grep -v $PACKAGE | sed ':a;N;$!ba;s/\n/ /g' | xargs yum -y install
}

if [[ "$1" == "openmpi-devel" ]]; then
    if [[ $(centos_major_version) == "7" ]]; then
        yum install -y slurm-pmi-devel
        MAJOR_MINOR=1.10
        PATCH=7
        CONFIGURE_ARGS="--with-pmi --with-pmi-libdir=/usr/lib64"
    elif [[ $(centos_major_version) == "8" ]]; then
        yum_install_only_deps "openmpi"
        MAJOR_MINOR=4.0
        PATCH=6
        CONFIGURE_ARGS=""
    else
        echo "Unknown CentOS version. Exiting" 1>&2
        exit 1
    fi

    OPENMPI=openmpi-${MAJOR_MINOR}.${PATCH}

    wget https://download.open-mpi.org/release/open-mpi/v${MAJOR_MINOR}/${OPENMPI}.tar.gz
    tar -xf ./${OPENMPI}.tar.gz
    rm ./${OPENMPI}.tar.gz

    cd ${OPENMPI}
    ./configure ${CONFIGURE_ARGS}
    make -j 4
    make install
    cd ..
    rm -rf ${OPENMPI}

    if [[ $(centos_major_version) == "7" ]]; then
        yum remove -y slurm-pmi-devel
        yum autoremove -y
        yum clean all
    fi
else
    echo "Unknown/unsupported MPI. Existing without installing."
    exit 1
fi
