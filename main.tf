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
  source = "./modules/hub"
  providers = {
    azurerm = azurerm.hub
  }
}

module "test" {
  source = "./modules/environment"
  providers = {
    azurerm = azurerm.test
  }
}

module "dev" {
  source = "./modules/environment"
  providers = {
    azurerm = azurerm.dev
  }
}

module "prod" {
  source = "./modules/environment"
  providers = {
    azurerm = azurerm.prod
  }
}
