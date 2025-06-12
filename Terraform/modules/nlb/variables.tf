variable "subnet_ids" {
    description = "List of subnets IDs for the NLB"
    type = list(string)
}

variable "target_port_http" {
    description = "Port on which targets are listening"
    type        = number

}

variable "target_port_https" {
    description = "Port on which targets are listening"
    type        = number
}

variable "aws_lb_target_group_http" {
    type = string
    //aws_lb_target_group.nlb_tg.arn
  
}
variable "aws_lb_target_group_https" {
    type = string
    //aws_lb_target_group.nlb_tg.arn
  
}

