output "ubuntu_test_ip" {
  value = esxi_guest.ubuntu_test.ip_address
}

resource "local_file" "ansible_inventory_file" {
  filename = "../ansible/inventory.ini"
  content = <<EOT
[all]
${esxi_guest.ubuntu_test.ip_address} app_name=demoapp
EOT
}