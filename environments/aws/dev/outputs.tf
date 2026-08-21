output "aws_account_id" {
  description = "AWS account currently used by Terraform."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS DEV region."
  value       = var.aws_region
}

output "environment" {
  description = "Current environment."
  value       = var.environment
}

output "name_prefix" {
  description = "Standard resource naming prefix."
  value       = local.name_prefix
}

output "common_tags" {
  description = "Common AWS tags."
  value       = local.common_tags
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "availability_zones" {
  value = module.networking.availability_zones
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.networking.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  value = module.networking.private_data_subnet_ids
}

output "nat_gateway_ids" {
  value = module.networking.nat_gateway_ids
}