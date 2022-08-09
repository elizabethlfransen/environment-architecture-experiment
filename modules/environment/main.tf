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
  name     = "vnet-${var.name}"
  location = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space = ["10.${var.vnet_network_index}.0.0/16"]

}

resource "azurerm_virtual_network_peering" "hub_peering_connection" {
    name = "peer-${var.name}-to-hub"
    resource_group_name = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.network.name
    remote_virtual_network_id = var.hub_vnet_id
}