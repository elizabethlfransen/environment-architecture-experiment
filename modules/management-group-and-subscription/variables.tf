variable "environment_name" {
  type        = string
  description = "Environment Name"
}

variable "environment_id" {
  type        = string
  description = "Environment id to use for child resources"
}

variable "parent_management_group_id" {
  type        = string
  description = "Parent management group"
}

variable "billing_scope_id" {
  type        = string
  description = "Billing scope id to use to create subscription"
}
