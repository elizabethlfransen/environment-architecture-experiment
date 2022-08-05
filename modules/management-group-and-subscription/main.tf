terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16"
    }
  }

  required_version = ">= 1.1.0"
}

resource "azurerm_management_group" "parent_group" {
  display_name               = var.environment_name
  name                       = "mg-${var.environment_id}"
  parent_management_group_id = var.parent_management_group_id
  subscription_ids = [
    azurerm_subscription.subscription.subscription_id
  ]
}

resource "azurerm_subscription" "subscription" {
  subscription_name = var.environment_name
  billing_scope_id  = var.billing_scope_id
  provisioner "local-exec" {
    command = "az account list --refresh"
  }
  provisioner "local-exec" {
    command = "az account list --refresh"
    when    = destroy
  }
}