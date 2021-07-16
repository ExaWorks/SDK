FROM centos:8

ARG MPI=openmpi-devel
ENV VIRTUAL_ENV=/ve_exaworks
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# MongoDB install
RUN echo -e "\
[mongodb]\n\
name     = MongoDB Repository \n\
baseurl  = https://repo.mongodb.org/yum/redhat/8Server/mongodb-org/3.6/x86_64/ \n\
gpgcheck = 0 \n\
enabled  = 1 \n" >> /etc/yum.repos.d/mongodb.repo

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
 && dnf install -y dnf-plugins-core \
 && dnf config-manager --set-enabled powertools \
 && dnf install -y \
    # General & Flux-core Dependencies
    which \
    sudo \
    git \
    wget \
    autoconf \
    automake \
    libtool \
    gcc \
    gcc-c++ \
    file \
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
    sqlite \
    man-db \
    lz4-devel \
    jq \
    diffutils \
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
    tcl \
    swig \
    zsh \
    # RADICAL-Pilot Dependencies
    python3-pip \
    mongodb-org \
    # MPI Dep
    ${MPI} \
 && dnf clean all \
 && python3 -m venv ${VIRTUAL_ENV} \
 && pip install --upgrade pip setuptools pytest \
 # Flux python deps
 && pip install cffi six pyyaml jsonschema \
 # Parsl python deps
 && pip install "cryptography==3.3.2"

# Swift/T Dependency on Apache Ant
RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.15-bin.tar.gz \
    && tar xvf apache-ant-1.9.15-bin.tar.gz -C /opt \
    && ln -s /opt/apache-ant-1.9.15 /opt/ant \
    && sudo ln -s /opt/ant/bin/ant /usr/bin/ant

