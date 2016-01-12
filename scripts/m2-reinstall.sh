#!/usr/bin/env bash

DIR=$1
DIR=$MAGENTO2_DIR$
DB_NAME=$2
DB_NAME="magento2"

if [[ -z "$DIR" ]]; then
   echo "$0 directory database"
   exit 1;
fi
if [[ -z "$DB_NAME" ]]; then
   echo "$0 directory database"
   exit 1;
fi

if [[ ! -d "$DIR" ]]; then
   echo "$DIR is not directory"
fi

cd $DIR;

composer install

rm -rf var/*

php bin/magento setup:uninstall -n
php bin/magento setup:install --currency=USD --db-host=127.0.0.1 --db-name=$DB_NAME --db-user=root --db-password=123123q --use-rewrites=1 --admin-lastname=Smith --admin-firstname=John --admin-email="john.smith@some-email.com" --admin-user=admin --admin-password=123123q --use-secure=0 --base-url="http://magento.two" --backend-frontname="admin" --cleanup-database --session-save=db --admin-use-security-key=0 --db-prefix="p_"

rm -rf var/*

# php bin/magento setup:di:compile
# php bin/magento setup:static-content:deploy

php bin/magento indexer:reindex

php bin/magento cache:clean full_page

# sudo service varnish restart
