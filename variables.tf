
variable "location" {
  type        = string
  description = "Location to create resources"
  default     = "centralus"
}


variable "billing_scope_id" {
  type        = string
  description = "Billing scope id for created subscriptions"
  default     = "/providers/Microsoft.Billing/billingAccounts/8e32ec29-6198-5953-f45c-a73777a62fa0:5e46dcf6-cd44-41d9-b81c-235eaba21720_2019-05-31/billingProfiles/ELXL-FLOB-BG7-PGB/invoiceSections/IAXD-ER7W-PJA-PGB"
}
