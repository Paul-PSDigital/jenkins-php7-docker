FROM php:7-fpm

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install opcache
RUN docker-php-ext-install sockets
RUN docker-php-ext-install zip

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
	ant \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN adduser --quiet jenkins

USER jenkins

ADD slave.jar /home/jenkins/slave.jar

USER root
