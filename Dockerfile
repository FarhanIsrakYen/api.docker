FROM php:8.2-fpm-alpine

WORKDIR /var/www/app

# Install system dependencies
RUN apk update && apk add \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    autoconf \
    build-base \
    linux-headers \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install and enable Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Clean up to reduce image size
RUN rm -rf /var/cache/apk/*

COPY ./xdebug/xdebug.ini "${PHP_INI_DIR}/conf.d"

# Install and enable Redis
RUN pecl install redis \
    && docker-php-ext-enable redis

# Set permissions
USER root
RUN chmod 777 -R /var/www/app
