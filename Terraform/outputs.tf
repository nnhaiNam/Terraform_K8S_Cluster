output "vpc_id" {
  description = "ID of VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
  description = "ID of Public Subnet"
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
  description = "ID of Private Subnet"
}


output "internet_gateway_id" {
  description = "ID of Internet Gateway"
  value       = module.vpc.internet_gateway_id
}
