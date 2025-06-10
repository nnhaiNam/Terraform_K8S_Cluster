resource "aws_ebs_volume" "data_volume" {
    availability_zone = var.availability_zone
    size              = 15
    type              = "gp3"
    tags = {
        Name = var.ebs_name
    }
  
}

