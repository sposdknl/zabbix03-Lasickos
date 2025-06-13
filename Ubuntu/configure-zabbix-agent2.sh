#!/usr/bin/env bash

set -e
HOSTNAME="lasikova-autoregistrace"
ZBX_SERVER="192.168.1.2"
ZBX_METADATA="SPOS"

echo "[INFO] Nastavuji hostname: $HOSTNAME"
hostnamectl set-hostname "$HOSTNAME"

echo "[INFO] Zálohuji původní konfiguraci"
cp /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf.orig || true

echo "[INFO] Konfiguruji zabbix_agent2.conf"
sed -i "s/^Hostname=.*/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^Server=.*/Server=$ZBX_SERVER/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^ServerActive=.*/ServerActive=$ZBX_SERVER/" /etc/zabbix/zabbix_agent2.conf

# Přidej metadata, pokud chybí
grep -q "^HostMetadata=" /etc/zabbix/zabbix_agent2.conf || echo "HostMetadata=$ZBX_METADATA" >> /etc/zabbix/zabbix_agent2.conf

# Nastav timeout
sed -i "s/^# Timeout=.*/Timeout=30/" /etc/zabbix/zabbix_agent2.conf

echo "[INFO] Restartuji Zabbix agenta"
systemctl restart zabbix-agent2

echo "✅ Agent připraven, hostname = $HOSTNAME"
