output "resource_group_name" {
  description = "Network resource group."
  value       = azurerm_resource_group.network.name
}

output "resource_group_id" {
  description = "Network resource group ID."
  value       = azurerm_resource_group.network.id
}

output "vnet_id" {
  description = "VNet ID."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "VNet name."
  value       = azurerm_virtual_network.this.name
}

output "vnet_cidr" {
  description = "VNet CIDR."
  value       = var.vnet_cidr
}

output "aca_subnet_id" {
  description = "Container Apps infrastructure subnet ID."
  value       = azurerm_subnet.aca.id
}

output "private_endpoint_subnet_id" {
  description = "Private endpoint subnet ID."
  value       = azurerm_subnet.private_endpoints.id
}