module "networking" {
  source = "../../../modules/aws/networking"

  name_prefix = local.name_prefix

  vpc_cidr = var.network.vpc_cidr
  az_count = var.network.az_count

  public_subnet_cidrs       = var.network.public_subnet_cidrs
  private_app_subnet_cidrs  = var.network.private_app_subnet_cidrs
  private_data_subnet_cidrs = var.network.private_data_subnet_cidrs

  nat_gateway_mode = var.network.nat_gateway_mode

  enable_s3_gateway_endpoint = var.network.enable_s3_gateway_endpoint

  tags = local.common_tags
}