#!/bin/sh
set -eux

# INSTALL SWIFT/T

# Setup
# Swift/T will prefer the MPI found first- MPICH in this case
PATH=/usr/lib64/mpich/bin:$PATH
PATH=/usr/lib64/openmpi/bin:$PATH
PATH=/opt/tcl-8.6.11/bin:$PATH

# Get it
git clone https://github.com/swift-lang/swift-t.git

# Build it
cd swift-t/dev/build
cp -v swift-t-settings.sh.template swift-t-settings.sh
sed -i "/SWIFT_T_PREFIX=/s@=.*@=$SWIFT_ROOT@" swift-t-settings.sh
./build-swift-t.sh
