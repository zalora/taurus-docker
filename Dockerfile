FROM ubuntu:16.04
LABEL maintainer="Wolfram Huesken <wolfram.huesken@zalora.com>"

RUN apt-get update \
    && apt-get install -y wget python python-dev python-pip zip bzip2 file imagemagick libxml2-dev libxslt-dev make \
       xz-utils zlib1g-dev unzip curl python-tk git xmlstarlet apt-utils \
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

# Install Java, Maven and Gradle
RUN apt-get update \
    && apt-get -y install openjdk-$JAVA_VERSION-jdk maven gradle \
    && apt-get clean \
    && update-ca-certificates -f \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install httpie
RUN pip install httpie && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install SDK and Groovym Ant, Maven and Gradle
RUN curl -s get.sdkman.io | bash
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install groovy && sdk install ant"

# Install PHP
RUN apt-get update \
    && apt-get -y install php php-cli php-curl php-json php-guzzlehttp \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
