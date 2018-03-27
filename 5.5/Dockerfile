FROM php:5.5-apache

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip

VOLUME /var/www/html

# xdebug & redis
RUN yes | pecl install redis-2.2.5 memcache-3.0.8 xdebug \
	&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
	&& echo "extension=memcache.so" > /usr/local/etc/php/conf.d/memcache.ini \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \ 
	&& echo "xdebug.max_nesting_level=500" >> /usr/local/etc/php/conf.d/xdebug.ini

# drupal config for php
COPY opcache-recommended.ini drupal.ini /usr/local/etc/php/conf.d/

RUN apt-get update && apt-get -y install mysql-client

WORKDIR /root
# Install Drush 5 (legacy, can probably be removed)
RUN curl -L -O https://github.com/drush-ops/drush/archive/5.11.0.tar.gz \
	&& tar -xzf 5.11.0.tar.gz \
	&& chmod u+x /root/drush-5.11.0/drush \
	&& ln -s /root/drush-5.11.0/drush /usr/bin/drush5

# Install Drush 8
# If the .phar becomes unavailable this could be installed using Composer
# e.g. RUN composer global require drush/drush:"$DRUSH_VERSION" --prefer-dist
RUN curl -OL https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar \
	&& chmod +x drush.phar \
	&& mv drush.phar /usr/local/bin/drush

ENV NR_INSTALL_SILENT true
ENV NR_INSTALL_PATH /usr/local/bin;
	
EXPOSE 80 443

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]