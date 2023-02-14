FROM ubuntu:18.04

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
RUN apt-get -y install php5.6 php5.6-redis php5.6-fpm php5.6-common php5.6-curl  \
php5.6-dev php5.6-mbstring php5.6-gd php5.6-json php5.6-redis php5.6-xml php5.6-zip php5.6-intl php5.6-mysql


# Install xdebug and redis
RUN apt-get install -y php5.6-xdebug php5.6-redis

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20131226/xdebug.so" >> /etc/php/5.6/fpm/php.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install wget
RUN apt install wget -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php5.6-fpm start && nginx -g "daemon off;"