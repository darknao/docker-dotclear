# Supported tags and respective `Dockerfile` links #

-	[`2.8-apache`, `2.8`, `apache`, `latest` (*apache/2.8/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/apache/2.8/Dockerfile)
-	[`2.7.5-apache`, `2.7.5` (*apache/2.7.5/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/apache/2.7.5/Dockerfile)
-	[`2.8-fpm`, `fpm` (*fpm/2.8/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/fpm/2.8/Dockerfile)
-	[`2.5-fpm` (*fpm/2.5/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/fpm/2.5/Dockerfile)

# What is Dotclear? #
Dotclear is an open source blog publishing application.

http://dotclear.org

# How to use this image #
    docker run --name blog --link db_container:db -p 80:80 -d darknao/dotclear

You will need a database container using mysql or postgresql, with an already created database/user.

Blog data (media/plugins/themes/settings) are stored in a volume on /var/www/dotclear.

On first run, you'll get a configuration wizard to set your database settings.

Theses settings are saved in the /var/www/dotclear volume, and will be used afterwards.

## FPM variant ##
You can use [this configuration file](https://github.com/darknao/docker-dotclear/blob/master/fpm/fpm.conf) with nginx as an exemple for a quick try.

Start the fpm container:

    docker run --link mysqldb -d --name blog_fpm darknao/dotclear:2.8-fpm
Start nginx with a link with the fpm container (notice the fpm alias, it'll be used in the fpm.conf):

    docker run --link blog_fpm:fpm -d --name blog_nginx -v $(pwd)/fpm.conf:/etc/nginx/conf.d/default.conf:ro --volumes-from blog_fpm -p 80:80 nginx
    
# Dotclear upgrade #
Upgrade should be as easy as that:
    docker run --volumes-from old_dotclear --link db_container -p 80:80 -d darknao/dotclear:latest

