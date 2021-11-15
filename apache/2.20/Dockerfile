FROM php:7-apache

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-server-dev-all \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	libonig-dev \
        rsync \
	unzip \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install mbstring pgsql mysqli \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install gd

RUN a2enmod rewrite

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

VOLUME /var/www/html
EXPOSE 80

ENV DOTCLEAR_VERSION 2.20
ENV DOTCLEAR_DOWNLOAD_URL http://download.dotclear.org/latest/dotclear-${DOTCLEAR_VERSION}.zip
ENV DOTCLEAR_DOWNLOAD_MD5 7ae6c57fe7913d11e9eef11d840a0b1e

RUN mkdir -p /usr/src/dotclear \
    && curl -fsSL -o dotclear.zip "$DOTCLEAR_DOWNLOAD_URL" \
    && echo "$DOTCLEAR_DOWNLOAD_MD5 dotclear.zip" | md5sum -c - \
    && unzip -d /usr/src dotclear.zip \
    && rm dotclear.zip \
    && chown -R www-data:www-data /usr/src/dotclear \
    && chmod -R 755 /usr/src/dotclear/public /usr/src/dotclear/cache \
    && rm -f /var/www/html/*


ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
