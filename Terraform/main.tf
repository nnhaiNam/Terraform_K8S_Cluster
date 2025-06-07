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

#EC2

module "bastion_host" {
    source = "./modules/ec2"
    ami = var.ami
    instance_type = var.instance_type_bastion_host
    subnet_id = module.vpc.public_subnet_ids[0]
    security_group_ids = [module.security_groups.public_sg_id]
    key_name = var.key_name
    instance_name = "Bastion Host"
    iam_instance_profile=""
    associate_public_ip = true

  
}

####### K8s cluster ###########

module "master_node_01" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_k8s
  subnet_id=module.vpc.private_subnet_ids[0]
  security_group_ids=[module.security_groups.private_sg_id]
  key_name=var.key_name
  instance_name="Master Node 01"
  associate_public_ip=false  
  private_ip = "192.168.1.111"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-master-01.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-k8s.sh")
    master_script  = file("${path.module}/scripts/master-01.sh")
  })  

}

module "master_node_02" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_k8s
  subnet_id=module.vpc.private_subnet_ids[0]
  security_group_ids=[module.security_groups.private_sg_id]
  key_name=var.key_name
  instance_name="Master Node 02"
  associate_public_ip=false
  private_ip = "192.168.1.112"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-master-02.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-k8s.sh")
    master_script  = file("${path.module}/scripts/master-02.sh")
  })

}

module "master_node_03" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_k8s
  subnet_id=module.vpc.private_subnet_ids[0]
  security_group_ids=[module.security_groups.private_sg_id]
  key_name=var.key_name
  instance_name="Master Node 03"
  associate_public_ip=false
  private_ip = "192.168.1.113"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-master-03.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-k8s.sh")
    master_script  = file("${path.module}/scripts/master-03.sh")
  })
}

######## LB cluster ##########

module "load_balancer_01" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_load_balancer
  subnet_id=module.vpc.public_subnet_ids[0]
  security_group_ids=[module.security_groups.public_sg_id]
  key_name=var.key_name
  instance_name="Load Balancer 01"
  associate_public_ip=true  
  private_ip = "192.168.1.109"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-load_balancer-01.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-load_balancer.sh")
    master_script  = file("${path.module}/scripts/load_balancer-01.sh")
  })  
}

module "load_balancer_02" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_load_balancer
  subnet_id=module.vpc.public_subnet_ids[0]
  security_group_ids=[module.security_groups.public_sg_id]
  key_name=var.key_name
  instance_name="Load Balancer 02"
  associate_public_ip=true  
  private_ip = "192.168.1.110"
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-load_balancer-02.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-load_balancer.sh")
    master_script  = file("${path.module}/scripts/load_balancer-02.sh")
  })  
}

######### Jenkins server ##########

module "jenkins" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_load_balancer
  subnet_id=module.vpc.public_subnet_ids[0]
  security_group_ids=[module.security_groups.public_sg_id]
  key_name=var.key_name
  instance_name="Jenkins"
  associate_public_ip=true
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-jenkins.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-jenkins.sh")
    master_script  = file("${path.module}/scripts/jenkins.sh")
  })  
}

########### Rancher server ############

module "rancher" {
  source = "./modules/ec2"
  ami=var.ami
  instance_type=var.instance_type_for_load_balancer
  subnet_id=module.vpc.public_subnet_ids[0]
  security_group_ids=[module.security_groups.public_sg_id]
  key_name=var.key_name
  instance_name="Rancher"
  associate_public_ip=true
  iam_instance_profile=module.iam_instance_profile.instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-rancher.tpl", {
    install_script = file("${path.module}/scripts/install-core-components-rancher.sh")
    master_script  = file("${path.module}/scripts/rancher.sh")
  })  
}