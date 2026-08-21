variable "location" {
  description = "Azure region for Terraform state resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing Terraform state resources."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name. 3-24 lowercase alphanumeric characters."
  type        = string
}

variable "container_name" {
  description = "Blob container name used for Terraform state."
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Common tags applied to bootstrap resources."
  type        = map(string)
  default     = {}
}
