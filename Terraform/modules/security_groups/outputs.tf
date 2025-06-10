output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

output "sg_rancher_id" {
  value = aws_security_group.sg_rancher.id
  
}

output "sg_jenkins_id" {
  value = aws_security_group.sg_jenkins.id  
}

output "sg_nfs_id" {
  value = aws_security_group.sg_nfs.id  
}