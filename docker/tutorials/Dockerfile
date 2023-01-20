
ARG BUILDPLATFORM=linux/amd64
FROM --platform=${BUILDPLATFORM} jupyter/minimal-notebook:python-3.9

ENV JUPYTER_ENABLE_LAB=yes

USER root

RUN apt-get update -y && apt-get install -y bc curl gnupg

USER ${NB_UID}

WORKDIR /tutorials/
COPY --chown=${NB_UID}:${NB_GID} ./ ./

# Parsl

RUN conda install -y \
    ipywidgets matplotlib pandas qcelemental qcengine rdkit scikit-learn tqdm \
 && conda install -y -c conda-forge parsl

RUN cd parsl \
 && git clone -b main --single-branch https://github.com/ExaWorks/molecular-design-parsl-demo \
 && pip install -e molecular-design-parsl-demo/

# RADICAL-EnTK

RUN conda install -y -c conda-forge radical.entk
