FROM php:5.6-apache

RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-server-dev-9.4 \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        rsync

RUN docker-php-ext-install mbstring pgsql mysqli \
    && docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN rm /var/www/html/index.html
ADD dotclear-2.8.tar.gz /tmp/

RUN mkdir -p \
    /var/www/dotclear/public \
    /var/www/dotclear/plugins \
    /var/www/dotclear/themes

RUN mv /tmp/dotclear/* /var/www/html/
RUN mv /var/www/html/themes /var/www/html/themes_ori \
    && mv /var/www/html/plugins /var/www/html/plugins_ori \
    && rm -r /var/www/html/public
RUN ln -s /var/www/dotclear/public /var/www/html/public \
    && ln -s /var/www/dotclear/plugins /var/www/html/plugins \
    && ln -s /var/www/dotclear/themes /var/www/html/themes
RUN rm -rf /tmp/dotclear

RUN sed -i 's|dirname(__FILE__)|"/var/www/html/inc/"|g' /var/www/html/inc/config.php.in
RUN ln -s /var/www/dotclear/config.php /var/www/html/inc/config.php

RUN chown -R www-data:www-data /var/www/html /var/www/dotclear
RUN chmod 775  /var/www/html/cache /var/www/dotclear/public


ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
