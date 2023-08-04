#!/bin/bash

set -e

VENV_NAME="$1"

OPENSSL_VERSION="1.1.1v"
OPENSSL_PREFIX="${VENV_NAME}/../lassen-openssl"

if [[ -d "$OPENSSL_PREFIX" ]]; then
    echo 'OpenSSL for Lassen is already installed'
    exit
fi

source "${VENV_NAME}/bin/activate"
pip install -U pip setuptools wheel

curl -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xvf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}
./config no-shared no-ssl2 no-ssl3 -fPIC --prefix="${OPENSSL_PREFIX}"
make && make install
cd ..

CFLAGS="-I${OPENSSL_PREFIX}/include" LDFLAGS="-L${OPENSSL_PREFIX}/lib" \
pip install --no-cache-dir --no-binary :all: cryptography==3.3.2

pip cache purge
rm -rf openssl-${OPENSSL_VERSION}*

