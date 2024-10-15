output "ssh_username" {
  value = azurerm_linux_virtual_machine.this.admin_username
}

output "public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}
