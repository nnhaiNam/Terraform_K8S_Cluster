resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.role_name}_InstanceProfile"
  role = var.aws_iam_role_name
}