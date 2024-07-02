FROM php:8.2-fpm-alpine

WORKDIR /var/www/app

RUN apk update && apk add \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo pdo_mysql \
    && apk --no-cache add nodejs npm

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install required packages using apk
RUN apk update && apk add --no-cache \
    autoconf \
    build-base \
    linux-headers \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Clean up to reduce image size
RUN rm -rf /var/cache/apk/*
COPY ./xdebug/xdebug.ini "${PHP_INI_DIR}/conf.d"

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

USER root

RUN chmod 777 -R /var/www/app