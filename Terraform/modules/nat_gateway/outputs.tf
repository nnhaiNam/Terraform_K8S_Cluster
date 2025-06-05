# output "nat_gateway_id_01" {
#   value = aws_nat_gateway.nat_gateway-01.id
# }

# output "nat_gateway_id_02" {
#   value = aws_nat_gateway.nat_gateway-02.id
# }

output "nat_gateway_ids" {
  value = [
    aws_nat_gateway.nat_gateway-01.id,
    aws_nat_gateway.nat_gateway-02.id
  ]
}


# Output for Elastic IP assigned to the NAT Gateway
output "nat_gateway_eip-01" {
  value = aws_eip.nat_01.public_ip
}

output "nat_gateway_eip-02" {
  value = aws_eip.nat_02.public_ip
}