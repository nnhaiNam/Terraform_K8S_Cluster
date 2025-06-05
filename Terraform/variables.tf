variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
    type = string  
}

variable "vpc_name" {
    description = "Name of VPC"
    type = string  
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



variable "ami" {
  type = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type_bastion_host" {
  type = string
  description = "Instance Type for Bastion Host" 
}

variable "instance_type_for_k8s" {
  type = string
  description = "Instance Type for Master Node 1,2,3"
}

variable "key_name" {
  type = string
  description = "Name of file PEM"  
}