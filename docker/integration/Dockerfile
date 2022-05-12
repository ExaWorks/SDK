ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

# install pytest-tap to allow Parsl's pytest scripts to output TAP
RUN python3 -m pip install pytest-tap

COPY flux-parsl.sh /tests/flux-parsl/test.sh

CMD bash
