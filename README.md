# Supported tags and respective `Dockerfile` links #

- [`2.13`, `2.13.1`, `apache`, `latest` (*apache/2.13.1/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/apache/2.13.1/Dockerfile)
- [`2.12`, `2.12.1` (*apache/2.12.1/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/apache/2.12.1/Dockerfile)
- [`2.11`, `2.11.2` (*apache/2.11.2/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/apache/2.11.2/Dockerfile)
- [`2.10`, `2.10.4` (*apache/2.10.4/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/apache/2.10.4/Dockerfile)
- [`2.9`, `2.9.1` (*apache/2.9.1/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/apache/2.9.1/Dockerfile)
- [`2.13-fpm`, `fpm` (*fpm/2.13.1/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/fpm/2.13.1/Dockerfile)
- [`2.12-fpm` (*fpm/2.12.1/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/fpm/2.12.1/Dockerfile)
- [`2.11-fpm` (*fpm/2.11.2/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/fpm/2.11.2/Dockerfile)
- [`2.10-fpm` (*fpm/2.10.4/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/fpm/2.10.4/Dockerfile)
- [`2.9-fpm` (*fpm/2.9.1/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/fpm/2.9.1/Dockerfile)


# What is Dotclear? #
Dotclear is an open source blog publishing application distributed under the GNU GPLv2.

It's proposed aim is to develop a software that fully respects web standards based on open source solutions, with multilingual interface and publishing capabilities. It is written in PHP.

http://dotclear.org

![dotclear_logo](https://cloud.githubusercontent.com/assets/693402/9613090/a7454250-50e9-11e5-92a5-0ad55dc5a8af.png)

# How to use this image #
    docker run --name blog --link db_container:db -p 80:80 -d darknao/dotclear

You will need a database container using mysql or postgresql, with an already created database/user.

Dotclear data are stored in a volume on **/var/www/html**.

On the first run, you'll get a configuration wizard to set your database settings and create your config.php.

# FPM variant #
You can use [this configuration file](https://github.com/darknao/docker-dotclear/blob/master/fpm/fpm.conf) with nginx, for example.

Start the fpm container:

    docker run --link mysqldb -d --name blog_fpm darknao/dotclear:fpm
Start nginx with a link to the fpm container (notice the **fpm** alias, it'll be used in the **fpm.conf**):

    docker run -d -p 80:80 \
     --link blog_fpm:fpm \
     --name blog_nginx \
     -v $(pwd)/fpm.conf:/etc/nginx/conf.d/default.conf:ro \
     --volumes-from blog_fpm  nginx

# Dotclear upgrade #
Upgrade *should* happen automagically if you run an up to date image on an existing volume:

    docker run --volumes-from old_blog --link database -p 80:80 -d darknao/dotclear:latest


