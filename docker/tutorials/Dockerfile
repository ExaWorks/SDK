
FROM jupyter/minimal-notebook:python-3.9

ENV JUPYTER_ENABLE_LAB=yes

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
