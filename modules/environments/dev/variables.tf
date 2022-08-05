variable "vnet_address_range" {
  type        = string
  description = "range for environment virtual network"
}

variable "name" {
  type        = string
  description = "name to prefix resources"
}

variable "location" {
  type        = string
  description = "location for resources"
}


variable "hub_network_id" {
    type = string
    description = "Network id of hub network"
}