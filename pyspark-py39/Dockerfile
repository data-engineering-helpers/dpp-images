#
# Source: https://github.com/data-engineering-helpers/dpp-images/tree/main/pyspark-py39/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Usual Docker tag: py39 (infrahelpers/dpp:py39)
#
# Specific image for Python 3.9 based Data Processing Pipelines (DPP)
#
# See https://github.com/data-engineering-helpers/dpp-images/tree/main/pyspark-coretto-8-emr-dbs-universal-python/Dockerfile
# for more details about the base image (tag: infrahelpers/dpp:pyspark-emr-dbs-univ)
#
FROM infrahelpers/dpp:pyspark-emr-dbs-univ

LABEL authors "Denis Arnaud <denis.arnaud_fedora@m4x.org>"

# Environment
ENV container="docker"
ENV HOME="/root"
ENV HOMEUSR="/home/ubuntu"
ENV PYSPARK_DRIVER_PYTHON="python3"
ENV PYTHON_MINOR_VERSION="3.9"
ENV PYTHON_MICRO_VERSION="${PYTHON_MINOR_VERSION}.16"
ENV PYSPARK_PYTHON="/databricks/python3/bin/python3"

# Update the OS
RUN yum -y update && yum clean all

# Install the PYTHON_MICRO_VERSION version of Python
RUN curl -kLs \
	https://www.python.org/ftp/python/${PYTHON_MICRO_VERSION}/Python-${PYTHON_MICRO_VERSION}.tgz \
	-o Python-${PYTHON_MICRO_VERSION}.tgz && \
	tar zxf Python-${PYTHON_MICRO_VERSION}.tgz && \
	rm -f Python-${PYTHON_MICRO_VERSION}.tgz && \
    cd Python-${PYTHON_MICRO_VERSION} && \
    ./configure --prefix=/usr --enable-optimizations && \
    make && \
    make altinstall

# Set the PYTHON_MICRO_VERSION version of Python as system Python
# This is what is used by AWS EMR
RUN cp -f /usr/bin/python${PYTHON_MINOR_VERSION} /usr/bin/python3 && \
	cp -f /usr/bin/python${PYTHON_MINOR_VERSION} /usr/bin/python && \
    python3 --version

# Install a virtual environment in /databricks/python3
RUN python3 -mpip install -U pip && python3 -mpip install virtualenv && \
	virtualenv --system-site-packages /databricks/python3 && \
	chown -R ubuntu:ubuntu /databricks/python3

