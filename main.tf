terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {
  }
  alias           = "hub"
  subscription_id = var.subscription_ids.hub
}

provider "azurerm" {
  features {
  }
  alias           = "dev"
  subscription_id = var.subscription_ids.dev
}

provider "azurerm" {
  features {
  }
  alias           = "test"
  subscription_id = var.subscription_ids.test
}

provider "azurerm" {
  features {
  }
  alias           = "prod"
  subscription_id = var.subscription_ids.prod
}

module "hub" {
  source   = "./modules/hub"
  location = var.location
  test_network_id = module.test.network.id
  dev_network_id = module.dev.network.id
  prod_network_id = module.prod.network.id
  providers = {
    azurerm = azurerm.hub
  }
}

module "test" {
  source             = "./modules/environment"
  name               = "test"
  location           = var.location
  vnet_network_index = 1
  hub_vnet_id        = module.hub.network.id
  providers = {
    azurerm = azurerm.test
  }
}

module "dev" {
  source             = "./modules/environment"
  name               = "dev"
  location           = var.location
  vnet_network_index = 2
  hub_vnet_id        = module.hub.network.id
  providers = {
    azurerm = azurerm.dev
  }
}

module "prod" {
  source             = "./modules/environment"
  name               = "prod"
  location           = var.location
  vnet_network_index = 3
  hub_vnet_id        = module.hub.network.id
  providers = {
    azurerm = azurerm.prod
  }
}
