FROM php:8.0-apache
COPY . /var/www/html/site
COPY ./000-default.conf /etc/apache2/sites-available
COPY ./php.ini /usr/local/etc/php
WORKDIR /var/www/html/site
EXPOSE 80
RUN apt-get update && apt-get upgrade -y

RUN docker-php-ext-install mysqli pdo pdo_mysql

# Composer setup
RUN cd /bin && mkdir composer && cd composer
RUN chmod 777 /bin/composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm composer-setup.php

RUN apt-get -y install unzip
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN a2enmod rewrite
RUN  composer install --no-dev --prefer-dist --optimize-autoloader --no-scripts

# Rename FilesystemLoader.php to Filesystemloader.php
WORKDIR /var/www/html/site/vendor/twig/twig/src/Loader
RUN mv FilesystemLoader.php Filesystemloader.php

RUN apt install nano
CMD ["apache2ctl", "-D","FOREGROUND"]
