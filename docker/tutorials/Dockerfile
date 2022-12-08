
FROM jupyter/minimal-notebook:python-3.9

ENV JUPYTER_ENABLE_LAB=yes

USER ${NB_UID}

WORKDIR /tutorials/
COPY --chown=${NB_UID}:${NB_GID} ./ ./
