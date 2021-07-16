FROM centos:7

ARG MPI=openmpi-devel
ENV VIRTUAL_ENV=/ve_exaworks
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# MongoDB install
RUN echo -e "\
[mongodb]\n\
name     = MongoDB Repository \n\
baseurl  = https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/3.0/x86_64/ \n\
gpgcheck = 0 \n\
enabled  = 1 \n" >> /etc/yum.repos.d/mongodb.repo

RUN yum -y update \
 && yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && yum -y update \
 && yum -y install \
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
    coreutils \
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
    # Flux-sched dependencies
    boost-devel \
    boost-graph \
    boost-system \
    boost-filesystem \
    boost-regex \
    libxml2-devel \
    libedit-devel \
    yaml-cpp-devel \
    # Swift/T Deps
    java-1.7.0-openjdk-headless \
    java-1.7.0-openjdk-devel \
    tcl \
    swig \
    zsh \
    # Radical Pilot Deps
    python3-pip \
    mongodb-org \
    # MPI Dep
    ${MPI} \
 && yum clean all \
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

