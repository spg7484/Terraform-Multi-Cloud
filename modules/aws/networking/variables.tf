variable "name_prefix" {
  description = "Prefix used for networking resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range assigned to the VPC."
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones."
  type        = number
  default     = 3

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be between 2 and 3."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets, one per Availability Zone."
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDRs for private application/ECS subnets."
  type        = list(string)
}

variable "private_data_subnet_cidrs" {
  description = "CIDRs for isolated data subnets."
  type        = list(string)
}

variable "nat_gateway_mode" {
  description = "NAT Gateway strategy: none, single, or per_az."
  type        = string
  default     = "single"

  validation {
    condition = contains(
      ["none", "single", "per_az"],
      var.nat_gateway_mode
    )

    error_message = "nat_gateway_mode must be none, single, or per_az."
  }
}

variable "enable_s3_gateway_endpoint" {
  description = "Create an S3 Gateway VPC endpoint."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to networking resources."
  type        = map(string)
  default     = {}
}