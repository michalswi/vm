locals {
  tags         = var.tags
  name         = var.name
  location     = var.location
  rg_name      = var.rg_name
  subnet_id    = var.source_subnet_id
  vnet_name    = var.source_vnet_name
  ip_whitelist = var.ip_whitelist
  vm_size      = var.vm_size
  key_vault_id = var.key_vault_id
}

resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
  subnet_id                 = local.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "nicnsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip" {
  name                    = "${local.name}-pip"
  location                = local.location
  resource_group_name     = local.rg_name
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.name}-nic"
  location            = local.location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
resource "azurerm_linux_virtual_machine" "this" {
  name                = "${local.name}-vm"
  resource_group_name = local.rg_name
  location            = local.location
  size                = local.vm_size

  admin_username = "oneav"

  admin_ssh_key {
    username   = "oneav"
    public_key = local_file.ssh_public_key.content
  }

  computer_name = "oneav"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "${local.name}disk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key" {
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0600"
  filename        = "./test"
}

resource "local_file" "ssh_public_key" {
  content         = tls_private_key.private_key.public_key_openssh
  file_permission = "0644"
  filename        = "./test.pub"
}

resource "azurerm_role_assignment" "kv_access" {
  principal_id         = azurerm_linux_virtual_machine.this.identity[0].principal_id
  role_definition_name = "Key Vault Secrets User"
  scope                = local.key_vault_id
}
