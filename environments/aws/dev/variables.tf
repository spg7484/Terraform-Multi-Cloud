variable "aws_account_id" {
  description = "AWS account ID for the DEV environment."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "aws_region" {
  description = "AWS region for DEV resources."
  type        = string
}

variable "project_name" {
  description = "Project identifier used for resource naming and tagging."
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
  description = "Additional AWS resource tags."
  type        = map(string)
  default     = {}
}

variable "network" {
  description = "AWS DEV network configuration."

  type = object({
    vpc_cidr                   = string
    az_count                   = number
    public_subnet_cidrs        = list(string)
    private_app_subnet_cidrs   = list(string)
    private_data_subnet_cidrs  = list(string)
    nat_gateway_mode           = string
    enable_s3_gateway_endpoint = bool
  })
}