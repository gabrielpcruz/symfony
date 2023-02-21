FROM ubuntu:16.04

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
RUN apt-get -y install php5.5 php5.5-redis php5.5-fpm php5.5-common php5.5-curl  \
php5.5-dev php5.5-mbstring php5.5-gd php5.5-json php5.5-redis php5.5-xml php5.5-zip php5.5-intl php5.5-mysql


# Install xdebug and redis
RUN apt-get install -y php5.5-xdebug php5.5-redis

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20131226/xdebug.so" >> /etc/php/5.5/fpm/php.ini

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install wget
RUN apt install wget -y

# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php5.5-fpm start && nginx -g "daemon off;"