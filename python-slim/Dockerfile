#
# File: https://github.com/data-engineering-helpers/dpp-images/blob/main/python-slim/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Usual Docker tags:
# * infrahelpers/dpp:python${PYTHON_MINOR_VERSION}-slim-${DEBIAN_RELEASE}
#
# Docker Scout:
# * https://scout.docker.com/reports/org/infrahelpers/images/host/hub.docker.com/repo/infrahelpers%2Fdpp
#
# Image containing Python installation, typically to be used from Kubernetes (k8s) pods.
# See https://github.com/data-engineering-helpers/dpp-images/tree/main/python-slim/Dockerfile
#
# Base image: Debian-based slim Python
# * Docker Hub:
#   * General: https://hub.docker.com/_/python
#   * Python 3.11 Trixie: https://hub.docker.com/layers/library/python/3.11-slim-trixie
# * Dockerfile:
#  * General: https://github.com/docker-library/python
#  * Python 3.11 Trixie: https://github.com/docker-library/python/blob/master/3.11/slim-trixie/Dockerfile
#
# Debian releases: https://www.debian.org/releases/
#
ARG DEBIAN_RELEASE="trixie"
ARG PYTHON_MINOR_VERSION="3.11"
FROM python:${PYTHON_MINOR_VERSION}-slim-${DEBIAN_RELEASE}

LABEL authors="Denis Arnaud <denis.arnaud_fedora@m4x.org>, Gauthier Capouillez <gauthier.capouillez@decathlon.com>"

# https://docs.docker.com/reference/dockerfile/#understand-how-arg-and-from-interact
ARG DEBIAN_RELEASE
ARG PYTHON_MINOR_VERSION
ARG PYTHON_MICRO_VERSION="3.11.13"
ARG PYTHON_INSTALL_DIR="/usr/local"
ARG GROUP_NAME="ubuntu"
ARG USER_NAME="ubuntu"
ARG USER_SHELL="/bin/bash"
ARG USER_ID="1000"

# Environment
ENV container="docker"
ENV HOMEADM="/root"
ENV GROUP_NAME="${GROUP_NAME}"
ENV USER_NAME="${USER_NAME}"
ENV USER_SHELL="${USER_SHELL}"
ENV USER_ID="${USER_ID}"
ENV HOME="/home/${USER_NAME}"
ENV PYTHON_MINOR_VERSION=${PYTHON_MINOR_VERSION}
ENV PYTHON_MICRO_VERSION=${PYTHON_MICRO_VERSION}
ENV LANGUAGE="en_US:en"
ENV LANG="en_US.UTF-8"
ENV LC_ALL="$LANG"

# Update the system
RUN echo "Europe/Paris" > /etc/timezone
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90-yes
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends \
        apt-transport-https ca-certificates locales tzdata \
	gpg libcap2-bin \
        zip unzip gzip bzip2 xz-utils tar p7zip-full \
        curl wget netcat-traditional net-tools bind9-host \
	procps less htop gawk bash-completion vim-nox emacs-nox keyutils \
	checkinstall lsb-release patch pkg-config jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Generate the locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    printf '%s\n' LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE > /etc/default/locale && \
    locale-gen $LANG && \
    update-locale LANG=$LANG LANGUAGE=$LANGUAGE LC_ALL=$LC_ALL

# Configure the time-zone
RUN dpkg-reconfigure -f noninteractive tzdata

# Keep upgrade to fix CVE-2025-6141 (ncurses) and CVE-2025-7709 (libsqlite3-0) vulnerabilities.
# Note: The patched version of ncurses-bin may not be available in the repository yet.
RUN echo "deb http://security.debian.org/debian-security trixie-security main" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get upgrade -y --no-install-recommends -t trixie-security && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# yq, the YAML CLI utility like jq, for YAML (https://github.com/mikefarah/yq)
RUN YQ_VER=$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
        architecture=$(uname -m|sed 's/x86_/amd/'|sed 's/aarch/arm/') && \
        echo "YQ_VER=${YQ_VER} - architecture=${architecture}" && \
        curl -Ls \
            https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_${architecture} -o /usr/local/bin/yq && \
        chmod +x /usr/local/bin/yq && yq --version

# usql, the universal CLI tool for databases (https://github.com/xo/usql)
RUN USQL_VER=$(curl -Ls https://api.github.com/repos/xo/usql/releases/latest | grep 'tag_name' | cut -d'v' -f2,2 | cut -d'"' -f1,1) && \
        architecture=$(uname -m|sed 's/x86_/amd/'|sed 's/aarch/arm/') && \
        echo "USQL_VER=${USQL_VER} - architecture=${architecture}" && \
        curl -Ls \
        https://github.com/xo/usql/releases/download/v${USQL_VER}/usql-${USQL_VER}-linux-${architecture}.tar.bz2 -o usql.tar.bz2 && \
        tar jxf usql.tar.bz2 && rm -f usql.tar.bz2 LICENSE && \
        mv usql /usr/local/bin/usql && chmod +x /usr/local/bin/usql && usql --version

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
        unzip -q awscliv2.zip && rm -f awscliv2.zip && \
	./aws/install && aws --version && rm -rf ./aws

# HashiCorp Vault (https://developer.hashicorp.com/vault/install)
# See also the setcap issue in Docker: https://github.com/hashicorp/vault/issues/10924
RUN deb_release="$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)" && \
    architecture="$(dpkg --print-architecture)" && \
    echo "deb_release=${deb_release} - architecture=${architecture}" && \
    wget -O - https://apt.releases.hashicorp.com/gpg | \
    	 gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=${architecture} signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${deb_release} main" | \
    	 tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get -qq update && apt-get -y install vault && \
    chmod +x /usr/bin/vault && setcap -r /usr/bin/vault && vault --version && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create the $USER user (as Kubernetes requires non-root user)
RUN addgroup --system ${GROUP_NAME} && \
    adduser --disabled-password --gecos "" \
    	    --shell ${USER_SHELL} \
    	    --uid ${USER_ID} --ingroup ${GROUP_NAME} \
    	    ${USER_NAME}

# Set up the packaging environment for the `build` user
ADD resources/bashrc $HOME/.bashrc
ADD resources/vimrc $HOME/.vimrc
RUN chmod 640 $HOME/.bashrc $HOME/.vimrc && \
    chown -R ${USER_NAME}.${GROUP_NAME} $HOME

# Default non-root user
USER ${USER_NAME}

# Initialize pip
WORKDIR $HOME
RUN python -V && python -mpip install -U pip
    # && python -mpip install -U aiohttp setuptools

# Some reporting
RUN cat /etc/os-release && \
    python -mpip debug && \
    bash --version && \
    jq --version && \
    yq --version && \
    aws --version && \
    vault --version

