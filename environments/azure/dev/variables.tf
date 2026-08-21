variable "subscription_id" {
  description = "Azure subscription ID for DEV."
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "location" {
  description = "Primary Azure location for DEV resources."
  type        = string
}

variable "project_name" {
  description = "Project identifier used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "environment must be dev, uat, or prod."
  }
}

variable "owner" {
  description = "Team responsible for the infrastructure."
  type        = string
}

variable "additional_tags" {
  description = "Additional Azure resource tags."
  type        = map(string)
  default     = {}
}