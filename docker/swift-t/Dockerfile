
# SWIFT/T DOCKERFILE
# Follows instructions at:
# http://swift-lang.github.io/swift-t/guide.html#install_source

# The ExaWorks SDK Base
FROM 136a88385611

# Customize the Swift/T root directory here:
ENV SWIFT_ROOT=/opt/swift-t

# Install dependencies
RUN yum -y install mpich-devel # OpenMPI is fine too
RUN yum -y install swig
RUN yum -y install zsh

# Configure environment
ENV PATH=/usr/lib64/mpich/bin:$PATH

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

# Simple sanity tests
RUN $SWIFT_ROOT/stc/bin/swift-t -v
RUN $SWIFT_ROOT/stc/bin/swift-t -E 'trace(42);'
