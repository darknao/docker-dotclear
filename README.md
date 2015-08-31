# Supported tags and respective `Dockerfile` links #

-	[`2.7.5` (*2.7.5/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/2.7.5/Dockerfile)
-	[`2.8`, `latest` (*2.8/Dockerfile*)](https://github.com/darknao/docker-dotclear/blob/master/2.8/Dockerfile)

# What is Dotclear? #
Dotclear is an open source blog publishing application.
http://dotclear.org

# How to use this image #
    docker run --name blog --link db_container:db -p 80:80 -d darknao/dotclear

You will need a database container using mysql or postgresql, with an already created database/user.

Blog data (media/plugins/themes/settings) are stored in a volume on /var/www/dotclear.

On first run, you'll get a configuration wizard to set your database settings.
Theses settings are saved in the /var/www/dotclear volume, and will be used afterwards.

# Dotclear upgrade #
Upgrade should be as easy as that:
    docker run --volumes-from old_dotclear --link db_container -p 80:80 -d darknao/dotclear:latest
