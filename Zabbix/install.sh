#!/bin/bash

# Package update and upgrade
sudo apt-get update
sudo apt-get upgrade -y

# Zabbix prepare installation
curl -sL "https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian13_all.deb" -o ./zabbix-release_latest.deb
sudo dpkg -i ./zabbix-release_latest.deb
sudo apt-get update

# Zabbix installation
sudo apt-get install -y mariadb-server mariadb-client apache2 php libapache2-mod-php
sudo apt-get install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent2

# Database installation
sudo mariadb < /vagrant/mariadb.sql
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | sudo mariadb --default-character-set=utf8mb4 zabbix
sudo mariadb -e "set global log_bin_trust_function_creators = 0;"

# Edit configuration
sudo sed -i '/# DBPassword=/a DBPassword=zabbix' /etc/zabbix/zabbix_server.conf

# Restart services
systemctl restart zabbix-server zabbix-agent2 apache2
systemctl enable zabbix-server zabbix-agent2 apache2
