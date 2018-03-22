#!/usr/bin/env bash

echo "starting supervisor"
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
/usr/bin/supervisord -c/etc/supervisor/supervisord.conf &

# wait for services to start
sleep 25

echo "doing some setup"
mysql -uroot -p$DB_PASSWORD -e "create database $DB_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci"

tail -n 300 /var/log/mysql/error.log