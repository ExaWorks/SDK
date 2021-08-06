ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

# install pytest-tap to allow Parsl's pytest scripts to output TAP
RUN python3 -m pip install pytest-tap

RUN mkdir /sdk_tests
COPY test_integration.sh /sdk_tests/
CMD /sdk_tests/test_integration.sh
