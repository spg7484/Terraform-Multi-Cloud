output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR."
  value       = aws_vpc.this.cidr_block
}

output "availability_zones" {
  description = "Availability Zones used by the VPC."
  value       = local.availability_zones
}

output "public_subnet_ids" {
  description = "Public subnet IDs by Availability Zone."

  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs by Availability Zone."

  value = {
    for az, subnet in aws_subnet.private_app :
    az => subnet.id
  }
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs by Availability Zone."

  value = {
    for az, subnet in aws_subnet.private_data :
    az => subnet.id
  }
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs."

  value = {
    for az, nat in aws_nat_gateway.this :
    az => nat.id
  }
}

output "s3_vpc_endpoint_id" {
  description = "S3 Gateway VPC endpoint ID."
  value       = try(aws_vpc_endpoint.s3[0].id, null)
}