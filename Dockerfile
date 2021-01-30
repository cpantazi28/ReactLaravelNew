FROM php:8.0-apache

# ARG app_home
# ARG project_name

ENV app_home=/var/www/html
ENV project_name=Laravel-React-Zinishis

RUN apt-get update && apt-get install -y \
       libicu-dev \
       libpq-dev \
       libmcrypt-dev \
       git \
       zip \
       unzip \
     && rm -r /var/lib/apt/lists/* \
     && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
     && docker-php-ext-install \
       intl \
                                    #mbstring \
                                    #mcrypt 
       pcntl \
       pdo_mysql \
       pdo_pgsql \
       pgsql \
                                    # zip \
       opcache

#Add composer      
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer


# Add nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt -y install nodejs
RUN apt -y install build-essential
RUN rm nodesource_setup.sh

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN sed -i -e "s/html/html\/$project_name\/public/g" /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite

#RUN composer global require laravel/installer


WORKDIR $app_home
COPY . ./$project_name

#RUN composer create-project --prefer-dist laravel/laravel:^8.0 $project_name
##RUN composer create-project laravel/laravel $project_name
WORKDIR $app_home/$project_name

# RUN chown -R www-data:www-data ./storage

# RUN composer require laravel/ui
# RUN php artisan ui react --auth

# RUN npm install
#RUN npm run watch

#USER $user
# RUN useradd -G www-data,root -u 1001 -d /home/$user $user
# USER $user

#RUN chown www-data:www-data /var/www/html/$project_name



# RUN /root/.composer/vendor/laravel/installer/bin/laravel new $project_name



#

#copy source files and run composer
#COPY . $APP_HOME

# install all PHP dependencies
# RUN composer install --no-interaction

# #change ownership of our applications
# RUN $APP_HOME

# RUN php artisan key:generate
# RUN npm rebuild node-sass
# RUN npm install && npm run dev


# RUN service apache2 start