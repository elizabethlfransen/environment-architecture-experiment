terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16"
    }
  }

  required_version = ">= 1.1.0"
}

module "common_resources" {
  source             = "../common"
  name               = var.name
  location           = var.location
  vnet_address_range = var.vnet_address_range
}
