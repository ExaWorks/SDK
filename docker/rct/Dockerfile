
# RCT DOCKERFILE

ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

RUN mkdir -p /data/db /var/log/mongodb /var/run/mongodb
ENV RADICAL_PILOT_DBURL=mongodb://localhost/am

# RCT installation (use EnTK devel package temporary)
RUN pip install \
    radical.pilot \
    git+https://github.com/radical-cybertools/radical.entk.git@devel

# clone RP and RE to get the test suite
RUN git clone -b master --single-branch https://github.com/radical-cybertools/radical.pilot.git \
 && git clone -b master --single-branch https://github.com/radical-cybertools/radical.entk.git

COPY run_rp_test.sh /tests/rp/test.sh
COPY run_re_test.sh /tests/re/test.sh

# start mongodb and run RP tests
CMD  /bin/sh /tests/rp/test.sh
