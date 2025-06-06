#!/bin/bash
# install_zabbix_agent.sh

set -e  # Ukončí skript při chybě

# Stažení a přidání Zabbix repozitáře (Zabbix 7.0 LTS)
wget -q https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu20.04_all.deb
sudo dpkg -i zabbix-release_7.0-1+ubuntu20.04_all.deb
sudo apt update

# Instalace Zabbix Agent2
sudo apt install -y zabbix-agent2

# Konfigurace agenta
sudo sed -i 's/^Server=.*/Server=192.168.1.2/' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/^ServerActive=.*/ServerActive=192.168.1.2/' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/^Hostname=.*/Hostname=ubuntu-spos/' /etc/zabbix/zabbix_agent2.conf

# Přidání metadata pro autoregistraci
if grep -q "^# HostMetadata=" /etc/zabbix/zabbix_agent2.conf; then
    sudo sed -i 's/^# HostMetadata=.*/HostMetadata=SPOS/' /etc/zabbix/zabbix_agent2.conf
else
    echo "HostMetadata=SPOS" | sudo tee -a /etc/zabbix/zabbix_agent2.conf
fi

# Povolení a spuštění služby
sudo systemctl enable zabbix-agent2
sudo systemctl restart zabbix-agent2

# Výpis stavu služby
echo "✅ Zabbix Agent2 status:"
systemctl status zabbix-agent2 --no-pager
