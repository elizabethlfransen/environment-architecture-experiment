resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.name}-network"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name = "vnet-${var.name}"
  location = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space = [
    "${var.vnet_address_range}"
  ]
}

resource "azurerm_virtual_network_peering" "peer_spoke_to_hub" {
  name = "peer-${var.name}-to-hub"
  resource_group_name = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.hub_network_id
}