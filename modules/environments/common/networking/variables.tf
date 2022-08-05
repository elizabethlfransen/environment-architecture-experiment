variable "name" {
  type        = string
  description = "name to prefix resources"
}

variable "vnet_address_range" {
  type        = string
  description = "range for environment virtual network"
}

variable "location" {
  type        = string
  description = "location for resources"
}