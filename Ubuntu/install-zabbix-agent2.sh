#!/usr/bin/env bash

set -e
apt-get update -qq
apt-get install -y -qq net-tools wget gnupg2

echo "[INFO] Přidávám Zabbix repository"
wget -q https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_7.0-1+ubuntu22.04_all.deb

apt-get update -qq
apt-get install -y -qq zabbix-agent2 zabbix-agent2-plugin-*

echo "[INFO] Povoluji a spouštím zabbix-agent2"
systemctl enable zabbix-agent2
systemctl start zabbix-agent2
