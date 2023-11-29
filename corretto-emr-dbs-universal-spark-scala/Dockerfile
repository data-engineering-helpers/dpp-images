#
# Source: https://github.com/data-engineering-helpers/dpp-images/tree/main/corretto-emr-dbs-universal-spark-scala/Dockerfile
# On Docker Hub: https://hub.docker.com/repository/docker/infrahelpers/dpp/general
# Usual Docker tags:
# * infrahelpers/dpp:jdk8-sbt{SBT_VERSION}
#
# Image containing python installation, to be accessed by EMR and Databricks (for Spark Scala)
# See https://github.com/data-engineering-helpers/dpp-images/tree/main/coretto-emr-dbs-universal-base/Dockerfile
# for more details about the base image (tag: infrahelpers/dpp:jdk{JDK_VERSION})
#
FROM infrahelpers/dpp:jdk8

ARG SBT_VERSION

LABEL authors="Antoine Chenon<antoine.chenon@decathlon.com>, Denis Arnaud <denis.arnaud_fedora@m4x.org>"

# Update the OS
RUN yum -y update && yum clean all && rm -rf /var/cache/yum

# Install sbt
RUN rm -f /etc/yum.repos.d/bintray-rpm.repo && \
	curl -kLs https://www.scala-sbt.org/sbt-rpm.repo -o /etc/yum.repos.d/sbt-rpm.repo && \
	yum -y install sbt-${SBT_VERSION}-0 && \
	sbt -version

