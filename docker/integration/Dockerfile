ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

# Parsl-Flux integration

# install pytest-tap to allow Parsl's pytest scripts to output TAP
RUN python3 -m pip install pytest-tap
COPY parsl-flux.sh /tests/parsl-flux/test.sh

# RP-Flux integration

RUN mkdir -p /root/.radical/pilot/configs/
COPY resource_flux.json /root/.radical/pilot/configs/resource_flux.json
COPY rp-flux.sh /tests/rp-flux/test.sh

CMD bash
