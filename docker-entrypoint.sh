#!/bin/bash

set -e

rsync -a /var/www/html/themes_ori/ /var/www/html/themes/
rsync -a /var/www/html/plugins_ori/ /var/www/html/plugins/

exec "$@"
