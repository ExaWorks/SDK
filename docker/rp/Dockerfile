
# RP DOCKERFILE

# The ExaWorks SDK Base
# this expectes something like `docker build base -t base`
FROM base

# Install dependencies
RUN yum -y install openmpi python3-pip

# MongoDB install
RUN echo -e "\
[mongodb]\n\
name     = MongoDB Repository \n\
baseurl  = https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/3.0/x86_64/ \n\
gpgcheck = 0 \n\
enabled  = 1 \n" >> /etc/yum.repos.d/mongodb.repo

RUN yum update -y && yum -y install mongodb-org
RUN mkdir -p /data/db /var/log/mongodb /var/run/mongodb
ENV RADICAL_PILOT_DBURL=mongodb://localhost/am

# RP install
ENV VIRTUAL_ENV=/ve_rp
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN which python3
RUN pip install --upgrade pip setuptools
RUN pip install pytest
RUN pip install radical.pilot

RUN git clone https://github.com/radical-cybertools/radical.pilot.git

# start mongodb and test
COPY run_rp_test.sh run_rp_test.sh
CMD  /bin/sh ./run_rp_test.sh

