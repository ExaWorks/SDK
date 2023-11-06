
# RCT DOCKERFILE

ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

# RCT installation (RADICAL-EnTK includes RADICAL-Pilot)
RUN pip install \
    radical.entk

# clone RP and RE to get the test suite
RUN git clone -b master --single-branch https://github.com/radical-cybertools/radical.pilot.git \
 && git clone -b master --single-branch https://github.com/radical-cybertools/radical.entk.git

COPY run_rp_test.sh /tests/rp/test.sh
COPY run_re_test.sh /tests/re/test.sh

# run RP tests
CMD  /bin/sh /tests/rp/test.sh
