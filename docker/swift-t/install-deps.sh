#!/bin/sh
set -eux

# INSTALL DEPENDENCIES
# Currently just Tcl

if which tclsh8.6 > /dev/null 2>&1
then
  # Tcl is installed, probably via package manager.
  # Note that this does not check for tcl-devel,
  #      which is needed for Swift/T.
  exit
fi

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
