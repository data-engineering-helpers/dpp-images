#
# File: https://github.com/data-engineering-helpers/dpp-images/blob/main/Makefile
# 

# Docker Hub organization
DCK_ORG := infrahelpers
DCK_PRJ := dpp
DCK_REPO := $(DCK_ORG)/$(DCK_PRJ)

# Today's date
TODAY_DATE := $(shell date '+%Y%m%d')
EXTRACT_DATE := $(TODAY_DATE)

# JDK versions
JDK_VERSION_PATHS := $(wildcard matrix/jdk/*)
JDK_VERSIONS := $(patsubst matrix/jdk/%,%,$(JDK_VERSION_PATHS))
BUILD_BASE_IMGS := $(patsubst %,build-img-base-%,$(JDK_VERSIONS))
PULL_BASE_IMGS := $(patsubst %,pull-img-base-%,$(JDK_VERSIONS))
RUN_BASE_IMGS := $(patsubst %,run-img-base-%,$(JDK_VERSIONS))
PUSH_BASE_IMGS := $(patsubst %,push-img-base-%,$(JDK_VERSIONS))
BUILD_PUSH_BASE_IMGS := $(patsubst %,build-push-img-base-%,$(JDK_VERSIONS))

# Python versions
PY_VERSION_PATHS := $(wildcard matrix/python/*)
PY_VERSIONS := $(patsubst matrix/python/%,%,$(PY_VERSION_PATHS))
BUILD_JDK8_PY_IMGS := $(patsubst %,build-img-jdk8-py-%,$(PY_VERSIONS))
PULL_JDK8_PY_IMGS := $(patsubst %,pull-img-jdk8-py-%,$(PY_VERSIONS))
RUN_JDK8_PY_IMGS := $(patsubst %,run-img-jdk8-py-%,$(PY_VERSIONS))
PUSH_JDK8_PY_IMGS := $(patsubst %,push-img-jdk8-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK8_PY_IMGS := $(patsubst %,build-push-img-jdk8-py-%,$(PY_VERSIONS))
BUILD_JDK11_PY_IMGS := $(patsubst %,build-img-jdk11-py-%,$(PY_VERSIONS))
PULL_JDK11_PY_IMGS := $(patsubst %,pull-img-jdk11-py-%,$(PY_VERSIONS))
RUN_JDK11_PY_IMGS := $(patsubst %,run-img-jdk11-py-%,$(PY_VERSIONS))
PUSH_JDK11_PY_IMGS := $(patsubst %,push-img-jdk11-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK11_PY_IMGS := $(patsubst %,build-push-img-jdk11-py-%,$(PY_VERSIONS))

# Scala versions

.PHONY: help \
	$(BUILD_BASE_IMGS) $(PULL_BASE_IMGS) $(RUN_BASE_IMGS) $(PUSH_BASE_IMGS) $(BUILD_PUSH_BASE_IMGS) \
	$(BUILD_JDK8_PY_IMGS) $(PULL_JDK8_PY_IMGS) $(RUN_JDK8_PY_IMGS) $(PUSH_JDK8_PY_IMGS) $(BUILD_PUSH_JDK8_PY_IMGS) \
	$(BUILD_JDK11_PY_IMGS) $(PULL_JDK11_PY_IMGS) $(RUN_JDK11_PY_IMGS) $(PUSH_JDK11_PY_IMGS) $(BUILD_PUSH_JDK11_PY_IMGS)

help: ## Display the help menu.
	@grep -h "\#\#" $(MAKEFILE_LIST)

# Base images
$(BUILD_BASE_IMGS): build-img-base-%: ## Build the base container image
	@jdk_version="$*" && \
	echo "jdk_version=$${jdk_version}" && \
	docker build -t $(DCK_REPO):jdk$${jdk_version} --build-arg JDK_VERSION=$${jdk_version} corretto-emr-dbs-universal-base/

$(PULL_BASE_IMGS): pull-img-base-%: ## Pull the base container image
	@jdk_version="$*" && \
	echo "jdk_version=$${jdk_version}" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}

$(RUN_BASE_IMGS): run-img-base-%: ## Run the base container image
	@jdk_version="$*" && \
	echo "jdk_version=$${jdk_version}" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version} bash

$(PUSH_BASE_IMGS): push-img-base-%: ## Publish the base container image
	@jdk_version="$*" && \
	echo "jdk_version=$${jdk_version}" && \
	docker push $(DCK_REPO):jdk$${jdk_version}

$(BUILD_PUSH_BASE_IMGS): build-push-img-base-%: build-img-base-% push-img-base-% ## Build and push the base container image

# Python images for JDK8
$(BUILD_JDK8_PY_IMGS): build-img-jdk8-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="8" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build -t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK8_PY_IMGS): pull-img-jdk8-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="8" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-py$${py_version}

$(RUN_JDK8_PY_IMGS): run-img-jdk8-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="8" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK8_PY_IMGS): push-img-jdk8-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="8" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(BUILD_PUSH_JDK8_PY_IMGS): build-push-img-jdk8-py-%: build-img-jdk8-py-% push-img-jdk8-py-% ## Build and push the Python container image

# Python images for JDK11
$(BUILD_JDK11_PY_IMGS): build-img-jdk11-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="11" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build -t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK11_PY_IMGS): pull-img-jdk11-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="11" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-py$${py_version}

$(RUN_JDK11_PY_IMGS): run-img-jdk11-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="11" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK11_PY_IMGS): push-img-jdk11-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="11" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(BUILD_PUSH_JDK11_PY_IMGS): build-push-img-jdk11-py-%: build-img-jdk11-py-% push-img-jdk11-py-% ## Build and push the Python container image

