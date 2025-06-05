resource "aws_eip" "nat_01" {
    domain = "vpc"
     tags = {
        Name = "nat-eip-01"
    } 
  
}

resource "aws_eip" "nat_02" {
    domain = "vpc"
    tags = {
        Name = "nat-eip-02"
    } 
  
}

resource "aws_nat_gateway" "nat_gateway-01" {
    allocation_id = aws_eip.nat_01.id
    subnet_id = var.public_subnet_id[0]
}

resource "aws_nat_gateway" "nat_gateway-02" {
    allocation_id = aws_eip.nat_02.id
    subnet_id = var.public_subnet_id[1]
}