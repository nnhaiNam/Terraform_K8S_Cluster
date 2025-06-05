resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.internet_gateway_id
    }
  
}

resource "aws_route_table" "private_rt_01" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = var.nat_gateway_id[0]
    }
  
}

resource "aws_route_table" "private_rt_02" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = var.nat_gateway_id[1]
    }
  
}

resource "aws_route_table_association" "public_rt_association_01" {
    subnet_id = var.public_subnet_id[0]
    route_table_id=aws_route_table.public_rt.id  
}

resource "aws_route_table_association" "public_rt_association_02" {
    subnet_id = var.public_subnet_id[1]
    route_table_id=aws_route_table.public_rt.id  
}

resource "aws_route_table_association" "private_rt_association_01" {
    subnet_id = var.private_subnet_id[0]
    route_table_id = aws_route_table.private_rt_01.id
}

resource "aws_route_table_association" "private_rt_association_02" {
    subnet_id = var.private_subnet_id[1]
    route_table_id = aws_route_table.private_rt_02.id
}