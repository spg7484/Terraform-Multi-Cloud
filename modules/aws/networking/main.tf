data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

locals {
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    var.az_count
  )

  subnets = {
    for index, az in local.availability_zones : az => {
      public_cidr       = var.public_subnet_cidrs[index]
      private_app_cidr  = var.private_app_subnet_cidrs[index]
      private_data_cidr = var.private_data_subnet_cidrs[index]
    }
  }

  nat_availability_zones = (
    var.nat_gateway_mode == "single"
    ? toset([local.availability_zones[0]])
    : var.nat_gateway_mode == "per_az"
    ? toset(local.availability_zones)
    : toset([])
  )
}

# -------------------------------------------------------------------
# VPC
# -------------------------------------------------------------------

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

# -------------------------------------------------------------------
# Internet Gateway
# -------------------------------------------------------------------

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

# -------------------------------------------------------------------
# Public Subnets
# -------------------------------------------------------------------

resource "aws_subnet" "public" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.public_cidr
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-${each.key}"
      Tier = "public"
    }
  )
}

# -------------------------------------------------------------------
# Private Application Subnets
#
# ECS/Fargate tasks will eventually run here.
# -------------------------------------------------------------------

resource "aws_subnet" "private_app" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.private_app_cidr
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-app-${each.key}"
      Tier = "application"
    }
  )
}

# -------------------------------------------------------------------
# Private Data Subnets
#
# Future RDS/ElastiCache/etc.
# These deliberately do NOT receive an Internet/NAT default route.
# -------------------------------------------------------------------

resource "aws_subnet" "private_data" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.private_data_cidr
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-data-${each.key}"
      Tier = "data"
    }
  )
}

# -------------------------------------------------------------------
# Public Routing
# -------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-rt"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# -------------------------------------------------------------------
# NAT Gateway
#
# DEV:
#   single NAT Gateway
#
# PROD later:
#   one NAT Gateway per AZ
# -------------------------------------------------------------------

resource "aws_eip" "nat" {
  for_each = local.nat_availability_zones

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-eip-${each.key}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_availability_zones

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-${each.key}"
    }
  )

  depends_on = [
    aws_internet_gateway.this
  ]
}

# -------------------------------------------------------------------
# Private Application Route Tables
# -------------------------------------------------------------------

resource "aws_route_table" "private_app" {
  for_each = local.subnets

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-app-rt-${each.key}"
    }
  )
}

resource "aws_route" "private_app_internet" {
  for_each = var.nat_gateway_mode == "none" ? {} : local.subnets

  route_table_id         = aws_route_table.private_app[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = (
    var.nat_gateway_mode == "single"
    ? aws_nat_gateway.this[local.availability_zones[0]].id
    : aws_nat_gateway.this[each.key].id
  )
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app[each.key].id
}

# -------------------------------------------------------------------
# Private Data Route Tables
# -------------------------------------------------------------------

resource "aws_route_table" "private_data" {
  for_each = local.subnets

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-data-rt-${each.key}"
    }
  )
}

resource "aws_route_table_association" "private_data" {
  for_each = aws_subnet.private_data

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_data[each.key].id
}

# -------------------------------------------------------------------
# S3 Gateway Endpoint
#
# No NAT Gateway is required for traffic from these private
# subnets to S3.
# -------------------------------------------------------------------

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_gateway_endpoint ? 1 : 0

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    [
      for rt in aws_route_table.private_app :
      rt.id
    ],
    [
      for rt in aws_route_table.private_data :
      rt.id
    ]
  )

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-s3-endpoint"
    }
  )
}