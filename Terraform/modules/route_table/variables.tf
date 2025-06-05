variable "vpc_id" {
    type = string
    description = "VPC ID"  
}

variable "internet_gateway_id" {
  type        = string
  description = "Internet Gateway ID"
}

variable "nat_gateway_id" {
   type        = list(string)
   description = "List of NAT Gateway IDs for private route tables"
  
}

variable "public_subnet_id" {
   type        = list(string)
   description = "List Public Subnet ID"
  
}

variable "private_subnet_id" {
   type        = list(string)
   description = "List Private Subnet ID"
  
}