#!/bin/bash

set -x
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get update --fix-missing
apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
apt-get install python3 -y
apt-get install python3-pip -y
sudo apt-get install pkg-config -y
export MYSQLCLIENT_CFLAGS=-I/usr/include/mysql
export MYSQLCLIENT_LDFLAGS=-L/usr/lib/x86_64-linux-gnu
apt-get install libmysqlclient-dev -y
pip3 install mysqlclient
pip3 install PyMySQL
apt-get install mysql-client-core-8.0 -y
apt-get install mysql-server -y
touch /home/ubuntu/.my.cnf
cat << EOF >> /home/ubuntu/.my.cnf
[client]
user=ubuntu
password=ubuntu
EOF
cat /home/ubuntu/.my.cnf
#----- wpis do bazy -----

MYSQL_USER="ubuntu"
MYSQL_PASSWORD="ubuntu"

mysql <<EOF
CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Sprawdzanie czy komenda MySQL zakończyła się sukcesem
if [ $? -eq 0 ]; then
    echo "Utworzono użytkownika '${MYSQL_USER}' i nadano mu wszystkie uprawnienia."
else
    echo "Wystąpił problem podczas tworzenia użytkownika i nadawania uprawnień."
fi

#------dostepy dla ansible -------
#------naraz chyba nie mozna wszystkiego bo sie wywala---------
chown -R ubuntu:ubuntu /var/lib/apt/lists/
chown -R ubuntu:ubuntu /var/lib/dpkg/
chown -R ubuntu:ubuntu /var/cache/apt/archives/
#-----pozostałe tematy ----------
apt-get update && apt-get install -y apache2 ssl-cert -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
apt-get install php-ssh2 -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
chown -R ubuntu:ubuntu /var/www/ # po instalacji apache2
chown -R ubuntu:ubuntu /etc/apache2/ # po instalacji apache2


