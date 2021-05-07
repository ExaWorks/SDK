FROM centos:7

ARG MPI=openmpi-devel

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
    python36-cffi \
    python36-six \
    python36-yaml \
    python36-jsonschema \
    sqlite \
    man-db \
    lz4-devel \
    jq \
    # Flux-sched dependencies
    libboost-graph-devel \
    libboost-system-devel \
    libboost-filesystem-devel \
    libboost-regex-devel \
    libxml2-devel \
    readline-devel \
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
 && yum clean all

# Swift/T Dependency on Apache Ant
RUN wget https://apache.claz.org//ant/binaries/apache-ant-1.9.15-bin.tar.gz \
    && tar xvf apache-ant-1.9.15-bin.tar.gz -C /opt \
    && ln -s /opt/apache-ant-1.9.15 /opt/ant \
    && sudo ln -s /opt/ant/bin/ant /usr/bin/ant

