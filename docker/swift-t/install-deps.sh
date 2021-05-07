#!/bin/sh
set -eux

# INSTALL DEPENDENCIES

# Yums
yum -y install swig
yum -y install zsh

# Get Tcl
wget --no-verbose https://prdownloads.sourceforge.net/tcl/tcl8.6.11-src.tar.gz
tar xfz tcl8.6.11-src.tar.gz

# Fix Tcl RTLD setting:
cd tcl8.6.11/unix
sed -i 90s@^@//@    tclLoadDl.c
sed -i 92,+2s@^@//@ tclLoadDl.c

# Build Tcl
./configure --prefix=/opt/tcl-8.6.11
make binaries libraries
make install-binaries install-libraries install-headers
