# EC2 instance
resource "aws_instance" "ec2" {
    ami=var.ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_group_ids
    key_name = var.key_name
    private_ip = var.private_ip 
    user_data = var.user_data
    iam_instance_profile = var.iam_instance_profile
    tags = {
        Name=var.instance_name
    }
    root_block_device {
      volume_size = var.volume_size
      volume_type = "gp3"
      delete_on_termination = true
    }
}

# Elastic IP for Public EC2 instance
resource "aws_eip" "public_eip" {
  count    = var.associate_public_ip ? 1 : 0
  instance = aws_instance.ec2.id
}