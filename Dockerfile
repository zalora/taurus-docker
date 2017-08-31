FROM ubuntu:16.04
LABEL maintainer="Wolfram Huesken <wolfram.huesken@zalora.com>"

RUN apt-get update \
    && apt-get install -y wget python python-dev python-pip zip bzip2 file imagemagick libxml2-dev libxslt-dev make xz-utils zlib1g-dev unzip curl python-tk git groovy \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Upgrade PIP
RUN pip install --upgrade pip

# Install AWS CLI
RUN pip install awscli && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Taurus
RUN pip install bzt && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD bzt /root/.bzt

ENV JAVA_VERSION=8 \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    JDK_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    JRE_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre" \
    MAVEN_HOME="/usr/share/maven" \
    MAVEN_CONFIG="/root/.m2"

# Install Java
RUN apt-get update \
    && apt-get -y install openjdk-$JAVA_VERSION-jdk ant maven gradle \
    && apt-get clean \
    && update-ca-certificates -f \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY m2-settings.xml $MAVEN_CONFIG/settings.xml
