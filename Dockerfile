# Dockerfile
FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    nano git zip unzip curl libicu-dev libonig-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

COPY ./apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

WORKDIR /var/www/html
