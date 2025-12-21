#
# File: https://github.com/data-engineering-helpers/dpp-images/blob/main/corretto-emr-dbs-universal-pyspark/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Usual Docker tags:
# * infrahelpers/dpp:jdk{JDK_VERSION}-python{PYTHON_MINOR_VERSION}
# * infrahelpers/dpp:jdk{JDK_VERSION}-python{PYTHON_MICRO_VERSION}
#
# Image containing python installation, to be accessed by EMR and Databricks (for PySpark)
# See https://github.com/data-engineering-helpers/dpp-images/tree/main/coretto-emr-dbs-universal-base/Dockerfile
# for more details about the base image (tag: infrahelpers/dpp:jdk{JDK_VERSION})
#
ARG JDK_VERSION="17"
FROM infrahelpers/dpp:jdk${JDK_VERSION}

LABEL authors="Denis Arnaud <denis.arnaud_fedora@m4x.org>, Nicolas Gibaud <nicolas.gibaud.partner@decathlon.com>"

# https://docs.docker.com/reference/dockerfile/#understand-how-arg-and-from-interact
ARG JDK_VERSION
ARG PYTHON_MINOR_VERSION="3.12"
ARG PYTHON_MICRO_VERSION="3.12.12"
ARG PYTHON_INSTALL_DIR="/usr/local"

# Environment
ENV container="docker"
ENV HOMEADM="/root"
ENV HOME="/home/ubuntu"
ENV PYSPARK_DRIVER_PYTHON="python3"
ENV PYTHON_MINOR_VERSION=$PYTHON_MINOR_VERSION
ENV PYTHON_MICRO_VERSION=$PYTHON_MICRO_VERSION
ENV PYSPARK_PYTHON="/databricks/python3/bin/python3"

# Revert the user to root (as it has been set to ubuntu in the base image)
USER root

# Update the OS
RUN dnf -y upgrade && dnf clean all && rm -rf /var/cache/dnf

# Install the PYTHON_MICRO_VERSION version of Python
RUN curl -kLs \
	https://www.python.org/ftp/python/${PYTHON_MICRO_VERSION}/Python-${PYTHON_MICRO_VERSION}.tgz \
	-o Python-${PYTHON_MICRO_VERSION}.tgz && \
	tar zxf Python-${PYTHON_MICRO_VERSION}.tgz && \
	rm -f Python-${PYTHON_MICRO_VERSION}.tgz && \
	cd Python-${PYTHON_MICRO_VERSION} && \
	./configure --prefix=${PYTHON_INSTALL_DIR} --enable-optimizations && \
	make && make altinstall && \
	cd .. && rm -rf Python-${PYTHON_MICRO_VERSION}

# Set the PYTHON_MICRO_VERSION version of Python as system Python
# This is what is used by AWS EMR
RUN mkdir -p $HOME/.cache/pip && chown -R root:root $HOME/.cache/pip
RUN cd ${PYTHON_INSTALL_DIR}/bin && \
	ln -s python${PYTHON_MINOR_VERSION} python && \
	ln -s python${PYTHON_MINOR_VERSION} python3 && \
	ln -s pip${PYTHON_MINOR_VERSION} pip && \
	ln -s pip${PYTHON_MINOR_VERSION} pip3 && \
	cd $HOMEADM && \
	python -V || echo "System python does not seem to work - that is fine" && \
	${PYTHON_INSTALL_DIR}/bin/python -V && python3 -V && \
	${PYTHON_INSTALL_DIR}/bin/python -mpip install -U pip

# Install a virtual environment in /databricks/python3
RUN ${PYTHON_INSTALL_DIR}/bin/pip install --break-system-packages --no-cache-dir virtualenv && \
	virtualenv --system-site-packages --python=python${PYTHON_MINOR_VERSION} \
	  /databricks/python3 --no-download --no-setuptools && \
	chown -R ubuntu:ubuntu /databricks/python3 && \
	/databricks/python3/bin/python -V && \
	/databricks/python3/bin/python -mpip install -U pip

RUN chown -R ubuntu:ubuntu $HOME/.cache/pip

# Default non-root user
USER ubuntu

