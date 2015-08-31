#!/bin/bash

set -e

rsync -a /var/www/html/themes_ori/ /var/www/html/themes/
rsync -a /var/www/html/plugins_ori/ /var/www/html/plugins/

# fix permissions
chown -R www-data:www-data /var/www/dotclear
[ -e /var/www/dotclear/config.php ] && chmod 600 /var/www/dotclear/config.php

exec "$@"
