
# RP DOCKERFILE

ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

RUN mkdir -p /data/db /var/log/mongodb /var/run/mongodb
ENV RADICAL_PILOT_DBURL=mongodb://localhost/am

# RP install
RUN pip install radical.pilot

# also clone the RP to get the test suite
RUN git clone -b master --single-branch https://github.com/radical-cybertools/radical.pilot.git

# start mongodb and run the tests
COPY run_rp_test.sh /tests/rp/test.sh
CMD  /bin/sh /tests/rp/test.sh
