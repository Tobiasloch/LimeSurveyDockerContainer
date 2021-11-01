ARG PHP_VERSION=""
FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN echo "UTC" > /etc/timezone

RUN apk update; \
    apk upgrade;

# install packages
RUN apk add --no-cache freetype-dev \
        libpng-dev \
        jpeg-dev \
        libjpeg-turbo-dev

RUN apk add --no-cache ldb-dev libldap openldap-dev
RUN apk add --no-cache zlib-dev libpng-dev libzip-dev imap-dev

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/lib/ \
        --with-png-dir=/usr/lib/ \
        --with-jpeg-dir=/usr/lib/ \
        --with-gd
        
RUN docker-php-ext-install ldap gd imap mysqli pdo pdo_mysql zip

# RUN docker-php-ext-install ldap
# RUN docker-php-ext-install imap
# RUN docker-php-ext-install gd
# RUN docker-php-ext-install mysqli
# RUN docker-php-ext-install pdo
# RUN docker-php-ext-install pdo_mysql
# RUN docker-php-ext-install zip 

# clean up
# RUN apk del --no-cache freetype libjpeg-turbo libpng freetype-dev libjpeg-turbo-dev libpng-dev
# RUN apk del --no-cache ldb-dev libldap openldap-dev
# RUN apk del --no-cache zlib-dev libpng-dev libzip-dev imap-dev
RUN rm -rf /tmp/*

