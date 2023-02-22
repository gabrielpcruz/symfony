FROM ubuntu:20.04

#Sem interação humana
ARG DEBIAN_FRONTEND=noninteractive

#Updating operating system
RUN apt-get update && apt-get -y upgrade

##Installing essential packages
RUN apt-get -y install \
               apt-utils \
               software-properties-common \
               curl \
               bash-completion \
               vim \
               git \
               zip \
               unzip \
               libmagickwand-dev \
               libzip-dev \
               libpng-dev \
               libonig-dev \
               libxml2-dev

#Installing NGINX
RUN apt-get -y install nginx

#
COPY default /etc/nginx/sites-enabled/default

##Adding PHP repository
RUN add-apt-repository ppa:ondrej/php -y && apt-get update -y

RUN apt install php7.4-fpm -y

RUN update-alternatives --set php /usr/bin/php7.4

#Installing PHP and extensions
RUN apt-get -y install php7.4-redis php7.4-fpm php7.4-common php7.4-curl  \
php7.4-dev php7.4-mbstring php7.4-gd php7.4-redis php7.4-xml php7.4-zip php7.4-intl php7.4-mysql

# Install xdebug and redis
RUN apt-get install php7.4-xdebug -y && apt install php7.4-redis -y

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20200930/xdebug.so" >> /etc/php/7.4/fpm/php.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install wget
RUN apt install wget -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php7.4-fpm start && nginx -g "daemon off;"