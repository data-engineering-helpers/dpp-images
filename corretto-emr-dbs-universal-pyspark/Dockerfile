#
# Source: https://github.com/data-engineering-helpers/dpp-images/tree/main/corretto-emr-dbs-universal-pyspark/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Usual Docker tags:
# * infrahelpers/dpp:jdk{JDK_VERSION}-python{PYTHON_MINOR_VERSION}
# * infrahelpers/dpp:jdk{JDK_VERSION}-python{PYTHON_MICRO_VERSION}
#
# Image containing python installation, to be accessed by EMR and Databricks (for PySpark)
# See https://github.com/data-engineering-helpers/dpp-images/tree/main/coretto-emr-dbs-universal-base/Dockerfile
# for more details about the base image (tag: infrahelpers/dpp:jdk{JDK_VERSION})
#
ARG JDK_VERSION

FROM infrahelpers/dpp:jdk${JDK_VERSION}

LABEL authors="Denis Arnaud <denis.arnaud_fedora@m4x.org>, Nicolas Gibaud <nicolas.gibaud.partner@decathlon.com>"

ARG PYTHON_MINOR_VERSION
ARG PYTHON_MICRO_VERSION

# Environment
ENV container="docker"
ENV HOME="/root"
ENV HOMEUSR="/home/ubuntu"
ENV PYSPARK_DRIVER_PYTHON="python3"
ENV PYTHON_MINOR_VERSION=$PYTHON_MINOR_VERSION
ENV PYTHON_MICRO_VERSION=$PYTHON_MICRO_VERSION
ENV PYSPARK_PYTHON="/databricks/python3/bin/python3"

# Update the OS
RUN yum -y update && yum clean all && rm -rf /var/cache/yum

# Install the PYTHON_MICRO_VERSION version of Python
RUN curl -kLs \
	https://www.python.org/ftp/python/${PYTHON_MICRO_VERSION}/Python-${PYTHON_MICRO_VERSION}.tgz \
	-o Python-${PYTHON_MICRO_VERSION}.tgz && \
	tar zxf Python-${PYTHON_MICRO_VERSION}.tgz && \
	rm -f Python-${PYTHON_MICRO_VERSION}.tgz && \
	cd Python-${PYTHON_MICRO_VERSION} && \
	./configure --prefix=/usr --enable-optimizations && \
	make && make altinstall && \
	cd .. && rm -rf Python-${PYTHON_MICRO_VERSION}

# Set the PYTHON_MICRO_VERSION version of Python as system Python
# This is what is used by AWS EMR
RUN cd /usr/bin && \
	rm -f /usr/bin/python3 && ln -s python${PYTHON_MINOR_VERSION} python3 \
	&& cd .. && python -V && python3 -V && \
	python3 -mpip install -U pip

# Install a virtual environment in /databricks/python3
RUN python3 -mpip install -U pip && python3 -mpip install virtualenv && \
	virtualenv --system-site-packages /databricks/python3 && \
	chown -R ubuntu:ubuntu /databricks/python3 && \
	/databricks/python3/bin/python -V && \
	/databricks/python3/bin/python -mpip install -U pip

