# Public EC2 Security Group

resource "aws_security_group" "public_sg" {
    vpc_id = var.vpc_id

    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH from ALL IP"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"

    }

    tags = {
        Name = "${var.vpc_name}-public-ec2-sg"
    }
}

resource "aws_security_group" "private_sg" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.public_sg.id]
        description = "Allow SSH from Public EC2 Instance"
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }

     tags = {
        Name = "${var.vpc_name}-private-ec2-sg"
    }
  
}

# Ingress rule: Kubernetes API Server (6443) from self
resource "aws_security_group_rule" "k8s_api" {
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow Kubernetes API Server Access (port 6443)"
}

# Ingress rule: ETCD communication (2379–2380) from self
resource "aws_security_group_rule" "etcd" {
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2380
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow Kubernetes ETCD"
}