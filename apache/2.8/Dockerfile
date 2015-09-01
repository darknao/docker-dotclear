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

RUN a2enmod rewrite

#RUN mkdir -p \
#    /var/www/dotclear/public \
#    /var/www/dotclear/plugins \
#    /var/www/dotclear/themes

ENV DOTCLEAR_VERSION 2.8
ENV DOTCLEAR_DOWNLOAD_URL http://download.dotclear.org/latest/dotclear-${DOTCLEAR_VERSION}.tar.gz
ENV DOTCLEAR_DOWNLOAD_MD5 06b0d2c3b631083a243ddf8dc77da1ea

RUN mkdir -p /usr/src/dotclear \
    && curl -fsSL -o dotclear.tar.gz "$DOTCLEAR_DOWNLOAD_URL" \
    && echo "$DOTCLEAR_DOWNLOAD_MD5 dotclear.tar.gz" | md5sum -c - \
    && tar -xzf dotclear.tar.gz -C /usr/src/dotclear --strip-components=2 \
    && rm dotclear.tar.gz \
    && chown -R www-data:www-data /usr/src/dotclear \
    && chmod -R 755 /usr/src/dotclear/public /usr/src/dotclear/cache \
    && rm -f /var/www/html/*

#RUN sed -i 's|dirname(__FILE__)|"/var/www/html/inc/"|g' /var/www/html/inc/config.php.in \
#    && ln -s /var/www/dotclear/config.php /var/www/html/inc/config.php \
#    && touch /var/www/dotclear/.htaccess \
#    && chmod 400 /var/www/dotclear/.htaccess \
#    && ln -s /var/www/dotclear/.htaccess /var/www/html/.htaccess

#RUN chown -R www-data:www-data /var/www/html /var/www/dotclear \
#    && chmod 775  /var/www/html/cache /var/www/dotclear/public

VOLUME /var/www/html

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
