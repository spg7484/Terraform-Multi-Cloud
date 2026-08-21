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