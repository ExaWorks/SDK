# Parsl addition to ExaWorks SDK 
# See https://parsl.readthedocs.io/en/stable/quickstart.html

ARG BASE_IMAGE=exaworks/sdk-base
FROM ${BASE_IMAGE}

# Base has Python 3.6 installed

# Recent versions of cryptography require Rust (the language) to be
# installed. However, the version that comes with Centos 7 is too old.
# Installing Rust using the install script on rust-lang.org requires
# interactivity.
# cyptography 3.3.2 appears to be a recent version that does not use
# the rust build, so we'll use that until a more sensible solution
# is found.

RUN python3 -m pip install git+https://github.com/Parsl/parsl.git@master

COPY test.py /
COPY test.sh /
CMD /test.sh

