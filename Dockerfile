FROM php:8.2-fpm-alpine

WORKDIR /var/www/app

RUN apk update && apk add --no-cache \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    autoconf \
    build-base \
    linux-headers \
    nodejs \
    npm \
    imagemagick-dev

RUN docker-php-ext-install pdo pdo_mysql gd xml

RUN pecl install xdebug redis imagick \
    && docker-php-ext-enable xdebug redis imagick

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN rm -rf /var/cache/apk/*

COPY ./xdebug/xdebug.ini "${PHP_INI_DIR}/conf.d"

RUN chmod 777 -R /var/www/app