terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16"
    }
  }

  required_version = ">= 1.1.0"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.name}"
  location = var.location
}

resource "azurerm_virtual_network" "network" {
  name                = "vnet-${var.name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.${var.vnet_network_index}.0.0/16"]
}

resource "azurerm_subnet" "subnet_resources" {
  name                 = "subnet-resources"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.${var.vnet_network_index}.0.0/24"]
}

resource "azurerm_virtual_network_peering" "hub_peering_connection" {
  name                      = "peer-${var.name}-to-hub"
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.network.name
  remote_virtual_network_id = var.hub_vnet_id
}

resource "azurerm_network_interface" "vm_network_interface" {
  name                = "net-interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_resources.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${var.name}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm_network_interface.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/Keys/vm-test_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}


resource "azurerm_public_ip" "vm_pip" {
  name                = "pip-vm"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface_security_group_association" "vm_sg_association" {
  network_interface_id      = azurerm_network_interface.vm_network_interface.id
  network_security_group_id = azurerm_network_security_group.vm_security_group.id
}

resource "azurerm_network_security_group" "vm_security_group" {
  name                = "nsg-vm-hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_network_security_rule" "vm_ssh_rule" {
  name                        = "nsr-vm-hub-ssh"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.vm_security_group.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}
