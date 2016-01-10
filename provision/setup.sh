#!/usr/bin/env bash

echo "Provisioning virtual machine..."

echo "Configuration Machine"
sudo locale-gen UTF-8
sudo echo "127.0.0.1 ohorodnyk.dev www.ohorodnyk.dev" >> /etc/hosts
sudo apt-get install python-software-properties -y

echo "Installing Git"
sudo apt-get install git -y

echo "Installing MC"
sudo apt-get install mc -y

echo "Installing PHP 7"
sudo apt-get purge php5-fpm -y && apt-get --purge autoremove -y
sudo add-apt-repository ppa:ondrej/php-7.0
sudo apt-get update
sudo apt-get install php-xdebug php7.0-fpm php7.0-curl php7.0-cli php7.0-mcrypt php7.0-json php7.0-sqlite3 -y
sudo sed -i "s/www-data/vagrant/g" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/;listen.mode/listen.mode/g" /etc/php/7.0/fpm/pool.d/www.conf
sudo service php7.0-fpm restart

echo "Installing Nginx"
sudo echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt-get update
sudo apt-get install nginx -y
sudo rm -rf /etc/nginx/conf.d/*
sudo cp /vagrant/provision/conf/ohorodnyk.dev.conf /etc/nginx/conf.d/
sudo sed -i "s/nginx;/vagrant vagrant;/g" /etc/nginx/nginx.conf
sudo service nginx restart

echo "Preparing infrastructure"
sudo mkdir -p /var/www/ohorodnyk.dev
sudo chown -R vagrant.vagrant /var/www

echo "Finished provisioning."
