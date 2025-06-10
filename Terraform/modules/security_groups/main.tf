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

    ingress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP requests"
    }

    ingress {
        to_port = 443
        from_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS requests"
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
        security_groups = [aws_security_group.public_sg.id,aws_security_group.sg_rancher.id]
        description = "Allow SSH from Public EC2 Instance"
    }



    ingress {
        from_port = 179
        to_port = 179
        protocol = "tcp"
        security_groups = [aws_security_group.sg_rancher.id]
        description = "Allow Calico BGP Port"
    }

    ingress {
        from_port = 2376
        to_port = 2380
        protocol = "tcp"
        security_groups = [aws_security_group.sg_rancher.id]
        description = "Node driver Docker daemon TLS port etcd client requests etcd peer communication"
    }
    ingress {
        from_port = 8443
        to_port = 8443
        protocol = "tcp"
        security_groups = [aws_security_group.sg_rancher.id]
        description = "Rancher webhook"
       
    }


    ingress{
        from_port = 30000
        to_port = 32767
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "NodePort port range"
    }

    // Rule fix pod calico not ready
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["192.168.1.0/24"] 
        description = "Allow internal traffic for Kubernetes cluster"
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


resource "aws_security_group" "sg_rancher" {

    vpc_id = var.vpc_id

    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH from ALL IP"
    }

    ingress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP requests"
    }

    ingress {
        to_port = 443
        from_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS requests"
    }

    ingress {
        from_port = 6443
        to_port = 6444
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Kubernetes API server"
    }

    ingress {
        from_port = 10250
        to_port = 10250
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Kubelet"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }


     tags = {
        Name = "${var.vpc_name}-rancher-server-sg"
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

resource "aws_security_group_rule" "k8s_api_public" {
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.public_sg.id
  description              = "Allow Kubernetes API Server Access (port 6443) for public subnet"
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

# Ingress rule: Communication with all nodes API (10250-10254) from self
resource "aws_security_group_rule" "api_node" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10254
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Communication with all nodes API"
}

resource "aws_security_group_rule" "api_rancher" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10254
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.sg_rancher.id
  description              = "Metrics server communication with all nodes API"
}


resource "aws_security_group" "sg_jenkins" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH"
    }

    ingress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP requests"
    }

    ingress {
        to_port = 8080
        from_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        to_port = 443
        from_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS requests"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }


     tags = {
        Name = "${var.vpc_name}-jenkins-server-sg"
    }
  
}

resource "aws_security_group" "sg_nfs" {
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.public_sg.id]
        description = "Allow SSH for instance in public subnet"
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }

     tags = {
        Name = "${var.vpc_name}-nfs-server-sg"
    }
  
}


///
resource "aws_security_group_rule" "nfs_to_private_nfsd" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.sg_nfs.id
  description              = "Allow NFSD from NFS SG to private EC2"
}

resource "aws_security_group_rule" "nfs_to_private_rpc_tcp" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.sg_nfs.id
  description              = "Allow RPC (TCP) from NFS SG to private EC2"
}

resource "aws_security_group_rule" "nfs_to_private_rpc_udp" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "udp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.sg_nfs.id
  description              = "Allow RPC (UDP) from NFS SG to private EC2"
}

//
resource "aws_security_group_rule" "allow_private_to_sg_nfs_2049" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_nfs.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow NFS access from private_sg"
}

resource "aws_security_group_rule" "allow_private_to_sg_nfs_rpc_tcp" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_nfs.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow RPC  (TCP) access from private_sg"
}

resource "aws_security_group_rule" "allow_private_to_sg_nfs_rpc_udp" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "udp"
  security_group_id        = aws_security_group.sg_nfs.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow RPC (UDP) access from private_sg"
}