variable "cidr_block" {
    type = string
    description = "CIDR block for the VPC"  
}

variable "vpc_name" {
    type = string
    description = "Name of VPC"
  
}

variable "public_subnet_cidr" {
    type = list(string)
    description = "CIDR block for the public subnet"
  
}

variable "availability_zone" {
    type  = list(string) 
    description = "Availability Zones"     
}


variable "private_subnet_cidr" {
    type = list(string)
    description = "CIDR block for the private subnet"  
}

