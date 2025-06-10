vpc_cidr_block = "192.168.1.0/24"

public_subnet_cidr=["192.168.1.0/26","192.168.1.128/26"]

private_subnet_cidr=["192.168.1.64/26","192.168.1.192/26"]

availability_zone=["ap-southeast-1a","ap-southeast-1b"]

vpc_name = "VPC for K8S"

ami= "ami-01938df366ac2d954"

instance_type_bastion_host= "t2.micro"
instance_type_for_k8s="t2.medium"
instance_type_for_rancher = "t2.medium"
instance_type_for_jenkins = "t2.medium"
instance_type_for_nfs = "t2.small"

key_name="harinemkey-singapore"

ip_targets=["192.168.1.111","192.168.1.112","192.168.1.113"]
target_port_for_nlb=80
target_port_for_target_group=30080
health_check_port=30080
target_port_for_nlb_attachment=30080

