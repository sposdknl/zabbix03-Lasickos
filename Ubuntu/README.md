# 📦 Install Zabbix Agent2 on Ubuntu – SPOS DK

Repozitář pro výuku na SPOS DK – automatická instalace a konfigurace **Zabbix Agent2 (verze 7.0 LTS)** na Ubuntu pomocí Vagrantu.

![Ubuntu and ZabbixAgent2 OSY AI](../Images/osy-Ubuntu-ZabbixAgent2.webp)

---

## 🧰 Automatická instalace Zabbix Agent2

Pomocí Vagrantu se vytvoří Ubuntu VM, nainstaluje se Zabbix Agent2 a automaticky se zaregistruje na Zabbix server **(Zabbix Appliance)** v síti `192.168.1.0/24`.

---

### ⚙️ Vagrantfile obsahuje:

- Definici boxu `ubuntu/jammy64`
- Přesměrování portu 22 → 2202
- Druhou síťovou kartu v režimu **intnet** s IP `192.168.1.3`
- Automatické spuštění instalačních skriptů:

```ruby
config.vm.network "private_network", ip: "192.168.1.3", virtualbox__intnet: true
config.vm.provision "shell", path: "install-zabbix-agent2.sh"
config.vm.provision "shell", path: "configure-zabbix-agent2.sh"
