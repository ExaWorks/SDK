
# SWIFT/T DOCKERFILE
# Follows instructions at:
# http://swift-lang.github.io/swift-t/guide.html#install_source

# The ExaWorks SDK Base
FROM exaworks/sdk-base

# Customize the Swift/T root directory here:
ENV SWIFT_ROOT=/opt/swift-t

# Setup build environment
RUN mkdir -pv /tmp/build-swift-t
WORKDIR       /tmp/build-swift-t
COPY install-deps.sh install-swift-t.sh test-sanity.sh .

RUN ./install-deps.sh

ENV PATH=$SWIFT_ROOT/stc/bin:$PATH

RUN ./install-swift-t.sh
