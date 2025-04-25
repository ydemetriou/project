#!/bin/bash

touch /var/log/php_errors.log
chown www-data:www-data /var/log/php_errors.log
chmod -R ug+rwX vendor
mkdir -p var/log
chown -R www-data:www-data var
chmod -R 775 var

# --- PHP extensions & tools ---
apt-get update && apt-get install -y \
    nano git zip unzip curl libicu-dev libonig-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# --- Composer ---
if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi

# --- Symfony CLI ---
if ! command -v symfony &> /dev/null; then
    curl -sS https://get.symfony.com/cli/installer | bash \
        && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony
fi

# --- Xdebug ---
pecl install xdebug \
    && docker-php-ext-enable xdebug

# --- Apache mods ---
a2enmod rewrite

if [ -f "composer.json" ]; then
    composer install
fi


exec "$@"