#!/bin/bash

set -e

if ! [ -e index.php -a -e inc/prepend.php ]; then
	# Initial Installation
	echo >&2 "Dotclear not found in $(pwd) - copying now..."
	if [ "$(ls -A)" ]; then
		echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
		( set -x; ls -A; sleep 10 )
	fi
	tar cf - --one-file-system -C /usr/src/dotclear . | tar xf -
	# Install default htaccess for query_string rewriting
	if [ ! -e .htaccess ]; then
	cat > .htaccess <<-'EOF'
		<IfModule mod_rewrite.c>
		RewriteEngine On
		RewriteCond %{REQUEST_FILENAME} !-f
		RewriteCond %{REQUEST_FILENAME} !-d
		RewriteRule (.*) index.php?$1
		</IfModule>
	EOF
	chown www-data:www-data .htaccess
	fi
	echo >&2 "Complete! Dotclear has been successfully copied to $(pwd)"
else
	# Existing install, do we need an upgrade?
	DOTCLEAR_CURRENT_VERSION=$(sed -n "s/^\s*define('DC_VERSION',\s*'\(.*\)');/\1/p" inc/prepend.php)
	if [ "$DOTCLEAR_CURRENT_VERSION" != "$DOTCLEAR_VERSION" ]; then
		echo >&2 "Upgrading Dotclear from ${DOTCLEAR_CURRENT_VERSION} to ${DOTCLEAR_VERSION}"
		tar cf - --one-file-system -C /usr/src/dotclear . | tar xf -
		if [ -e inc/config.php ]; then
			# use mysqli driver instead of mysql (if used)
			sed -i "s|^\s*define('DC_DBDRIVER',\s*'mysql');|define('DC_DBDRIVER','mysqli');|" inc/config.php
		fi
		echo >&2 "Complete! Dotclear has been successfully upgraded to ${DOTCLEAR_VERSION}"
	fi
fi

# fix permissions
chown -R www-data:www-data /var/www/html
[ -e /var/www/html/config.php ] && chmod 600 /var/www/html/config.php

exec "$@"
