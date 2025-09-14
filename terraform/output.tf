output "ubuntu_test_ip" {
  value = esxi_guest.ubuntu_test.ip_address
}

resource "local_file" "ansible_inventory_file" {
  filename = "../ansible/inventory.ini"
  content = <<EOT
[all]
${esxi_guest.ubuntu_test.ip_address} app_name=demoapp
[all:vars]
ansible_user=terraform
ansible_ssh_private_key_file=${var.ssh_public_key_path}
EOT
}