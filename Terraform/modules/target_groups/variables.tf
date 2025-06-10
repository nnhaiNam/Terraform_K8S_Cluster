variable "target_port" {
    description = "Port on which targets are listening"
    type        = number
}

variable "protocol" {
    description = "Protocol for target group"
    type        = string
}

variable "vpc_id" {
    type = string
    description = "VPC ID"
  
}

variable "target_type" {
    type = string
    description = "Target type for target group"
  
}

variable "health_check_port" {
  description = "Port to use for health check"
  type        = string
}

variable "name" {
    type = string
  
}