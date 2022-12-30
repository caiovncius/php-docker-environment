ARG PHP_VERSION=7.4
FROM php:$PHP_VERSION-fpm-alpine

ENV PHPIZE_DEPS \
    autoconf \
    dpkg-dev dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    re2c \
    zip \
    libzip-dev \
    libmcrypt-dev \
    curl \
    libxml2-dev \
    icu \
    zlib-dev \
    icu-dev \
    freetype \
    libjpeg-turbo \
    libpng \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev

ENV PHP_DEPENDENCIES \
    zip intl mysqli pdo pdo_mysql json soap bcmath calendar ctype \
    dom session opcache simplexml bcmath gd xml xmlrpc

RUN apk add --no-cache $PHPIZE_DEPS

RUN docker-php-ext-configure intl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    	&& docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install -j$(nproc) $PHP_DEPENDENCIES

RUN pecl install mcrypt-1.0.3
RUN docker-php-ext-enable mcrypt

RUN pecl install redis-5.1.1 \
	&& pecl install xdebug-3.0.0 \
	&& docker-php-ext-enable redis xdebug

RUN apk del --no-cache \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    && rm -rf /tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl https://moodle.org/plugins/download.php/27462/moosh_moodle40_2022083100.zip -o /tmp/moosh.zip
RUN unzip /tmp/moosh.zip -d /usr/share
RUN ln -s /usr/share/moosh/moosh.php /usr/local/bin/moosh

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /tmp/wp-cli.phar
RUN chmod +x /tmp/wp-cli.phar
RUN mv /tmp/wp-cli.phar /usr/local/bin/wp
