
# IAC Opdrachten week4

## Hoe deploy je een VM naar ESXI met Terraform
Voordat er wordt begonnen wordt er vanuit gegaan dat terraform al geinstalleerd is.

Als eerste maak een bestand genaamd `terraform.tf` en plak hetvolgende erin:

```terraform
terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "~> 1.6"
    }
  }
}

provider "esxi" {
  esxi_hostname = "<IP vna ESXI host>"
  esxi_hostport = 22
  esxi_hostssl  = 443
  esxi_username = "<gebruikersnaam van esxi gebruiker>"
  esxi_password = "<wachtwoord van de ESXI gebruiker>"
}

resource "esxi_guest" "ubuntu_test" {
  guest_name = "ubuntu-test-vm"
  disk_store = "<datastore die door de vm gebruikt moet worden>"
  ovf_source = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"

  network_interfaces {
    virtual_network = "VM Network"
  }

  memsize = 1024
  numvcpus = 1
}
```

Vul de volgende variabelen in:
* `esxi_hostname`: IP/FQDN van je esxi host.
* `esxi_username`: De gebruikersnaam van de gebruiker waar terraform mee gaat inloggen op je ESXI host. Deze heeft ook de juiste rechten nodig om VMs te kunnen beheren.
* `esxi_password`: het wachtwoord van de ESXI gebruiker die terraform gebruikt om in te loggen.
* `disk_store` in het resource block: vul hier de naam van de datastore in die door de vm gebruikt moet worden.

Optioneel kan je de `ovf_source` en `network_interfaces` nog veranderen naar wens.

### Deployment uitvoeren
voer de volgende commando's uit om de VM te deployen:
``` bash
terraform init
terraform apply
```
het `terraform init` commando initialiseert en download de esxi provider.
het `terraform apply` commando geeft een overzicht van de verandereingen en kun je deze accepteren door 'yes' te teypen. iedere andere input weigert de actie.

Na het accepteren zou de VM gedeployed worden.

## Hoe gebruik je Ansible om de VM te configureren?

Om Ansible te gebruiken wordt er vanuit gegaan dat Ansible al geinstalleerd is.

begin door het maken van een `inventory.ini` bestand en deze te vullen met je ubuntu VM:
```ini
[hosts]
app1 ansible_host=<IP/FQDN server 1>
app2 ansible_host=<IP/FQDN server 2>

```

vervolgens maak je een `playbook.yml` aan. Hier komeen je taken in. In dit voorbeeld wordt een nginx server geinstalleerd:
``` yml
- name: Install nginx
  hosts: all
  become: yes
  tasks:
    - name: Install package (packages)
      ansible.builtin.package:
        name: "nginx"
        state: present
```
vervolgens kun je deze uitvoeren met:
``` bash
ansible-playbook -i inventory.ini playbook.yml
```



