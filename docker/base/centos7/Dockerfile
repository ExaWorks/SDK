ARG BASE_IMAGE=centos:7
FROM ${BASE_IMAGE}

ARG MPI=openmpi
ARG MPI_PREFIX=/usr/local
ARG PACKAGE_MANAGER=pip
ENV VIRTUAL_ENV=/ve_exaworks
ENV MPI_FLAVOR=${MPI}
ENV MPI_PREFIX=${MPI_PREFIX}
ENV MPICC=$MPI_PREFIX/bin/mpicc

SHELL ["/bin/bash", "-l", "-c"]

# General Dependencies
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && yum -y update \
 && yum -y install \
    bzip2 \
    coreutils \
    curl \
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
baseurl  = https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/3.0/x86_64/ \n\
gpgcheck = 0 \n\
enabled  = 1 \n" >> /etc/yum.repos.d/mongodb.repo

# The case of CentOS7 with `conda` package manager is excluded from CI workflow,
# due to unresolved issues between GCC and OpenMPI installations
RUN if [[ "${PACKAGE_MANAGER}" == "conda" ]] ; then \
        yum -y install \
        autoconf \
        automake \
        libtool \
        make \
     && yum clean all \
     && V=8.5.0 \
     && PKG=gcc-$V \
     && URL=https://ftp.gnu.org/gnu/gcc \
     && wget ${URL}/${PKG}/${PKG}.tar.gz \
     && tar xf ${PKG}.tar.gz \
     && cd ${PKG} \
     && ./contrib/download_prerequisites \
     && mkdir ../${PKG}-build \
     && cd ../${PKG}-build \
     && ../${PKG}/configure --disable-multilib \
                            --enable-languages=c,c++ \
     && make -j 4 \
     && make install \
     && cd .. \
     && rm -rf ${PKG}* \
     && ldconfig ; \
    else \
        yum -y install \
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
        # Swift/T Dependencies
        java-1.7.0-openjdk-headless \
        java-1.7.0-openjdk-devel \
        tcl \
        swig \
        zsh \
        # RADICAL-Pilot Dependency
        mongodb-org \
     && yum clean all ; \
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
