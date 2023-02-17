FROM php:8-fpm

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

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

VOLUME /var/www/html
EXPOSE 80

ENV DOTCLEAR_VERSION 2.23.1
ENV DOTCLEAR_DOWNLOAD_URL http://download.dotclear.org/attic/dotclear-${DOTCLEAR_VERSION}.zip
ENV DOTCLEAR_DOWNLOAD_MD5 add0cf89d8545b1f09bc3c65ee9a7a8a

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
CMD ["php-fpm"]

