FROM centos:7

RUN yum -y update \
 && yum -y install \
    # General & Flux Dependencies
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
    openmpi-devel \
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
    # Swift/T Deps
    java-1.7.0-openjdk-headless \
    java-1.7.0-openjdk-devel \
    tcl \
 && yum clean all

RUN wget https://apache.claz.org//ant/binaries/apache-ant-1.9.15-bin.tar.gz \
    && tar xvf apache-ant-1.9.15-bin.tar.gz -C /opt \
    && ln -s /opt/apache-ant-1.9.15 /opt/ant \
    && sudo ln -s /opt/ant/bin/ant /usr/bin/ant
