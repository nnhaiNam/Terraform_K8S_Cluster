output "vpc_id" {
    value = aws_vpc.k8s_vpc.id  
}

# output "public_subnet_id_01" {
#     value = aws_subnet.public_subnet_01.id  
# }

# output "public_subnet_id_02" {
#     value = aws_subnet.public_subnet_02.id  
# }

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_01.id,
    aws_subnet.public_subnet_02.id  
  ]
}


# output "private_subnet_id_01" {
#     value = aws_subnet.private_subnet_01.id  
# }

# output "private_subnet_id_02" {
#     value = aws_subnet.private_subnet_02.id  
# }

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_01.id,
    aws_subnet.private_subnet_02.id  
  ]
}


output "internet_gateway_id" {
    value =aws_internet_gateway.igw.id   
}

