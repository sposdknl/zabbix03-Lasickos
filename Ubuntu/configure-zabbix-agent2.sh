#!/usr/bin/env bash

# Generování unikátního hostname
UNIQUE_HOSTNAME="ubuntu-$(uuidgen)"
SHORT_HOSTNAME=$(echo "$UNIQUE_HOSTNAME" | cut -d'-' -f1,2)

echo "✅ Vygenerovaný hostname: $SHORT_HOSTNAME"

# Nastavení systémového hostname
echo "$SHORT_HOSTNAME" | sudo tee /etc/hostname
sudo hostnamectl set-hostname "$SHORT_HOSTNAME"

# Cesta ke konfiguračnímu souboru agenta
CONF="/etc/zabbix/zabbix_agent2.conf"

# Záloha původního konfiguračního souboru
if [ -f "$CONF" ]; then
  sudo cp -v "$CONF" "${CONF}-orig"
else
  echo "❌ Konfigurační soubor $CONF neexistuje."
  exit 1
fi

# Úprava konfigurace agenta
sudo sed -i "s/^Hostname=.*/Hostname=$SHORT_HOSTNAME/" "$CONF"
sudo sed -i "s/^Server=.*/Server=enceladus.pfsense.cz/" "$CONF"
sudo sed -i "s/^ServerActive=.*/ServerActive=enceladus.pfsense.cz/" "$CONF"
sudo sed -i "s/# Timeout=3/Timeout=30/" "$CONF"

# Přidání HostMetadata, pokud není odkomentované
if grep -q "^# HostMetadata=" "$CONF"; then
  sudo sed -i 's/# HostMetadata=.*/HostMetadata=SPOS/' "$CONF"
elif ! grep -q "^HostMetadata=" "$CONF"; then
  echo "HostMetadata=SPOS" | sudo tee -a "$CONF"
fi

# Porovnání změn
sudo diff -u "${CONF}-orig" "$CONF"

# Restart agent2
echo "🔄 Restartuji zabbix-agent2..."
sudo systemctl restart zabbix-agent2

# Výpis statusu
echo "✅ Zabbix agent2 stav:"
systemctl status zabbix-agent2 --no-pager

# Konec
echo "✅ Hotovo. Hostname nastaven na $SHORT_HOSTNAME a Zabbix agent nakonfigurován."
