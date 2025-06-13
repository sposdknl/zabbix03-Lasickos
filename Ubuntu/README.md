# 📦 Instalace Zabbix Agent2 na Ubuntu – SPOS DK

Tento repozitář slouží k výuce v rámci předmětu SPOS DK. Poskytuje automatizovanou instalaci a konfiguraci **Zabbix Agent2 (verze 7.0 LTS)** na Ubuntu pomocí Vagrantu.

![Ubuntu and ZabbixAgent2 OSY AI](../Images/osy-Ubuntu-ZabbixAgent2.webp)

---

## 🧰 Automatická instalace Zabbix Agent2

Pomocí Vagrantu se vytvoří virtuální stroj s Ubuntu, nainstaluje se Zabbix Agent2 a automaticky se zaregistruje na Zabbix server (**Zabbix Appliance**) v síti `192.168.1.0/24`.
install-zabbix-agent2.sh
Přidává oficiální Zabbix repozitář pro verzi 7.0 LTS
Instaluje balíček zabbix-agent2 a pluginy
Povoluje a spouští službu zabbix-agent2
---
## ⚙️ Konfigurace
Nastavuje hostname na lasikova-autoregistrace
Konfiguruje /etc/zabbix/zabbix_agent2.conf s těmito parametry:
Hostname=lasikova-autoregistrace
Server=192.168.1.2
ServerActive=192.168.1.2
HostMetadata=SPOS
Timeout=30


### ⚙️ Přehled konfigurace (`Vagrantfile`)

- Využívá box `ubuntu/jammy64` (Ubuntu 22.04)  
- Vytvoří druhou síťovou kartu v režimu **intnet** s IP `192.168.1.3`  
- Nastaví jméno VM a provede provisioning pomocí dvou skriptů:

```ruby
config.vm.network "private_network", ip: "192.168.1.3", virtualbox__intnet: true
config.vm.provision "shell", path: "install-zabbix-agent2.sh"
config.vm.provision "shell", path: "configure-zabbix-agent2.sh"

