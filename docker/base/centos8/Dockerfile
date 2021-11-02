ARG BASE_IMAGE=centos:8
FROM ${BASE_IMAGE}

ARG MPI=openmpi-devel
ARG MPI_PREFIX=/usr/local
ARG PACKAGE_MANAGER=pip
ENV VIRTUAL_ENV=/ve_exaworks
ENV MPI_PREFIX=${MPI_PREFIX}
ENV MPICC=$MPI_PREFIX/bin/mpicc

SHELL ["/bin/bash", "-l", "-c"]

# General Dependencies
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
 && dnf install -y dnf-plugins-core \
 && dnf config-manager --set-enabled powertools \
 && dnf install -y \
    bzip2 \
    curl \
    diffutils \
    file \
    gcc \
    gcc-c++ \
    git \
    man-db \
    sudo \
    vim \
    wget \
    which

# MongoDB Repository (RADICAL-Pilot Dependency)
RUN echo -e "\
[mongodb]\n\
name     = MongoDB Repository \n\
baseurl  = https://repo.mongodb.org/yum/redhat/8Server/mongodb-org/3.6/x86_64/ \n\
gpgcheck = 0 \n\
enabled  = 1 \n" >> /etc/yum.repos.d/mongodb.repo

RUN if [[ "${PACKAGE_MANAGER}" == "conda" ]] ; then \
        dnf clean all ; \
    else \
        dnf install -y \
        # Flux-core Dependencies
        autoconf \
        automake \
        libtool \
        make \
        munge \
        munge-devel \
        cppcheck \
        czmq-devel \
        hwloc \
        hwloc-devel \
        jansson-devel \
        sqlite-devel \
        uuid-devel \
        libuuid-devel \
        libsodium-devel \
        lua \
        lua-devel \
        lua-posix \
        pkgconfig \
        python36-devel \
        python3-pip \
        sqlite \
        lz4-devel \
        jq \
        # Flux-sched Dependencies
        boost-devel \
        boost-graph \
        boost-system \
        boost-filesystem \
        boost-regex \
        libxml2-devel \
        libedit-devel \
        yaml-cpp-devel \
        python3-pyyaml \
        # Swift/T Dependencies
        java-1.8.0-openjdk-headless \
        java-1.8.0-openjdk-devel \
        tcl-devel \
        swig \
        zsh \
        # RADICAL-Pilot Dependency
        mongodb-org \
     && dnf clean all ; \
    fi

COPY ./scripts/install-python-env.sh ./scripts/environment.yml /scripts/
RUN bash /scripts/install-python-env.sh ${PACKAGE_MANAGER}

# Swift/T Dependency on Apache Ant
RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.15-bin.tar.gz \
 && tar xvf apache-ant-1.9.15-bin.tar.gz -C /opt \
 && ln -s /opt/apache-ant-1.9.15 /opt/ant \
 && sudo ln -s /opt/ant/bin/ant /usr/bin/ant \
 && rm apache-ant-1.9.15-bin.tar.gz

COPY ./scripts/install-mpi.sh /scripts/install-mpi.sh
RUN bash /scripts/install-mpi.sh ${MPI}
