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
  name     = "rg-hub"
  location = var.location
}

resource "azurerm_virtual_network" "network" {
  name     = "vnet-hub"
  location = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space = ["10.0.0.0/16"]

  subnet {
    name="subnet-gateway"
    address_prefix = "10.0.0.0/24"
  }


  subnet {
    name="subnet-hub-resources"
    address_prefix = "10.0.1.0/24"
  }
}


resource "azurerm_virtual_network_peering" "test_peering_connection" {
    name = "peer-hub-to-test"
    resource_group_name = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.network.name
    remote_virtual_network_id = var.test_network_id
}

resource "azurerm_virtual_network_peering" "dev_peering_connection" {
    name = "peer-hub-to-dev"
    resource_group_name = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.network.name
    remote_virtual_network_id = var.dev_network_id
}

resource "azurerm_virtual_network_peering" "prod_peering_connection" {
    name = "peer-hub-to-prod"
    resource_group_name = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.network.name
    remote_virtual_network_id = var.prod_network_id
}