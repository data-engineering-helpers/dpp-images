#
# Source: https://github.com/data-engineering-helpers/dpp-images/tree/main/pyspark-coretto-8-emr-dbs-universal-python/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Usual Docker tag: pyspark-emr-dbs-univ (infrahelpers/dpp:pyspark-emr-dbs-univ)
#
# Base image for Data Processing Pipelines (DPP), with images
# for specific Python versions
#
# Inspired by:
# * EMR: https://aws.amazon.com/blogs/big-data/simplify-your-spark-dependency-management-with-docker-in-emr-6-0-0
# * DataBricks: https://github.com/databricks/containers
#
# A pristine Python installation is performed, with a specific version,
# namely 3.9.16 here (latest release of the 3.9 minor version). A 3.9 version
# allows it to work on both DataBricks (which uses Python 3.8 internally
# by default) and AWS EMR (which uses Python 3.7.10 by default).
# As of March 2023, on EMR 6.9, libraries/wheels developed with newer versions
# of Python (e.g., 3.10+) will most certainly fail on AWS EMR.
#
# AWS Corretto / EMR
# ===================
#  + https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html
#  + https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/docker-install.html
# The underlying operating system (OS) is Amazon Linux 2, i.e., based on a
# RedHat Linux 7 with some Amazon specific additions.
# The Python version is 3.7.15 by default, if installed with the Linux
# distribution.
# Note that, up to at least version 6.9.0 of EMR, only Java 8 is supported.
# With Java 11+, it generates errors like
# https://confluence.atlassian.com/confkb/unrecognized-jvm-gc-options-when-using-java-11-1002472841.html
#
# DataBricks
# ==========
#  + Base image Dockerfile: https://github.com/databricks/containers/tree/master/ubuntu/standard
#  + Base image on Docker Hub: https://hub.docker.com/r/databricksruntime/standard
#     - Usual Docker tag: latest
#
# The underlying operating system (OS) is Ubuntu 18.04 LTS (Bionic Beaver).
# The Python installation has to be a virtual environment in
# /databricks/python3, and Python is the main one (pristine, installed manually
# by that container image)
#
FROM amazoncorretto:8

LABEL authors "Denis Arnaud <denis.arnaud_fedora@m4x.org>"

# Environment
ENV container="docker"
ENV HOME="/root"
ENV HOMEUSR="/home/ubuntu"
ENV PYSPARK_PYTHON="/databricks/python3/bin/python3"
ENV PYSPARK_DRIVER_PYTHON="python3"
ENV PYTHON_MINOR_VERSION="3.9"
ENV PYTHON_MICRO_VERSION="${PYTHON_MINOR_VERSION}.16"

# Update the OS and install a few packages useful for software development
# (needed for some Python modules like SHAP)
RUN yum -y update && \
	yum -y install yum-utils && \
	yum -y groupinstall development && \
	yum clean all

# Install a few more utilities, including pre-requisites for Python
RUN yum -y install procps net-tools hostname iproute coreutils \
	openssl-devel less htop passwd which sudo man vim git tar tree \
	wget curl file bash-completion keyutils zlib-devel bzip2-devel gzip \
	autoconf automake libtool m4 gcc gcc-c++ cmake cmake3 libffi-devel \
	readline-devel sqlite-devel jq fuse fuse-libs && \
	yum clean all

# 
RUN yum -y install passwd fuse fuse-libs iproute net-tools procps coreutils \
	gcc openssl-devel gzip bzip2-devel libffi-devel zlib-devel && \
	yum clean all

#
WORKDIR $HOME

# Cloud helpers Shell scripts (https://github.com/cloud-helpers/k8s-job-wrappers)
RUN KJW_VER=$(curl -Ls https://api.github.com/repos/cloud-helpers/k8s-job-wrappers/tags|jq -r '.[].name'|grep "^v"|sort -r|head -1|cut -d'v' -f2,2) && \
	curl -Ls \
	  https://github.com/cloud-helpers/k8s-job-wrappers/archive/refs/tags/v${KJW_VER}.tar.gz \
         -o k8s-job-wrappers.tar.gz && \
    tar zxf k8s-job-wrappers.tar.gz && rm -f k8s-job-wrappers.tar.gz && \
    mv -f k8s-job-wrappers-${KJW_VER} /usr/local/ && \
    ln -s /usr/local/k8s-job-wrappers-${KJW_VER} /usr/local/k8s-job-wrappers

# AWS: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN curl -Ls https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
         -o awscliv2.zip && \
    unzip -q awscliv2.zip && rm -f awscliv2.zip && ./aws/install && \
	rm -rf ./aws

# SAML-to-AWS (saml2aws)
# https://github.com/Versent/saml2aws
RUN SAML2AWS_VER=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
	curl -Ls \
	https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VER}/saml2aws_${SAML2AWS_VER}_linux_amd64.tar.gz -o saml2aws.tar.gz && \
	tar zxf saml2aws.tar.gz && rm -f saml2aws.tar.gz README.md LICENSE.md && \
	mv -f saml2aws /usr/local/bin/ && \
    chmod 775 /usr/local/bin/saml2aws

# Copy configuration in the user home, for the root user
ADD bashrc $HOME/.bashrc

# Install the PYTHON_MICRO_VERSION version of Python
RUN curl -kLs \
	https://www.python.org/ftp/python/${PYTHON_MICRO_VERSION}/Python-${PYTHON_MICRO_VERSION}.tgz \
	-o Python-${PYTHON_MICRO_VERSION}.tgz && \
	tar zxf Python-${PYTHON_MICRO_VERSION}.tgz && \
	rm -f Python-${PYTHON_MICRO_VERSION}.tgz && \
    cd Python-${PYTHON_MICRO_VERSION} && \
    ./configure --prefix=/usr && \
    make && \
    make altinstall

# Set the PYTHON_MICRO_VERSION version of Python as system Python
# This is what is used by AWS EMR
RUN cp -f /usr/bin/python${PYTHON_MINOR_VERSION} /usr/bin/python3 && \
	cp -f /usr/bin/python${PYTHON_MINOR_VERSION} /usr/bin/python

# Create an ubuntu user
RUN useradd ubuntu && \
	echo "ubuntu  ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
	chmod 0440 /etc/sudoers.d/ubuntu

# Create a /databricks/python3 directory and set environment and permissions
# This is what is used by DataBricks
RUN	mkdir -p /databricks/python3 && chown -R ubuntu:ubuntu /databricks
ENV PYSPARK_PYTHON="/databricks/python3/bin/python3"

# Install a virtual environment in /databricks/python3
RUN python3 -mpip install virtualenv && \
	virtualenv --system-site-packages /databricks/python3

