variable "name_prefix" {
  description = "Resource naming prefix."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Networking resource group name."
  type        = string
}

variable "vnet_cidr" {
  description = "VNet address space."
  type        = string
}

variable "aca_subnet_cidr" {
  description = "Dedicated subnet for the Container Apps Environment."
  type        = string
}

variable "private_endpoint_subnet_cidr" {
  description = "Subnet reserved for Azure Private Endpoints."
  type        = string
}

variable "tags" {
  description = "Tags applied to networking resources."
  type        = map(string)
  default     = {}
}