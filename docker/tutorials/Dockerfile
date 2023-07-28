
# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG BUILDPLATFORM=linux/amd64
ARG PY_VER=3.9

FROM --platform=${BUILDPLATFORM} jupyter/minimal-notebook:python-${PY_VER}

ENV JUPYTER_ENABLE_LAB=yes

USER root

RUN apt-get update -y \
 && apt-get install -y bc curl gnupg

# General jupyter deps

RUN mamba install -y -n base -c conda-forge \
    ipywidgets \
    jupyterlab_widgets \
    nb_conda_kernels \
    nodejs \
 && mamba clean -a -f -y \
 && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

USER ${NB_UID}

# Config for nb_conda_kernels

RUN printf '\n\
{ \n\
  "CondaKernelSpecManager": { \n\
    "kernelspec_path": "--user" \n\
  } \n\
} \n\
' > $(jupyter --config-dir)/jupyter_config.json \
 && jupyter nbextension install --user --py widgetsnbextension

# Tutorials

WORKDIR /tutorials/
COPY --chown=${NB_UID}:${NB_GID} ./ ./

# RADICAL-Cybertools (RADICAL-EnTK and RADICAL-Pilot)

RUN mamba install -y -c conda-forge \
    'radical.entk>=1.30'

# Parsl-RP integration usecase NWChem

RUN mamba install -y -c conda-forge \
    nwchem

# PSI/J - MPI example

RUN mamba install -y -c conda-forge \
    gxx_linux-64 \
    openmpi

# Swift/T

RUN mamba install -y -c conda-forge \
    gcc zsh openjdk=11 openmpi numpy \
 && mamba install -y -c conda-forge \
    http://web.cels.anl.gov/~woz/swift-t-1.6.0-py39_1.tar.bz2

# Clonning repos and creation of environments from there

RUN git clone -b main --single-branch \
    https://github.com/ExaWorks/Tutorial.git \
    /tutorials/sdk-examples \
 && git clone -b main --single-branch \
    https://github.com/ExaWorks/molecular-design-parsl-demo \
    /tutorials/molecular-design-parsl-demo

# Parsl

RUN cd /tutorials/molecular-design-parsl-demo \
 && sed -i '1d' environment.yml \
 && mamba env create -n parsl -f environment.yml \
 && mamba update -y -n parsl \
    jupyterlab_widgets \
    ipywidgets

