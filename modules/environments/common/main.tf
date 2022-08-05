terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16"
    }
  }

  required_version = ">= 1.1.0"
}

module "networking" {
  source             = "./networking"
  name               = var.name
  vnet_address_range = var.vnet_address_range
  location           = var.location
  hub_network        = var.hub_network
}
