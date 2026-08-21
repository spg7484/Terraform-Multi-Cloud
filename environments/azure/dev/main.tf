module "networking" {
  source = "../../../modules/azure/networking"

  name_prefix = local.name_prefix

  location            = var.location
  resource_group_name = var.network.resource_group_name

  vnet_cidr = var.network.vnet_cidr

  aca_subnet_cidr = var.network.aca_subnet_cidr

  private_endpoint_subnet_cidr = var.network.private_endpoint_subnet_cidr

  tags = local.common_tags
}