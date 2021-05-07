
# SWIFT/T DOCKERFILE
# Follows instructions at:
# http://swift-lang.github.io/swift-t/guide.html#install_source

ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

# Customize the Swift/T root directory here:
ENV SWIFT_ROOT=/opt/swift-t

# Setup build environment
ARG SWIFT_BUILD_DIR=/tmp/build-swift-t
RUN mkdir -pv ${SWIFT_BUILD_DIR}
WORKDIR       ${SWIFT_BUILD_DIR}
COPY install-deps.sh install-swift-t.sh ${SWIFT_BUILD_DIR}/

RUN ./install-deps.sh

ENV PATH=$SWIFT_ROOT/stc/bin:$PATH

RUN ./install-swift-t.sh

# Simple sanity tests
COPY test-sanity.sh ${SWIFT_ROOT}/stc/bin
CMD test-sanity.sh