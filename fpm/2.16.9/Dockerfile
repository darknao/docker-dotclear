FROM php:7-fpm

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-server-dev-all \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	libonig-dev \
        rsync \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install mbstring pgsql mysqli \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install gd

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

VOLUME /var/www/html
EXPOSE 80

ENV DOTCLEAR_VERSION 2.16.9
ENV DOTCLEAR_DOWNLOAD_URL http://download.dotclear.org/attic/dotclear-${DOTCLEAR_VERSION}.tar.gz
ENV DOTCLEAR_DOWNLOAD_MD5 694c2b9e89f36f0cb7527dfa2a539a2e

RUN mkdir -p /usr/src/dotclear \
    && curl -fsSL -o dotclear.tar.gz "$DOTCLEAR_DOWNLOAD_URL" \
    && echo "$DOTCLEAR_DOWNLOAD_MD5 dotclear.tar.gz" | md5sum -c - \
    && tar -xzf dotclear.tar.gz -C /usr/src/dotclear --strip-components=2 \
    && rm dotclear.tar.gz \
    && chown -R www-data:www-data /usr/src/dotclear \
    && chmod -R 755 /usr/src/dotclear/public /usr/src/dotclear/cache \
    && rm -f /var/www/html/*

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

