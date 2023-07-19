#
# Source: https://github.com/data-engineering-helpers/dpp-images/tree/main/pyspark-py310/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Usual Docker tags:
# * infrahelpers/dpp:jdk8-sbt{SBT_VERSION}
#
# Image containing python installation, to be accessed by EMR and Databricks (for spark scala)
# See https://github.com/data-engineering-helpers/dpp-images/tree/main/coretto-emr-dbs-universal-base/Dockerfile
# for more details about the base image (tag: infrahelpers/dpp:jdk{JDK_VERSION})
#
FROM infrahelpers/dpp:jdk8

ARG SBT_VERSION

LABEL authors="Antoine Chenon<antoine.chenon@decathlon.com>"

# Update the OS
RUN yum -y update && yum clean all

# Install sbt
RUN rm -f /etc/yum.repos.d/bintray-rpm.repo; curl -L https://www.scala-sbt.org/sbt-rpm.repo > sbt-rpm.repo; mv sbt-rpm.repo /etc/yum.repos.d/; yum -y install sbt-${SBT_VERSION}-0