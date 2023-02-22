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

RUN apt install php8.1-fpm -y

RUN update-alternatives --set php /usr/bin/php8.1

#Installing PHP and extensions
RUN apt-get -y install php8.1-redis php8.1-fpm php8.1-common php8.1-curl  \
php8.1-dev php8.1-mbstring php8.1-gd php8.1-redis php8.1-xml php8.1-zip php8.1-intl php8.1-mysql

# Install xdebug and redis
RUN apt-get install php8.1-xdebug -y && apt install php8.1-redis -y

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20210902/xdebug.so" >> /etc/php/8.1/fpm/php.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install wget
RUN apt install wget -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php8.1-fpm start && nginx -g "daemon off;"