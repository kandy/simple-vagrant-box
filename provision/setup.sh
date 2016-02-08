#!/usr/bin/env bash

source /vagrant/provision/config.sh

echo "Provisioning virtual machine..."

echo $MAGENTO2_DIR

echo "Configuration Machine"
sudo locale-gen UTF-8
sudo echo "127.0.0.1 ohorodnyk.dev www.ohorodnyk.dev" >> /etc/hosts
sudo echo "127.0.0.1 magento.two" >> /etc/hosts
sudo apt-get install python-software-properties -y
sudo cp $VAGRANT_DIR/scripts/m2-reinstall.sh $VAGRANT_USER_HOME_DIR/
sudo sed -i "s,\$MAGENTO2_DIR\$,$MAGENTO2_DIR,g" $VAGRANT_USER_HOME_DIR/m2-reinstall.sh
sudo mkdir -p $MAGENTO2_DIR
sudo chown -R vagrant.vagrant $MAGENTO2_DIR
sudo chown -R vagrant.vagrant $VAGRANT_USER_HOME_DIR/m2-reinstall.sh
sudo chmod +x $VAGRANT_USER_HOME_DIR/m2-reinstall.sh

echo "Installing Git"
sudo apt-get install git -y

echo "Installing MC"
sudo apt-get install mc -y

echo "Installing PHP 7"
sudo apt-get purge php5-fpm -y 
sudo apt-get --purge autoremove -y
sudo add-apt-repository ppa:ondrej/php-7.0
sudo apt-get update
sudo apt-get install php-xdebug php7.0-fpm php7.0-curl php7.0-cli php7.0-mcrypt php7.0-json php7.0-sqlite3 php7.0-intl php7.0-xsl php7.0-gd php7.0-mysql -y
sudo sed -i "s/www-data/vagrant/g" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/;listen.mode/listen.mode/g" /etc/php/7.0/fpm/pool.d/www.conf
sudo service php7.0-fpm restart

echo "Installing composer"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer

echo "Installing Nginx"
sudo echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt-get update
sudo apt-get install nginx -y
sudo rm -rf /etc/nginx/conf.d/*
sudo cp $VAGRANT_DIR/provision/conf/* /etc/nginx/conf.d/
sudo sed -i "s,\$MAGENTO2_DIR\$,$MAGENTO2_DIR,g" /etc/nginx/conf.d/magento.two.conf
sudo sed -i "s/nginx;/vagrant vagrant;/g" /etc/nginx/nginx.conf
sudo service nginx restart

echo "Installing MySQL"
echo "mysql-server-5.6 mysql-server/root_password password 123123q" | sudo debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password 123123q" | sudo debconf-set-selections
sudo apt-get install mysql-server-5.6 mysql-client-5.6 -y

echo "Finished provisioning."
