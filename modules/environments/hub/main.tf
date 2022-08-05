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
  name     = "rg-shared-resources"
  location = var.location
}

resource "azurerm_virtual_network" "hub_vnet" {
  name = "vnet-hub"
  location = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space = [
    "10.0.0.0/16"
  ]

  subnet {
    name = "hub-gateway"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name = "hub-resources"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    Environment = "Shared"
  }
}

resource "azurerm_virtual_network_peering" "spoke_peers" {
  for_each = var.spoke_network_ids
  name = "peer-hub-to-${each.key}"
  resource_group_name = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = each.value
}