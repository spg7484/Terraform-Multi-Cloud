output "subscription_id" {
  description = "Azure subscription currently used by Terraform."
  value       = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
  description = "Microsoft Entra tenant currently used by Terraform."
  value       = data.azurerm_client_config.current.tenant_id
}

output "location" {
  description = "Azure DEV location."
  value       = var.location
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
  description = "Common Azure tags."
  value       = local.common_tags
}

output "network_resource_group_name" {
  value = module.networking.resource_group_name
}

output "vnet_id" {
  value = module.networking.vnet_id
}

output "vnet_name" {
  value = module.networking.vnet_name
}

output "aca_subnet_id" {
  value = module.networking.aca_subnet_id
}

output "private_endpoint_subnet_id" {
  value = module.networking.private_endpoint_subnet_id
}