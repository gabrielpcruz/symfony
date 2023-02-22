FROM ubuntu:20.04

#Sem interação humana
ARG DEBIAN_FRONTEND=noninteractive

#Updating operating system
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

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
RUN add-apt-repository ppa:ondrej/php -y && apt-get update

RUN apt install php8.0-fpm -y

RUN update-alternatives --set php /usr/bin/php8.0

#Installing PHP and extensions
RUN apt-get -y install php8.0-redis php8.0-fpm php8.0-common php8.0-curl  \
php8.0-dev php8.0-mbstring php8.0-gd php8.0-redis php8.0-xml php8.0-zip php8.0-intl php8.0-mysql

# Install xdebug and redis
RUN apt-get install php8.0-xdebug -y && apt install php8.0-redis -y

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20190902/xdebug.so" >> /etc/php/8.0/fpm/php.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install wget
RUN apt install wget -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php8.0-fpm start && nginx -g "daemon off;"