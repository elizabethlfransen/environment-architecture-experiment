variable "subscription_ids" {
  type = object({
    hub = string,
    test = string,
    dev = string,
    prod = string
  })
  description = "Subscription ids for different environments"
}

variable "location" {
    type = string
    description = "Location of resources to create"
}