
# RP/RCT DOCKERFILE

ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

RUN mkdir -p /data/db /var/log/mongodb /var/run/mongodb
ENV RADICAL_PILOT_DBURL=mongodb://localhost/am

# RCT installation
RUN pip install radical.pilot radical.entk

# clone RP and RE to get the test suite
RUN git clone -b master --single-branch https://github.com/radical-cybertools/radical.pilot.git \
 && git clone -b master --single-branch https://github.com/radical-cybertools/radical.entk.git

# start mongodb and run RP tests
COPY run_rp_test.sh /tests/rp/test.sh
CMD  /bin/sh /tests/rp/test.sh
