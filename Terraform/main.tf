#VPC
module "vpc" {
    source = "./modules/vpc"
    cidr_block = var.vpc_cidr_block
    vpc_name= var.vpc_name
    public_subnet_cidr=var.public_subnet_cidr
    availability_zone=var.availability_zone
    private_subnet_cidr=var.private_subnet_cidr
}

#Nat Gateway
module "nat_gateway" {
    source = "./modules/nat_gateway"
    public_subnet_id=module.vpc.public_subnet_ids
  
}

#Route Table
module "route_tables" {
    source = "./modules/route_table"
    vpc_id=module.vpc.vpc_id
    internet_gateway_id=module.vpc.internet_gateway_id
    nat_gateway_id=module.nat_gateway.nat_gateway_ids
    public_subnet_id=module.vpc.public_subnet_ids
    private_subnet_id=module.vpc.private_subnet_ids
  
}

#SCG
module "security_groups" {
    source = "./modules/security_groups"
    vpc_id=module.vpc.vpc_id
    vpc_name=var.vpc_name
}


#Policy
module "policy" {
  source = "./modules/policy"  
}

#IAM ROLE
module "iam_role" {
  source = "./modules/iam_role"
  aws_iam_policy=module.policy.aws_iam_policy
  
}

#IAM_INSTANCE_PROFILE
module "iam_instance_profile" {
  source = "./modules/iam_instance_profile"
  role_name="EC2SSMRole"
  aws_iam_role_name=module.iam_role.aws_iam_role_name

  
}


#EC2 Master Node 01
module "master_node_01" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_k8s
  subnet_id=module.vpc.private_subnet_ids[0]
  security_group_ids=[module.security_groups.private_sg_id]
  key_name=var.key_name
  volume_size=20
  instance_name="Master Node 01"
  associate_public_ip=false  
  private_ip = "192.168.1.111"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-master-01.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-k8s.sh")
    master_script  = file("${path.module}/scripts/master-01.sh")
  })  

}

#EC2 Master Node 02
module "master_node_02" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_k8s
  subnet_id=module.vpc.private_subnet_ids[0]
  security_group_ids=[module.security_groups.private_sg_id]
  key_name=var.key_name
  volume_size = 20
  instance_name="Master Node 02"
  associate_public_ip=false
  private_ip = "192.168.1.112"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-master-02.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-k8s.sh")
    master_script  = file("${path.module}/scripts/master-02.sh")
  })

}

#EC2 Master Node 03
module "master_node_03" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_k8s
  subnet_id=module.vpc.private_subnet_ids[0]
  security_group_ids=[module.security_groups.private_sg_id]
  key_name=var.key_name
  volume_size = 20
  instance_name="Master Node 03"
  associate_public_ip=false
  private_ip = "192.168.1.113"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-master-03.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-k8s.sh")
    master_script  = file("${path.module}/scripts/master-03.sh")
  })
}

#EC2 Rancher
module "rancher_server"{
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type_for_rancher
  subnet_id = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security_groups.sg_rancher_id]
  key_name = var.key_name
  volume_size = 20
  instance_name = "Rancher Server"
  associate_public_ip = true
  iam_instance_profile=""
  user_data = templatefile("${path.module}/scripts/rancher-server.sh", {})
}


#EBS_VOLUME FOR RANCHER
module "ebs_rancher_data" {
  source = "./modules/ebs_volume"
  ebs_name="rancher_data"
  availability_zone = var.availability_zone[0]  
}

#ATTACH_EBS FOR RANCHER
module "ebs_rancher_attachment" {
  source = "./modules/ebs_volume_attachment"
  volume_id = module.ebs_rancher_data.volume_id
  instance_id = module.rancher_server.instance_id
}


#EC2 Jenkins
module "jenkins_server" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type_for_jenkins
  subnet_id = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security_groups.sg_jenkins_id]
  key_name = var.key_name
  volume_size = 10
  instance_name = "Jenkins Server"
  associate_public_ip=true
  iam_instance_profile = ""
  user_data =  templatefile("${path.module}/scripts/jenkins-server.sh", {}) 
}

#EC2 NFS-Server
module "nfs_server" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type_for_nfs
  subnet_id=module.vpc.private_subnet_ids[0]
  security_group_ids = [module.security_groups.sg_nfs_id]
  key_name=var.key_name
  volume_size = 15
  instance_name="NFS Server"
  associate_public_ip=false
  private_ip = "192.168.1.120"
  iam_instance_profile=""
  user_data = templatefile("${path.module}/scripts/nfs-server.sh", {}) 
  
}

#EBS_VOLUME FOR NFS
module "ebs_nfs_data" {
  source = "./modules/ebs_volume"
  ebs_name="nfs_data"
  availability_zone = var.availability_zone[0]  
}

#ATTACH_EBS FOR NFS
module "ebs_nfs_attachment" {
  source = "./modules/ebs_volume_attachment"
  volume_id = module.ebs_nfs_data.volume_id
  instance_id = module.nfs_server.instance_id
}


#EC2 Bastio Host
module "bastion_host" {
    source = "./modules/ec2"
    ami = var.ami
    instance_type = var.instance_type_bastion_host
    subnet_id = module.vpc.public_subnet_ids[0]
    security_group_ids = [module.security_groups.public_sg_id]
    key_name = var.key_name
    volume_size=10
    instance_name = "Bastion Host"
    iam_instance_profile=""
    associate_public_ip = false 
}

#Target group for NLB
module "target_group_http" {
  source = "./modules/target_groups"
  name = "Target-Group-HTTP"
  protocol="TCP"
  vpc_id=module.vpc.vpc_id
  target_type = "ip"
  target_port = var.target_port_for_target_group
  health_check_port=var.health_check_port
  
}


#Network LoadBalancer
module "nlb" {
  source = "./modules/nlb"
  subnet_ids = module.vpc.public_subnet_ids
  target_port = var.target_port_for_nlb
  aws_lb_target_group = module.target_group_http.target_group_arn
  
}

#Attachment NLB and Target Groups
module "lb_target_groups_attachment" {
  source = "./modules/lb_target_groups_attachment"
  ip_targets = var.ip_targets
  target_group_arn=module.target_group_http.target_group_arn
  target_port=var.target_port_for_nlb_attachment
}



