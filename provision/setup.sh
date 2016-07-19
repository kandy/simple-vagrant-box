#!/usr/bin/env bash

#echo "Installing Docker"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-engine
sudo apt-get install -y language-pack-en
sudo locale-gen "en_US.UTF-8"
sudo usermod -aG docker ubuntu

wget -nv -O docker-compose https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m`
sudo mv docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Installing Git"
sudo apt-get install git -y

echo "Installing MC"
sudo apt-get install mc -y

echo "Installing PHP 7"
sudo apt-get install -y php-fpm php-curl php-cli php-mcrypt php-json php-xdebug \
    php-sqlite3 php-intl php-xsl php-gd php-mysql php-amqp php-amqplib php-zip
sudo sed -i "s/www-data/ubuntu/g" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/;listen.mode/listen.mode = 0777;/g" /etc/php/7.0/fpm/pool.d/www.conf
sudo service php7.0-fpm restart

echo "Installing composer"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
