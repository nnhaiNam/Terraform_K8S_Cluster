variable "subnet_ids" {
    description = "List of subnets IDs for the NLB"
    type = list(string)
}

variable "target_port" {
    description = "Port on which targets are listening"
    type        = number
    default     = 80
}

variable "aws_lb_target_group" {
    type = string
    //aws_lb_target_group.nlb_tg.arn
  
}
