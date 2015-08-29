FROM php:5.6-apache

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-server-dev-9.4 \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        rsync \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install mbstring pgsql mysqli \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN mkdir -p \
    /var/www/dotclear/public \
    /var/www/dotclear/plugins \
    /var/www/dotclear/themes

ENV DOTCLEAR_VERSION 2.8

RUN rm /var/www/html/*; \
    curl -SL http://download.dotclear.org/latest/dotclear-${DOTCLEAR_VERSION}.tar.gz \
    | tar -xazC /var/www/html --strip-components=2 \
    && mv /var/www/html/themes /var/www/html/themes_ori \
    && mv /var/www/html/plugins /var/www/html/plugins_ori \
    && rm -r /var/www/html/public \
    && ln -s /var/www/dotclear/public /var/www/html/public \
    && ln -s /var/www/dotclear/plugins /var/www/html/plugins \
    && ln -s /var/www/dotclear/themes /var/www/html/themes

RUN sed -i 's|dirname(__FILE__)|"/var/www/html/inc/"|g' /var/www/html/inc/config.php.in \
    && ln -s /var/www/dotclear/config.php /var/www/html/inc/config.php

RUN chown -R www-data:www-data /var/www/html /var/www/dotclear \
    && chmod 775  /var/www/html/cache /var/www/dotclear/public

VOLUME /var/www/dotclear

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
