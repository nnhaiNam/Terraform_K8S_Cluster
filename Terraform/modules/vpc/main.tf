#VPC
resource "aws_vpc" "k8s_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name=var.vpc_name
    }  
}

#Public Subnet
resource "aws_subnet" "public_subnet_01"{
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = var.public_subnet_cidr[0]
    availability_zone = var.availability_zone[0]
    map_public_ip_on_launch = true

    tags = {
        Name= "${var.vpc_name}-public-subnet-01"
    }

}

resource "aws_subnet" "public_subnet_02"{
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = var.public_subnet_cidr[1]
    availability_zone = var.availability_zone[1]
    map_public_ip_on_launch = true

    tags = {
        Name="${var.vpc_name}-public-subnet-02"
    }

}

#Private Subnet
resource "aws_subnet" "private_subnet_01" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block=var.private_subnet_cidr[0]
    availability_zone = var.availability_zone[0]
    map_public_ip_on_launch = false

    tags = {
        Name="${var.vpc_name}-private-subnet-01"
    }
      
}

resource "aws_subnet" "private_subnet_02" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block=var.private_subnet_cidr[1]
    availability_zone = var.availability_zone[1]
    map_public_ip_on_launch = false

    tags = {
        Name="${var.vpc_name}-private-subnet-02"
    }
  
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.k8s_vpc.id

    tags = {
        Name = "${var.vpc_name}-IGW"
    }
  
}