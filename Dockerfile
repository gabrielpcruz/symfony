FROM ubuntu:20.04

#Sem interação humana
ARG DEBIAN_FRONTEND=noninteractive

#Updating operating system
RUN apt-get update && apt-get -y upgrade

RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null

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

RUN apt install php8.2-fpm -y

#Installing PHP and extensions
RUN apt-get -y  install php8.2 php8.2- \
    redis php8.2-fpm php8.2-common php8.2-curl  \
php8.2-dev php8.2-mbstring php8.2-gd php8.2-redis php8.2-xml php8.2-zip php8.2-intl php8.2-mysql --allow-change-held-packages


# Install xdebug and redis
RUN apt-get install php-xdebug -y && apt install php-redis -y

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20220829/xdebug.so" >> /etc/php/8.2/fpm/php.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install wget
RUN apt install wget -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php8.2-fpm start && nginx -g "daemon off;"