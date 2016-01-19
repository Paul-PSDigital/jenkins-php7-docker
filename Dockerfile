FROM php:7-fpm

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ADD php.ini /usr/local/etc/php/php.ini

RUN apt-get update && apt-get install -y libpq-dev
RUN apt-get -y upgrade

RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install opcache
RUN docker-php-ext-install sockets
RUN docker-php-ext-install zip

# Redis/php7 is not exactly out yet, so not on dist - inject into it then install
RUN apt-get install -y unzip \
    && curl -sS https://codeload.github.com/phpredis/phpredis/zip/php7 -o /tmp/phpredis.zip \
    && cd /tmp \
    && unzip phpredis.zip \
    && mv /tmp/phpredis-php7 /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && apt-get autoremove -y unzip \
    && rm /tmp/phpredis.zip

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
	-qqy \
    	apt-transport-https \
    	ca-certificates \
    	curl \
    	lxc \
    	iptables \
    	&& rm -rf /var/lib/apt/lists/*

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN adduser --quiet jenkins

USER jenkins

ADD slave.jar /home/jenkins/slave.jar

USER root
