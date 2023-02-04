
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

# Parsl

RUN git clone -b main --single-branch https://github.com/ExaWorks/molecular-design-parsl-demo \
 && cd molecular-design-parsl-demo \
 && sed -i '1d' environment.yml \
 && mamba env create -n parsl -f environment.yml \
 && mamba update -y -n parsl \
    jupyterlab_widgets \
    ipywidgets

# RADICAL-Pilot (RP) & RADICAL-EnTK (RE)

RUN mamba install -y -c conda-forge \
    radical.pilot=1.20 \
    radical.entk=1.20

# Parsl-RP Integration usecase NWChem

RUN mamba install -y -c conda-forge \
    nwchem

# Needed for MPI example in PSI/J

RUN mamba install -y -c conda-forge \
    gxx_linux-64 \
    openmpi
