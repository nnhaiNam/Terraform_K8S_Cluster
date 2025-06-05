variable "ami" {
    type = string
    description = "The AMI ID for the EC2 instance"  
}

variable "instance_type" {
  description = "The instance type (e.g., t2.micro)"
  type        = string  
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the EC2 instance"
  type        = string
  
}


variable "security_group_ids" {
  description = "The IDs of the security groups to attach to the EC2 instance"
  type        = list(string)
}

variable "key_name" {
  type = string
  description = "The name of SSH file pem"
}

variable "instance_name" {
    type = string
    description = "The name of instance"
  
}

variable "associate_public_ip" {
    type = bool
    description = "To determine public instance"
  
}

variable "private_ip" {
  description = "Static private IP address for the instance"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script"
  type        = string
  default = ""
}

variable "iam_instance_profile" {
  description = "Name of IAM instance profile"
  type        = string
}
