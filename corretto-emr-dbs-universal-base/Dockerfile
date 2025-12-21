#
# File: https://github.com/data-engineering-helpers/dpp-images/blob/main/corretto-emr-dbs-universal-base/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Convention for the tags of the generated images:
# * infrahelpers/dpp:jdk{JDK_VERSION} e.g.:
#  * infrahelpers/dpp:jdk25
#  * infrahelpers/dpp:jdk21
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
# * DataBricks uses Python 3.12 internally by default (with Runtime 16.4 LTS)
# * Corretto uses:
#	  * Python 3.9 by default on Corretto 23-25
#	  * Python 3.7 by default on Corretto 8-21
#
# AWS Corretto / EMR
# ==================
# * Dockerfile on GitHub: https://github.com/corretto/corretto-docker
# * Docker Hub: https://hub.docker.com/_/amazoncorretto
# Note that NOT all the yearly versions are perpetually available.
# Typically, yearly versions are available only up until 1-2 years after release.
# For instance, JDK23 and JDK24 have been available up until mid-2025.
# Be careful that, once those yearly versions are no longer maintained,
# the security issues may increase in a way out of control. In other words,
# do not maintain images based on no longer maintained yearly versions (e.g.,
# as of Q4 2025, JDK23-based and JDK24 images should no longer be used).
#
# Version specific pages on AWS documentation site:
# * https://docs.aws.amazon.com/corretto/latest/corretto-25-ug/docker-install.html
# * https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/docker-install.html
# * https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/docker-install.html
# * https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/docker-install.html
# * https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html
#
# All kinds of operating systems (OS) are now available, with a selection below.
# If not specified, in the Docker tag, Amazon Linux 2 will be used by default.
# * Amazon Linux 2023 (AL2023), based on a RedHat Linux 8 with some Amazon
#	specific additions.
#   * Add `-al2023` to the tag (e.g., 17-al2023)
# * Amazon Linux 2, based on a RedHat Linux 7 with some Amazon specific additions.
#   * That is the default OS
# * Alpine 3.2x
#   * Add `-alpine3.2x` to the tag (e.g., 17-alpine3.22)
# * Debian 11 (Bullseye)
#   * Although there are Dockerfile for Debian Slim, there does not seem to be
#   the corresponding tags supporting it
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
ARG JDK_VERSION="17"
FROM amazoncorretto:${JDK_VERSION}-al2023
# https://docs.docker.com/reference/dockerfile/#understand-how-arg-and-from-interact
ARG JDK_VERSION

LABEL authors="Denis Arnaud <denis.arnaud_fedora@m4x.org>, Nicolas Gibaud <nicolas.gibaud.partner@decathlon.com>"

# Environment
ENV container="docker"
ENV HOMEADM="/root"
ENV HOME="/home/ubuntu"
ENV PYSPARK_DRIVER_PYTHON="python3"

# Update the OS and install a few packages useful for software development
# (needed for some Python modules like SHAP)
RUN dnf -y upgrade && \
	dnf -y install dnf-utils shadow-utils && \
	dnf -y groupinstall development && \
	dnf clean all && rm -rf /var/cache/dnf

# Install a few more utilities, including pre-requisites for Python
# Ref: https://devguide.python.org/getting-started/setup-building/index.html#install-dependencies
RUN dnf -y install procps net-tools hostname iproute bind-utils iputils whois \
	less htop passwd which sudo man vim git tar tree \
	wget file bash-completion keyutils bc curl-minimal \
	openssl-libs openssl-devel \
	gcc gcc-c++ gdb glibc-devel libffi-devel \
	autoconf automake libtool m4 cmake cmake3 \
	zlib-devel bzip2-devel gzip xz-devel libzstd-devel \
	readline-devel fuse fuse-libs \
	perf expat expat-devel mpdecimal \
	sqlite sqlite-devel sqlite-libs	\
	libpq-devel postgresql17 \
	libuuid-devel gdbm-devel && \
	dnf clean all && rm -rf /var/cache/dnf

#
WORKDIR $HOMEADM

# Install a newer jq version (as jq v1.5 seems to have some issues)
RUN JQ_VER=$(curl -Ls https://api.github.com/repos/jqlang/jq/releases/latest | grep 'tag_name' | cut -d'-' -f2,2 | cut -d'"' -f1,1) && \
	architecture=$(uname -m|sed 's/x86_/amd/'|sed 's/aarch/arm/') && \
	echo "JQ_VER=${JQ_VER} - architecture=${architecture}" && \
	curl -Ls \
	https://github.com/jqlang/jq/releases/download/jq-${JQ_VER}/jq-linux-${architecture} -o /usr/local/bin/jq && \
	chmod +x /usr/local/bin/jq

# yq, the YAML CLI utility like jq, for YAML (https://github.com/mikefarah/yq)
RUN YQ_VER=$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
	architecture=$(uname -m|sed 's/x86_/amd/'|sed 's/aarch/arm/') && \
	echo "YQ_VER=${YQ_VER} - architecture=${architecture}" && \
	curl -Ls \
	https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_${architecture} -o /usr/local/bin/yq && \
	chmod +x /usr/local/bin/yq

# usql, the universal CLI tool for databases (https://github.com/xo/usql)
RUN USQL_VER=$(curl -Ls https://api.github.com/repos/xo/usql/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
	architecture=$(uname -m|sed 's/x86_/amd/'|sed 's/aarch/arm/') && \
	echo "USQL_VER=${USQL_VER} - architecture=${architecture}" && \
	curl -Ls \
	https://github.com/xo/usql/releases/download/v${USQL_VER}/usql-${USQL_VER}-linux-${architecture}.tar.bz2 -o usql.tar.bz2 && \
	tar jxf usql.tar.bz2 && rm -f usql.tar.bz2 LICENSE && \
	mv usql /usr/local/bin/usql && chmod +x /usr/local/bin/usql

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
RUN dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
    dnf -y install vault && dnf clean all && rm -rf /var/cache/dnf

# SAML-to-AWS (saml2aws) - https://github.com/Versent/saml2aws
# AWS SSO is becoming mainstream (and replacing SAML2AWS)
#RUN SAML2AWS_VER=$(curl -Ls https://api.github.com/repos/Versent/saml2aws/releases/latest | grep 'tag_name' | cut -d'v' -f2 | cut -d'"' -f1) && \
#	curl -Ls \
#	https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VER}/saml2aws_${SAML2AWS_VER}_linux_amd64.tar.gz -o saml2aws.tar.gz && \
#	tar zxf saml2aws.tar.gz && rm -f saml2aws.tar.gz README.md LICENSE.md && \
#	mv -f saml2aws /usr/local/bin/ && \
#	chmod +x /usr/local/bin/saml2aws

# Copy configuration in the user home, for the root user
ADD bashrc $HOMEADM/.bashrc

# Create an ubuntu user
RUN useradd ubuntu && \
	echo "ubuntu  ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
	chmod 0440 /etc/sudoers.d/ubuntu && \
    mkdir -p $HOME/.local/bin
ADD bashrc $HOME/.bashrc
RUN chown -R ubuntu:ubuntu $HOME

# Create a /databricks/python3 directory and set environment and permissions
# This is what is used by DataBricks
RUN mkdir -p /databricks/python3 && chown -R ubuntu:ubuntu /databricks

# Default non-root user
USER ubuntu
WORKDIR $HOME

# uv - See https://docs.astral.sh/uv/guides/integration/docker/#installing-uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx $HOME/.local/bin/

