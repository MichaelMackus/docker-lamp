#/bin/bash

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini

# symfony vhost
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-symfony.conf
sed -i 's#/var/www/html#/var/www/web#' /etc/apache2/sites-available/default-symfony.conf
sed -i 's#AllowOverride FileInfo#AllowOverride All#' /etc/apache2/sites-available/default-symfony.conf

# enable vhost
rm /etc/apache2/sites-enabled/000-default.conf
ln -s /etc/apache2/sites-available/default-symfony.conf /etc/apache2/sites-enabled/default-symfony.conf

# xdebug
if [ ! -z "$XDEBUG" ]; then
    echo "xdebug.remote_enable=1\nxdebug.remote_connect_back=1\nxdebug.max_nesting_level=10000" > /etc/php5/apache2/conf.d/zzz-custom.ini
    cp /etc/php5/apache2/conf.d/zzz-custom.ini /etc/php5/cli/conf.d/zzz-custom.ini
fi

# php debug
if [ ! -z "$XDEBUG" ] || [ ! -z "$DEBUG" ]; then
    sed -i 's/^display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
    sed -i 's/^display_errors = Off/display_errors = On/' /etc/php5/cli/php.ini
fi


exec supervisord -n
