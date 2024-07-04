ARG PHP_VERSION=8.1
ARG ALPINE_VERSION=3.19

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

ARG XDEBUG_VERSION=3.3.1
ARG COMPOSER_VERSION=2.7.2

ENV USER=vscode

RUN apk add icu-dev
RUN docker-php-ext-install pdo_mysql intl

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions gd bcmath soap xsl zip sockets

RUN apk --no-cache add autoconf g++ linux-headers make
RUN pecl install xdebug-${XDEBUG_VERSION}
RUN docker-php-ext-enable xdebug

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename-composer --version-${COMPOSER_VERSION}

RUN adduser -D $USER
USER 1000