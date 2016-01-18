FROM php:7-fpm

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install base dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends \
	openjdk-7-jdk \
        apt-transport-https \
        openssh-server \
        build-essential \
        ca-certificates \
        curl \
        git \
        libssl-dev \
        python \
        rsync \
        software-properties-common \
        wget \
	ruby-full \
	python-pip \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --quiet jenkins

USER jenkins

ADD slave.jar /home/jenkins/slave.jar

USER root
