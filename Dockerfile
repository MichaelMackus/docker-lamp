FROM tutum/lamp:latest

RUN apt-get update --fix-missing
RUN apt-get -y install curl libssh2-php php5-curl php5-xdebug php5-gd php5-memcached php5-sqlite
RUN apt-get -y install nodejs-legacy npm

RUN npm install -g bower

RUN curl -sS https://getcomposer.org/installer | php
RUN ln -s /composer.phar /usr/bin/composer

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

# disable mysql
RUN rm /etc/supervisor/conf.d/supervisord-mysqld.conf

ADD run.sh /runcustom.sh
RUN chmod 755 /*.sh

CMD "/runcustom.sh"

# vim:set ft=sh:
