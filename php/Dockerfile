ARG PHP_VERSION=""
FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

ARG LIMESURVEY_ADMIN_USER_NAME=admin
ARG LIMESURVEY_ADMIN_USER_PASSWORD=password
ARG LIMESURVEY_ADMIN_FULL_NAME="admin"
ARG LIMESURVEY_ADMIN_EMAIL=""

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


# install limesurvey config via console.php
# RUN php /var/www/html/application/commands/console.php install ${LIMESURVEY_ADMIN_USER_NAME} ${LIMESURVEY_ADMIN_USER_PASSWORD} ${LIMESURVEY_ADMIN_FULL_NAME} ${LIMESURVEY_ADMIN_EMAIL}

# clean up
# RUN apk del --no-cache freetype libjpeg-turbo libpng freetype-dev libjpeg-turbo-dev libpng-dev
# RUN apk del --no-cache ldb-dev libldap openldap-dev
# RUN apk del --no-cache zlib-dev libpng-dev libzip-dev imap-dev
RUN rm -rf /tmp/*

