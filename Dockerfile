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
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

#Installing PHP and extensions
RUN apt-get -y install php7.0 php7.0-redis php7.0-fpm php7.0-common php7.0-curl  \
php7.0-dev php7.0-mbstring php7.0-gd php7.0-json php7.0-redis php7.0-xml php7.0-zip php7.0-intl php7.0-mysql


# Install xdebug and redis
RUN apt-get install -y php7.0-xdebug php7.0-redis

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20160303/xdebug.so" >> /etc/php/7.0/fpm/php.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install wget
RUN apt install wget -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php7.0-fpm start && nginx -g "daemon off;"