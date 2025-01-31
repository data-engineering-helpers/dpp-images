#
# Source: https://github.com/data-engineering-helpers/dpp-images/tree/main/pyspark-coretto-emr-dbs-universal-base/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Convention for the tags of the generated images:
# * infrahelpers/dpp:jdk{JDK_VERSION} e.g.:
#  * infrahelpers/dpp:jdk17
#  * infrahelpers/dpp:jdk11
#  * infrahelpers/dpp:jdk8
#
# Base image for Data Processing Pipelines (DPP), with images
# for specific Python versions
#
# Inspired by:
# * EMR: https://aws.amazon.com/blogs/big-data/simplify-your-spark-dependency-management-with-docker-in-emr-6-0-0
# * DataBricks: https://github.com/databricks/containers
#
# A pristine Python installation is performed by the downstream images
# (see the pyspark-py3X/ directories), with specific versions.
# Note that:
# * DataBricks uses Python 3.10 internally by default
# * AWS EMR uses Python 3.9 by default
#
# AWS Corretto / EMR
# ==================
# * https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/docker-install.html
# * https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/docker-install.html
# * https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html
#
# The underlying operating system (OS) is:
# * Amazon Linux 2023 (AL2023) for Corretto 17, based on a
#   RedHat Linux 8 with some Amazon specific additions.
# * Amazon Linux 2 for Corretto 11 and Corretto 8, based on a
#   RedHat Linux 7 with some Amazon specific additions.
# The Python version is 3.9 by default (on Corretto 17), if installed with
# the Linux distribution.
# Note that, for EMR versions lower than 6.x, only Java 8 was supported.
# With Java 11+, it generated errors like
# https://confluence.atlassian.com/confkb/unrecognized-jvm-gc-options-when-using-java-11-1002472841.html
# From EMR 7.x, Java 17 is now fully supported.
#
# DataBricks
# ==========
# * Base image Dockerfile: https://github.com/databricks/containers/tree/master/ubuntu/standard
# * Base image on Docker Hub: https://hub.docker.com/r/databricksruntime/standard
#   * Usual Docker tag: latest
#
# The underlying operating system (OS) is Ubuntu 22.04 LTS (Jammy Jellyfish).
# The Python installation has to be a virtual environment in
# /databricks/python3, and Python is the main one (pristine, installed manually
# by that container image)
#
ARG JDK_VERSION="8"
ARG JDK_TYPE="leg"
FROM amazoncorretto:${JDK_VERSION} AS basejdk

LABEL authors="Denis Arnaud <denis.arnaud_fedora@m4x.org>, Nicolas Gibaud <nicolas.gibaud.partner@decathlon.com>"

# Environment
ENV container="docker"
ENV HOME="/root"
ENV HOMEUSR="/home/ubuntu"
ENV PYSPARK_DRIVER_PYTHON="python3"

# Update the OS and install a few packages useful for software development
# (needed for some Python modules like SHAP)
RUN yum -y update && \
	yum -y install yum-utils shadow-utils && \
	yum -y groupinstall development && \
	yum clean all && rm -rf /var/cache/yum

# Install a few more utilities, including pre-requisites for Python
RUN yum -y install procps net-tools hostname iproute bind-utils \
	less htop passwd which sudo man vim git tar tree \
	wget file bash-completion keyutils bc \
	zlib-devel bzip2-devel gzip \
	autoconf automake libtool m4 gcc gcc-c++ cmake cmake3 libffi-devel \
	readline-devel sqlite-devel fuse fuse-libs && \
	yum clean all && rm -rf /var/cache/yum

FROM basejdk AS jdk-new
RUN yum -y install curl-minimal openssl-libs openssl-devel && yum clean all && rm -rf /var/cache/yum

FROM basejdk AS jdk-leg
RUN yum -y install curl coreutils openssl11-libs openssl11-devel && yum clean all && rm -rf /var/cache/yum

#
FROM jdk-${JDK_TYPE} AS final
WORKDIR $HOME

# Install a newer jq version (as jq v1.5 seems to have some issues)
RUN JQ_VER=$(curl -Ls https://api.github.com/repos/jqlang/jq/releases/latest | grep 'tag_name' | cut -d'-' -f2,2 | cut -d'"' -f1,1) && \
	echo "JQ_VER=${JQ_VER}" && \
	curl -Ls \
	https://github.com/jqlang/jq/releases/download/jq-${JQ_VER}/jq-linux-amd64 -o /usr/local/bin/jq && \
	chmod +x /usr/local/bin/jq

# yq, the YAML CLI utility like jq, for YAML (https://github.com/mikefarah/yq)
RUN YQ_VER=$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
	architecture=$(uname -m|sed 's/x86_/amd/') && \
	echo "YQ_VER=${YQ_VER} - architecture=${architecture}" && \
	curl -Ls \
	https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_${architecture} -o /usr/local/bin/yq && \
	chmod +x /usr/local/bin/yq

# Cloud helpers Shell scripts (https://github.com/cloud-helpers/k8s-job-wrappers)
RUN KJW_VER=$(curl -Ls https://api.github.com/repos/cloud-helpers/k8s-job-wrappers/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
	echo "KJW_VER=${KJW_VER}" && \
	curl -Ls \
	https://github.com/cloud-helpers/k8s-job-wrappers/archive/refs/tags/v${KJW_VER}.tar.gz -o k8s-job-wrappers.tar.gz && \
    tar zxf k8s-job-wrappers.tar.gz && rm -f k8s-job-wrappers.tar.gz && \
    mv -f k8s-job-wrappers-${KJW_VER} /usr/local/ && \
    ln -s /usr/local/k8s-job-wrappers-${KJW_VER} /usr/local/k8s-job-wrappers

# AWS: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN architecture=$(uname -m) && \
	echo "architecture=${architecture}" && \
	curl -Ls https://awscli.amazonaws.com/awscli-exe-linux-${architecture}.zip -o awscliv2.zip && \
	unzip -q awscliv2.zip && rm -f awscliv2.zip && ./aws/install && \
	rm -rf ./aws

# HashiCorp Vault (https://developer.hashicorp.com/vault/install)
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    yum -y install vault

# SAML-to-AWS (saml2aws) - https://github.com/Versent/saml2aws
# AWS SSO is becoming mainstream (and replacing SAML2AWS)
#RUN SAML2AWS_VER=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
#	curl -Ls \
#	https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VER}/saml2aws_${SAML2AWS_VER}_linux_amd64.tar.gz -o saml2aws.tar.gz && \
#	tar zxf saml2aws.tar.gz && rm -f saml2aws.tar.gz README.md LICENSE.md && \
#	mv -f saml2aws /usr/local/bin/ && \
#	chmod +x /usr/local/bin/saml2aws

# Copy configuration in the user home, for the root user
ADD bashrc $HOME/.bashrc

# Create an ubuntu user
RUN useradd ubuntu && \
	echo "ubuntu  ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
	chmod 0440 /etc/sudoers.d/ubuntu

# Create a /databricks/python3 directory and set environment and permissions
# This is what is used by DataBricks
RUN mkdir -p /databricks/python3 && chown -R ubuntu:ubuntu /databricks

# Default non-root user
USER ubuntu

