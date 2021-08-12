ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

ARG FLUX_CORE_VERSION=0.28.0
ARG FLUX_SCHED_VERSION=0.17.0
ENV FLUX_CORE_VERSION ${FLUX_CORE_VERSION}
ENV FLUX_SCHED_VERSION ${FLUX_SCHED_VERSION}

# Install Flux-core from release tarball
RUN V=$FLUX_CORE_VERSION \
   && PKG=flux-core-$V \
   && URL=https://github.com/flux-framework/flux-core/releases/download \
   && wget ${URL}/v${V}/${PKG}.tar.gz \
   && tar xvf ${PKG}.tar.gz \
   && cd ${PKG} \
   && PYTHON_VERSION=3 ./configure --prefix=/usr \
   && make -j 4 \
   && make install \
   && cd .. \
   && rm -rf flux-core-* \
   && ldconfig

# Install Flux-sched from release tarball
RUN V=$FLUX_SCHED_VERSION \
   && PKG=flux-sched-$V \
   && URL=https://github.com/flux-framework/flux-sched/releases/download \
   && wget ${URL}/v${V}/${PKG}.tar.gz \
   && tar xvf ${PKG}.tar.gz \
   && cd ${PKG} \
   && PYTHON_VERSION=3 ./configure --prefix=/usr \
   && make -j 4 \
   && make install \
   && cd .. \
   && rm -rf flux-sched-* \
   && ldconfig

# Use the +/- features of env var expansion to only include ':$PYTHONPATH' if
# $PYTHONPATH is set, otherwise it all expands to the empty string.
# Note: we add both the `lib` and `lib64` directories to support centos7 and centos8,
# respectively.  For each distro, one of the directories is populated and the other
# does not, but adding non-existent directories to PYTHONPATH has no correctness
# implications, only (small) performance implications.
ENV PYTHONPATH="/usr/lib64/flux/python3.6:/usr/lib/flux/python3.6${PYTHONPATH:+:}${PYTHONPATH:-}"

COPY test.sh checks-annotate.sh /
CMD /test.sh
