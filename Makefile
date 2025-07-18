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

# Scala versions (built with SBT)
SBT_VERSION_PATHS := $(wildcard matrix/sbt/*)
SBT_VERSIONS := $(patsubst matrix/sbt/%,%,$(SBT_VERSION_PATHS))
BUILD_JDK8_SBT_IMGS := $(patsubst %,build-img-jdk8-sbt-%,$(SBT_VERSIONS))
PULL_JDK8_SBT_IMGS := $(patsubst %,pull-img-jdk8-sbt-%,$(SBT_VERSIONS))
RUN_JDK8_SBT_IMGS := $(patsubst %,run-img-jdk8-sbt-%,$(SBT_VERSIONS))
PUSH_JDK8_SBT_IMGS := $(patsubst %,push-img-jdk8-sbt-%,$(SBT_VERSIONS))
BUILD_PUSH_JDK8_SBT_IMGS := $(patsubst %,build-push-img-jdk8-sbt-%,$(SBT_VERSIONS))

# Python versions for JDK 8
PY_VERSION_PATHS := $(wildcard matrix/python/*)
PY_VERSIONS := $(patsubst matrix/python/%,%,$(PY_VERSION_PATHS))
BUILD_JDK8_PY_IMGS := $(patsubst %,build-img-jdk8-py-%,$(PY_VERSIONS))
PULL_JDK8_PY_IMGS := $(patsubst %,pull-img-jdk8-py-%,$(PY_VERSIONS))
RUN_JDK8_PY_IMGS := $(patsubst %,run-img-jdk8-py-%,$(PY_VERSIONS))
PUSH_JDK8_PY_IMGS := $(patsubst %,push-img-jdk8-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK8_PY_IMGS := $(patsubst %,build-push-img-jdk8-py-%,$(PY_VERSIONS))

# Python versions for JDK 11
BUILD_JDK11_PY_IMGS := $(patsubst %,build-img-jdk11-py-%,$(PY_VERSIONS))
PULL_JDK11_PY_IMGS := $(patsubst %,pull-img-jdk11-py-%,$(PY_VERSIONS))
RUN_JDK11_PY_IMGS := $(patsubst %,run-img-jdk11-py-%,$(PY_VERSIONS))
PUSH_JDK11_PY_IMGS := $(patsubst %,push-img-jdk11-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK11_PY_IMGS := $(patsubst %,build-push-img-jdk11-py-%,$(PY_VERSIONS))

# Python versions for JDK 17
BUILD_JDK17_PY_IMGS := $(patsubst %,build-img-jdk17-py-%,$(PY_VERSIONS))
PULL_JDK17_PY_IMGS := $(patsubst %,pull-img-jdk17-py-%,$(PY_VERSIONS))
RUN_JDK17_PY_IMGS := $(patsubst %,run-img-jdk17-py-%,$(PY_VERSIONS))
PUSH_JDK17_PY_IMGS := $(patsubst %,push-img-jdk17-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK17_PY_IMGS := $(patsubst %,build-push-img-jdk17-py-%,$(PY_VERSIONS))

# Python versions for JDK 21
BUILD_JDK21_PY_IMGS := $(patsubst %,build-img-jdk21-py-%,$(PY_VERSIONS))
PULL_JDK21_PY_IMGS := $(patsubst %,pull-img-jdk21-py-%,$(PY_VERSIONS))
RUN_JDK21_PY_IMGS := $(patsubst %,run-img-jdk21-py-%,$(PY_VERSIONS))
PUSH_JDK21_PY_IMGS := $(patsubst %,push-img-jdk21-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK21_PY_IMGS := $(patsubst %,build-push-img-jdk21-py-%,$(PY_VERSIONS))

# Python versions for JDK 23
BUILD_JDK23_PY_IMGS := $(patsubst %,build-img-jdk23-py-%,$(PY_VERSIONS))
PULL_JDK23_PY_IMGS := $(patsubst %,pull-img-jdk23-py-%,$(PY_VERSIONS))
RUN_JDK23_PY_IMGS := $(patsubst %,run-img-jdk23-py-%,$(PY_VERSIONS))
PUSH_JDK23_PY_IMGS := $(patsubst %,push-img-jdk23-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK23_PY_IMGS := $(patsubst %,build-push-img-jdk23-py-%,$(PY_VERSIONS))

# Python versions for JDK 24
BUILD_JDK24_PY_IMGS := $(patsubst %,build-img-jdk24-py-%,$(PY_VERSIONS))
PULL_JDK24_PY_IMGS := $(patsubst %,pull-img-jdk24-py-%,$(PY_VERSIONS))
RUN_JDK24_PY_IMGS := $(patsubst %,run-img-jdk24-py-%,$(PY_VERSIONS))
PUSH_JDK24_PY_IMGS := $(patsubst %,push-img-jdk24-py-%,$(PY_VERSIONS))
BUILD_PUSH_JDK24_PY_IMGS := $(patsubst %,build-push-img-jdk24-py-%,$(PY_VERSIONS))

#
.PHONY: help \
	$(BUILD_BASE_IMGS) $(PULL_BASE_IMGS) $(RUN_BASE_IMGS) $(PUSH_BASE_IMGS) $(BUILD_PUSH_BASE_IMGS) \
	$(BUILD_JDK8_SBT_IMGS) $(PULL_JDK8_SBT_IMGS) $(RUN_JDK8_SBT_IMGS) $(PUSH_JDK8_SBT_IMGS) $(BUILD_PUSH_JDK8_SBT_IMGS) \
	$(BUILD_JDK8_PY_IMGS) $(PULL_JDK8_PY_IMGS) $(RUN_JDK8_PY_IMGS) $(PUSH_JDK8_PY_IMGS) $(BUILD_PUSH_JDK8_PY_IMGS) \
	$(BUILD_JDK11_PY_IMGS) $(PULL_JDK11_PY_IMGS) $(RUN_JDK11_PY_IMGS) $(PUSH_JDK11_PY_IMGS) $(BUILD_PUSH_JDK11_PY_IMGS) \
	$(BUILD_JDK17_PY_IMGS) $(PULL_JDK17_PY_IMGS) $(RUN_JDK17_PY_IMGS) $(PUSH_JDK17_PY_IMGS) $(BUILD_PUSH_JDK17_PY_IMGS) \
	$(BUILD_JDK21_PY_IMGS) $(PULL_JDK21_PY_IMGS) $(RUN_JDK21_PY_IMGS) $(PUSH_JDK21_PY_IMGS) $(BUILD_PUSH_JDK21_PY_IMGS) \
	$(BUILD_JDK23_PY_IMGS) $(PULL_JDK23_PY_IMGS) $(RUN_JDK23_PY_IMGS) $(PUSH_JDK23_PY_IMGS) $(BUILD_PUSH_JDK23_PY_IMGS) \
	$(BUILD_JDK24_PY_IMGS) $(PULL_JDK24_PY_IMGS) $(RUN_JDK24_PY_IMGS) $(PUSH_JDK24_PY_IMGS) $(BUILD_PUSH_JDK24_PY_IMGS)

help: ## Display the help menu.
	@grep -h "\#\#" $(MAKEFILE_LIST)

# Base images
$(BUILD_BASE_IMGS): build-img-base-%: ## Build the base container image
	@jdk_version="$*" && \
	$(eval JDK_TYPE := $(shell if [[ "$*" = "23" || "$*" = "24" ]]; then echo "new"; else echo "leg"; fi)) \
	echo "jdk_version=$${jdk_version} - JDK_TYPE=$(JDK_TYPE)" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version} \
		-t $(DCK_REPO):latest \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg JDK_TYPE="$(JDK_TYPE)" \
		corretto-emr-dbs-universal-base/

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
	docker push $(DCK_REPO):jdk$${jdk_version} && \
	docker push $(DCK_REPO):latest

$(BUILD_PUSH_BASE_IMGS): build-push-img-base-%: build-img-base-% push-img-base-% ## Build and push the base container image

# Scala images for JDK8
$(BUILD_JDK8_SBT_IMGS): build-img-jdk8-sbt-%: ## Build the Python container image
	@sbt_version="$*" && jdk_version="8" && \
	echo "sbt_version=$${sbt_version} - jdk_version=$${jdk_version}" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version}-sbt$${sbt_version} \
		-t $(DCK_REPO):jdk$${jdk_version}-sbt \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg SBT_VERSION=$${sbt_version} \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK8_SBT_IMGS): pull-img-jdk8-sbt-%: ## Pull the Python container image
	@sbt_version="$*" && jdk_version="8" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-sbt$${sbt_version}

$(RUN_JDK8_SBT_IMGS): run-img-jdk8-sbt-%: ## Run the Python container image
	@sbt_version="$*" && jdk_version="8" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-sbt$${sbt_version} bash

$(PUSH_JDK8_SBT_IMGS): push-img-jdk8-sbt-%: ## Publish the Python container image
	@sbt_version="$*" && jdk_version="8" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-sbt$${sbt_version} && \
	docker push $(DCK_REPO):jdk$${jdk_version}-sbt

$(BUILD_PUSH_JDK8_SBT_IMGS): build-push-img-jdk8-sbt-%: build-img-jdk8-sbt-% push-img-jdk8-sbt-% ## Build and push the Python container image

# Python images for JDK8
$(BUILD_JDK8_PY_IMGS): build-img-jdk8-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="8" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		-t $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) \
		-t $(DCK_REPO):jdk$${jdk_version}-python \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK8_PY_IMGS): pull-img-jdk8-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="8" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(RUN_JDK8_PY_IMGS): run-img-jdk8-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="8" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK8_PY_IMGS): push-img-jdk8-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="8" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version} && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python

$(BUILD_PUSH_JDK8_PY_IMGS): build-push-img-jdk8-py-%: build-img-jdk8-py-% push-img-jdk8-py-% ## Build and push the Python container image

# Python images for JDK11
$(BUILD_JDK11_PY_IMGS): build-img-jdk11-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="11" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		-t $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) \
		-t $(DCK_REPO):jdk$${jdk_version}-python \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK11_PY_IMGS): pull-img-jdk11-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="11" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(RUN_JDK11_PY_IMGS): run-img-jdk11-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="11" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK11_PY_IMGS): push-img-jdk11-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="11" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version} && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python

$(BUILD_PUSH_JDK11_PY_IMGS): build-push-img-jdk11-py-%: build-img-jdk11-py-% push-img-jdk11-py-% ## Build and push the Python container image

# Python images for JDK17
$(BUILD_JDK17_PY_IMGS): build-img-jdk17-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="17" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		-t $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) \
		-t $(DCK_REPO):jdk$${jdk_version}-python \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK17_PY_IMGS): pull-img-jdk17-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="17" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(RUN_JDK17_PY_IMGS): run-img-jdk17-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="17" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK17_PY_IMGS): push-img-jdk17-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="17" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version} && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python

$(BUILD_PUSH_JDK17_PY_IMGS): build-push-img-jdk17-py-%: build-img-jdk17-py-% push-img-jdk17-py-% ## Build and push the Python container image

# Python images for JDK21
$(BUILD_JDK21_PY_IMGS): build-img-jdk21-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="21" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		-t $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) \
		-t $(DCK_REPO):jdk$${jdk_version}-python \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK21_PY_IMGS): pull-img-jdk21-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="21" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(RUN_JDK21_PY_IMGS): run-img-jdk21-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="21" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK21_PY_IMGS): push-img-jdk21-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="21" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version} && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python

$(BUILD_PUSH_JDK21_PY_IMGS): build-push-img-jdk21-py-%: build-img-jdk21-py-% push-img-jdk21-py-% ## Build and push the Python container image

# Python images for JDK23
$(BUILD_JDK23_PY_IMGS): build-img-jdk23-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="23" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		-t $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) \
		-t $(DCK_REPO):jdk$${jdk_version}-python \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK23_PY_IMGS): pull-img-jdk23-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="23" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(RUN_JDK23_PY_IMGS): run-img-jdk23-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="23" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK23_PY_IMGS): push-img-jdk23-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="23" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version} && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python

$(BUILD_PUSH_JDK23_PY_IMGS): build-push-img-jdk23-py-%: build-img-jdk23-py-% push-img-jdk23-py-% ## Build and push the Python container image

# Python images for JDK24
$(BUILD_JDK24_PY_IMGS): build-img-jdk24-py-%: ## Build the Python container image
	@py_version="$*" && jdk_version="24" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker build \
		-t $(DCK_REPO):jdk$${jdk_version}-python$${py_version} \
		-t $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) \
		-t $(DCK_REPO):jdk$${jdk_version}-python \
		--build-arg JDK_VERSION=$${jdk_version} \
		--build-arg PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION} \
		--build-arg PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION) \
		corretto-emr-dbs-universal-pyspark/

$(PULL_JDK24_PY_IMGS): pull-img-jdk24-py-%: ## Pull the Python container image
	@py_version="$*" && jdk_version="24" && \
	docker pull $(DCK_REPO):jdk$${jdk_version}-python$${py_version}

$(RUN_JDK24_PY_IMGS): run-img-jdk24-py-%: ## Run the Python container image
	@py_version="$*" && jdk_version="24" && \
	docker run --rm -it $(DCK_REPO):jdk$${jdk_version}-python$${py_version} bash

$(PUSH_JDK24_PY_IMGS): push-img-jdk24-py-%: ## Publish the Python container image
	@py_version="$*" && jdk_version="24" && \
	PYTHON_MICRO_VERSION="$${py_version}" && \
	$(eval PYTHON_MINOR_VERSION := $(shell echo "$*" | cut -d. -f1-2)) \
	echo "py_version=$${py_version} - jdk_version=$${jdk_version}" && \
	echo "PYTHON_MICRO_VERSION=$${PYTHON_MICRO_VERSION}" && \
	echo "PYTHON_MINOR_VERSION=$(PYTHON_MINOR_VERSION)" && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$${py_version} && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python$(PYTHON_MINOR_VERSION) && \
	docker push $(DCK_REPO):jdk$${jdk_version}-python

$(BUILD_PUSH_JDK24_PY_IMGS): build-push-img-jdk24-py-%: build-img-jdk24-py-% push-img-jdk24-py-% ## Build and push the Python container image

