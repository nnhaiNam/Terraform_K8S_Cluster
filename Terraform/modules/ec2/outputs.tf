# EC2 instance ID
output "instance_id" {
  value       = aws_instance.ec2.id
  description = "The ID of the EC2 instance"
}

# Public IP
output "public_ip" {
  value       = aws_instance.ec2.associate_public_ip_address ? aws_instance.ec2.public_ip : ""
  description = "The public IP of the EC2 instance"
}

# Private IP
output "private_ip" {
  value       = aws_instance.ec2.private_ip
  description = "The private IP of the EC2 instance"
}