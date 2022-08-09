variable "location" {
    type = string
    description = "Location of resources to create"
}

variable "name" {
    type = string
    description = "Name of environment"
}

variable "vnet_network_index" {
  type = number
  description = "index to use for address spacing, each vnet should be unique"
}

variable "hub_vnet_id" {
    type = string
    description = "Network id for hub network"
}