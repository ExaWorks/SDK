#!/bin/bash

set -ex

if [[ -z $1 ]]; then
    echo "Must provide python version (e.g., 3.6) to be installed" 1>&2
    exit 1
fi

# all dependencies should be resolved in base Dockerfile (including: openssl xz gdbm)
# yum-based systems
#    yum -y install yum-utils
#    yum-builddep -y python3
# dnf-based systems
#    dnf -y install dnf-plugins-core
#    dnf builddep -y python3
# apt-based systems
#    apt-get -y install build-essential gdb lcov libbz2-dev libffi-dev libgdbm-dev \
#               liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev \
#               libssl-dev lzma lzma-dev tk-dev uuid-dev zlib1g-dev

PY_BASE_VER="$1"

case "$PY_BASE_VER" in
    "3.7")
        PY_VER="3.7.12"
        ;;
    "3.8")
        PY_VER="3.8.12"
        ;;
    "3.9")
        PY_VER="3.9.7"
        ;;
    *)
        echo "Provided version is not supported" 1>&2
        exit 1
esac

PY_NAME="Python-$PY_VER"
PY_TARBALL="$PY_NAME.tgz"
PY_PREFIX="/usr"

cd /tmp
wget -q --no-check-certificate "https://www.python.org/ftp/python/$PY_VER/$PY_TARBALL"
tar xzf "$PY_TARBALL"
cd "/tmp/$PY_NAME"
./configure --enable-shared && make && make install
ldconfig /usr/local/lib
echo "ldconfig /usr/local/lib" >> ~/.bashrc

if [[ ! "$PY_PREFIX" == "/usr" ]]; then
    ln -sf "$PY_PREFIX/bin/python$PY_BASE_VER" "/usr/bin/python3"
    ln -sf "$PY_PREFIX/bin/python$PY_BASE_VER" "/usr/bin/python$PY_BASE_VER"
fi

cd / && rm "/tmp/$PY_TARBALL" && rm -r "/tmp/$PY_NAME"
