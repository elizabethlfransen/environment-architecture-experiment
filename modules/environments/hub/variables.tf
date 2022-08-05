variable "location" {
    type = string
    description = "Location to create resources"
}

variable "spoke_network_ids" {
  type=map(string)
  description = "Map of environment to network id"
}