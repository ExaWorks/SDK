
# SWIFT/T DOCKERFILE
# Follows instructions at:
# http://swift-lang.github.io/swift-t/guide.html#install_source

# The ExaWorks SDK Base
FROM 136a88385611

# Customize the Swift/T root directory here:
ENV SWIFT_ROOT=/opt/swift-t

# Install dependencies
# RUN yum -y install mpich-devel
RUN yum -y install openmpi-devel
RUN yum -y install swig
RUN yum -y install zsh
RUN mkdir -pv /tmp/build-tcl
WORKDIR /tmp/build-tcl
RUN wget --no-verbose https://prdownloads.sourceforge.net/tcl/tcl8.6.11-src.tar.gz
RUN tar xfz tcl8.6.11-src.tar.gz
# Fix Tcl RTLD setting:
RUN cd tcl8.6.11/unix \
  && sed -i 90s@^@//@    tclLoadDl.c \
  && sed -i 92,+2s@^@//@ tclLoadDl.c
RUN cd tcl8.6.11/unix \
  && ./configure --prefix=/opt/tcl-8.6.11 \
  && make -j 4 binaries libraries \
  && make install-binaries install-libraries install-headers

# Configure environment
# ENV PATH=/usr/lib64/mpich/bin:$PATH
ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV PATH=/opt/tcl-8.6.11/bin:$PATH

# Get Swift/T and setup
RUN mkdir -pv /tmp/build-swift-t
WORKDIR /tmp/build-swift-t
RUN git clone https://github.com/swift-lang/swift-t.git
RUN cd swift-t/dev/build \
    && cp -v swift-t-settings.sh.template swift-t-settings.sh \
    && sed -i "/SWIFT_T_PREFIX=/s@=.*@=$SWIFT_ROOT@" swift-t-settings.sh \
    && sed -i "/PARALLELISM=/s@=.*@=4@"              swift-t-settings.sh

# Build and install it!
RUN swift-t/dev/build/build-swift-t.sh

# For OpenMPI
ENV TURBINE_LAUNCH_OPTIONS=--allow-run-as-root

# Simple sanity tests
RUN $SWIFT_ROOT/stc/bin/swift-t -v
RUN $SWIFT_ROOT/stc/bin/swift-t -E 'trace(42);'

# Set PATH for user convenience
ENV PATH=$SWIFT_ROOT/stc/bin:$PATH
