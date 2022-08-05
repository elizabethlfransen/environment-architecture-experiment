terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16"
    }
  }

  required_version = ">= 1.1.0"
}

locals {
  environments = {
    dev  = "Dev"
    test = "Test"
    prod = "Production"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_management_group" "parent_group" {
  display_name = "Hub"
  name = "mg-hub"
  subscription_ids = [
    azurerm_subscription.shared_services_subscription.subscription_id
  ]
}

resource "azurerm_subscription" "shared_services_subscription" {
  subscription_name = "Shared Resources"
  billing_scope_id  = var.billing_scope_id
  provisioner "local-exec" {
    command = "az account list --refresh"
  }
  provisioner "local-exec" {
    command = "az account list --refresh"
    when    = destroy
  }
}

module "dev" {
  source                     = "./modules/environment"
  environment_id             = "dev"
  environment_name           = "Dev"
  parent_management_group_id = azurerm_management_group.parent_group.id
  billing_scope_id           = var.billing_scope_id
}

module "test" {
  source                     = "./modules/environment"
  environment_id             = "test"
  environment_name           = "Test"
  parent_management_group_id = azurerm_management_group.parent_group.id
  billing_scope_id           = var.billing_scope_id
}

module "prod" {
  source                     = "./modules/environment"
  environment_id             = "prod"
  environment_name           = "Production"
  parent_management_group_id = azurerm_management_group.parent_group.id
  billing_scope_id           = var.billing_scope_id
}
