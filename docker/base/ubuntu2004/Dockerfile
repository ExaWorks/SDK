ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}

ARG MPI=openmpi
ARG MPI_PREFIX=/usr/local
ARG PACKAGE_MANAGER=pip
ARG PYTHON_VERSION=3.7
ENV VIRTUAL_ENV=/ve_exaworks
ENV MPI_FLAVOR=${MPI}
ENV MPI_PREFIX=${MPI_PREFIX}
ENV MPICC=$MPI_PREFIX/bin/mpicc

SHELL ["/bin/bash", "-l", "-c"]

# General Dependencies
RUN apt-get update -y \
 && apt install -y \
    bzip2 \
    curl \
    file \
    gcc \
    g++ \
    git \
    gnupg \
    man-db \
    sudo \
    vim \
    wget


# copy over the python installation script in case we need it for pip
# conda will install its own python version
COPY ./scripts/install-python.sh /scripts/

RUN if [[ "${PACKAGE_MANAGER}" == "conda" ]] ; then \
        apt-get update -y \
     && apt install -y \
        aspell \
        aspell-en \
     && apt-get clean ; \
    else \
        # install python
        ./scripts/install-python.sh $PYTHON_VERSION \
     && apt-get update -y \
     && DEBIAN_FRONTEND=noninteractive apt install -y \
        # Flux-core Dependencies
        autoconf \
        automake \
        libtool \
        make \
        munge \
        pkg-config  \
        libzmq3-dev  \
        libczmq-dev \
        uuid-dev \
        libjansson-dev \
        liblz4-dev \
        libhwloc-dev \
        libsodium-dev \
        libsqlite3-dev \
        lua5.1 \
        liblua5.1-dev \
        lua-posix \
        python3-cffi \
        python3-yaml \
        python3-jsonschema \
        python3-sphinx \
        python3-pip \
        python3-venv \
        aspell \
        aspell-en \
        valgrind \
        libmpich-dev \
        jq \
        # Flux-sched Dependencies
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-graph-dev \
        libboost-regex-dev \
        libedit-dev \
        libxml2-dev \
        libyaml-cpp-dev \
        # Swift/T Dependencies
        openjdk-8-jdk-headless \
        tcl-dev \
        swig \
        zsh \
     && apt-get clean ; \
    fi

COPY ./scripts/install-python-env.sh ./scripts/environment.yml /scripts/
RUN bash /scripts/install-python-env.sh ${PACKAGE_MANAGER} ${PYTHON_VERSION}

# Swift/T Dependency on Apache Ant
RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.15-bin.tar.gz \
 && tar xvf apache-ant-1.9.15-bin.tar.gz -C /opt \
 && ln -s /opt/apache-ant-1.9.15 /opt/ant \
 && sudo ln -s /opt/ant/bin/ant /usr/bin/ant \
 && rm apache-ant-1.9.15-bin.tar.gz

COPY ./scripts/install-mpi.sh /scripts/install-mpi.sh
RUN DEBIAN_FRONTEND=noninteractive bash /scripts/install-mpi.sh ${MPI}
