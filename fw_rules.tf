resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-nsg"
  location            = local.location
  resource_group_name = local.rg_name

  security_rule {
    name                       = "ssh"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
    source_address_prefixes    = local.ip_whitelist
  }
}
