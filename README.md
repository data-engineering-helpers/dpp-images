Container images focusing on Data Processing Pipelines (DPP)
============================================================

# Table of Content (ToC)
* [Overview](#overview)
  * [See also](#see-also)
* [Simple use](#simple-use)
* [Build your own container image](#build-your-own-container-image)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc.go)

# Overview
[That project](https://github.com/data-engineering-helpers/dpp-images)
produces [OCI](https://opencontainers.org/)
[(Docker-compliant) images](https://hub.docker.com/repository/docker/infrahelpers/dpp/tags),
which provide environments for Data Processing Pipelines (DPP),
ready to use and to be deployed on Modern Data Stack (MDS),
be it on private or public clouds (_e.g._, AWS, Azure, GCP).

These images are based on
[AWS-supported Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html).
Thanks to
[GitHub Actions (CI/CD)](https://github.com/data-engineering-helpers/dpp-images/actions),
every time there are commits on this Git repository,
the OCI imaages are built and published on
[Docker Hub](https://hub.docker.com/repository/docker/infrahelpers/dpp/general).

These OCI images are aimed at deploying Data Engineering applications,
typically Data Processing Pipelines (DPP), on
[Modern Data Stack (MDS)](https://www.montecarlodata.com/blog-what-is-a-data-platform-and-how-to-build-one/).

The authors of this repository also maintain general purpose cloud
Python OCI images in a
[dedicated GitHub repository](https://github.com/cloud-helpers/cloud-python-images/)
and
[Docker Hub space](https://hub.docker.com/repository/docker/infrahelpers/cloud-python).

Thanks to
[Docker multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/),
one can easily have in a same Docker specification file two images, one for
every day data engineering work, and the other one to deploy the corresponding
applications onto production environments.

The Docker images of this repository just add various utilities to make it
work out of the box with cloud vendors (_e.g._, Azure and AWS command-line
utilities) and cloud-native tools (_e.g._, S3-Mountpoint), on top of the native
images maintained by the
[AWS-supported Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/what-is-corretto-8.html).
They also add specific Python versions.

In the OCI image, Python packages are installed by the `pip` utility.
For testing purposes, outside of the container, Python virtual environments
may be installed thanks to PyEnv and `pipenv`, as detailed in the
[dedicated procedure](http://github.com/machine-learning-helpers/induction-python/tree/master/installation/virtual-env)
on the
[Python induction notebook sub-project](http://github.com/machine-learning-helpers/induction-python).

Any additional Python module may be installed either:
* With `pip` and some `requirements.txt` dependency specification file:
```bash
$ python3 -mpip install -r requirements.txt
```
* In a dedicated virtual environment, controlled by `pipenv` through
  local `Pipfile` (and potentially `Pipfile.lock`) files,
  which should be versioned:
```bash
$ pipenv --rm; pipenv install; pipenv install --dev
```

On the other hand, the OCI images install those modules globally.

The Docker images of this repository are intended to run any Data Engineering
applications / Data Processing Pipeline (DPP).

## See also
* [Images on Docker Cloud](https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/dpp)
* Cloud Python images:
  + GitHub:
    https://github.com/cloud-helpers/cloud-python-images
  + Docker Cloud:
    https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cloud-python
* Amazon-maintained OCI images for Machine Learning (ML):
  https://github.com/aws/deep-learning-containers
* General purpose C++ and Python with Debian OCI images:
  + GitHub:
    https://github.com/cpp-projects-showcase/docker-images/tree/master/debian10
  + Docker Cloud:
    https://cloud.docker.com/u/infrahelpers/repository/docker/infrahelpers/cpppython
* General purpose light Python/Debian OCI images:
  + GitHub: https://github.com/machine-learning-helpers/docker-python-light
  + Docker Cloud:
    https://cloud.docker.com/u/infrahelpers/repository/docker/artificialintelligence/python-light
* [Native Python OCI images](https://github.com/docker-library/python):
  + [Python 3.13-rc](https://github.com/docker-library/python/tree/master/3.13-rc)
    - https://github.com/docker-library/python/tree/master/3.13-rc/bookworm
  + [Python 3.12](https://github.com/docker-library/python/tree/master/3.12)
    - https://github.com/docker-library/python/tree/master/3.12/bookworm
  + [Python 3.11](https://github.com/docker-library/python/tree/master/3.11)
    - https://github.com/docker-library/python/tree/master/3.11/bookworm
  + [Python 3.10](https://github.com/docker-library/python/tree/master/3.10)
    - https://github.com/docker-library/python/tree/master/3.10/bookworm
  + [Python 3.9](https://github.com/docker-library/python/tree/master/3.9)
    - https://github.com/docker-library/python/tree/master/3.9/bookworm
* AWS cloud:
  [GitHub - Data Engineering Helpers - Knowledge Sharing - AWS](https://github.com/data-engineering-helpers/ks-cheat-sheets/blob/main/clouds/aws/)
* Kubenertes:
  [GitHub - Data Engineering Helpers - Knowledge Sharing - Kubernetes (k8s)](https://github.com/data-engineering-helpers/ks-cheat-sheets/blob/main/frameworks/k8s/)

# Simple use
* Download the Docker images
  + JDK17:
```bash
$ docker pull infrahelpers/dpp:jdk17-python3.9
  docker pull infrahelpers/dpp:jdk17-sbt1.9.8
```
  + JDK11:
```bash
$ docker pull infrahelpers/dpp:jdk11-python3.9
  docker pull infrahelpers/dpp:jdk11-sbt1.9.8
```

* Launch a Spark application:
```bash
$ docker run -it --rm infrahelpers/dpp:jdk11-python3.9
```

# Build your own container image
* Clone the
  [Git repository](https://github.com/data-engineering-helpers/dpp):
```bash
$ mkdir -p ~/dev/infra && cd ~/dev/infra
$ git clone https://github.com/data-engineering-helpers/dpp.git
$ cd dpp
```

* Build the OCI images (here with Docker, but any other tool may be used):
  + Setup the requested versions for the various stacks:
```bash
$ export JDK_VERSION="17" # or "11" or "8"
  export PYTHON_MINOR_VERSION="3.9"
  export PYTHON_MICRO_VERSION="3.9.18"
  export SBT_VERSION="1.9.8"
```
  + Amazon Linux 2023 (AL2023) for Elastic Map Reduce (EMR) 7.x and DataBricks base image:
```bash
$ docker build -t infrahelpers/dpp:jdk$JDK_VERSION --build-arg JDK_VERSION=$JDK_VERSION corretto-emr-dbs-universal-base
```
  + Amazon Linux 2023 (AL2023) for Elastic Map Reduce (EMR) 7.x and DataBricks
    with a single Python installation, with more freedom on its version:
```bash
$ docker build -t infrahelpers/dpp:jdk$JDK_VERSION-python$PYTHON_MINOR_VERSION --build-arg JDK_VERSION=$JDK_VERSION --build-arg PYTHON_MINOR_VERSION=$PYTHON_MINOR_VERSION --build-arg PYTHON_MICRO_VERSION=$PYTHON_MICRO_VERSION corretto-emr-dbs-universal-pyspark
  docker tag infrahelpers/dpp:jdk$JDK_VERSION-python$PYTHON_MINOR_VERSION infrahelpers/dpp:jdk$JDK_VERSION-python$PYTHON_MICRO_VERSION
  docker tag infrahelpers/dpp:jdk$JDK_VERSION-python$PYTHON_MINOR_VERSION infrahelpers/dpp:jdk$JDK_VERSION-python
```
  + Amazon Linux 2023 (AL2023) for Elastic Map Reduce (EMR) 7.x and DataBricks
    with SBT and Scala, with more freedom on its version:
```bash
$ docker build -t infrahelpers/dpp:jdk$JDK_VERSION-sbt$SBT_VERSION --build-arg JDK_VERSION=$JDK_VERSION --build-arg SBT_VERSION=$SBT_VERSION corretto-emr-dbs-universal-spark-scala
  docker tag infrahelpers/dpp:jdk$JDK_VERSION-sbt$SBT_VERSION infrahelpers/dpp:jdk$JDK_VERSION-sbt
```

* In addition to what the Docker Hub builds, the CI/CD (GitHub Actions)
  pipeline also builds the `infrahelpers/dpp` images on two CPU architectures,
  namely the classical AMD64 and the newer ARM64, from the
  + [`corretto-emr-dbs-universal-base/` directory](corretto-emr-dbs-universal-base/),
  + [`corretto-emr-dbs-universal-pyspark/` directory](corretto-emr-dbs-universal-pyspark/),
  + [`corretto-emr-dbs-universal-spark-scala/` directory](corretto-emr-dbs-universal-spark-scala/),
    

* (Optional) Push the newly built images to Docker Hub.
  That step is usually not needed, as the images are automatically
  built everytime there is
  [a change on GitHub](https://github.com/data-engineering-helpers/dpp-images/commits/main))
```bash
$ docker login
  docker push infrahelpers/dpp:jdk$JDK_VERSION
  docker push infrahelpers/dpp:jdk$JDK_VERSION-python$PYTHON_MINOR_VERSION
  docker push infrahelpers/dpp:jdk$JDK_VERSION-python$PYTHON_MICRO_VERSION
  docker push infrahelpers/dpp:jdk$JDK_VERSION-python
  docker push infrahelpers/dpp:jdk$JDK_VERSION-sbt$SBT_VERSION
  docker push infrahelpers/dpp:jdk$JDK_VERSION-sbt
```

* Choose which image should be the latest, tag it and upload it to Docker Hub:
```bash
$ docker tag infrahelpers/dpp:jdk$JDK_VERSION infrahelpers/dpp:latest
$ docker push infrahelpers/dpp:latest
```

* Shutdown the Docker image
```bash
$ docker ps
CONTAINER ID IMAGE                    COMMAND                   CREATED        STATUS        PORTS                  NAMES
7b69efc9dc9a de/dpp                   "/bin/sh -c 'python …"    48 seconds ago Up 47 seconds 0.0.0.0:9000->8050/tcp vigilant_merkle
$ docker kill vigilant_merkle
vigilant_merkle
$ docker ps
CONTAINER ID IMAGE                    COMMAND                   CREATED        STATUS        PORTS                  NAMES
```

