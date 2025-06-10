variable "ip_targets" {
  description = "List of IP addresses to register in the target group"
  type        = list(string)
}

variable "target_group_arn" {
    type = string
    //aws_lb_target_group.nlb_tg.arn
  
}

variable "target_port" {
  description = "Port on which targets are listening"
  type        = number
  //default     = 80
}