resource "aws_lb" "nlb" {
    name = "NLB"
    internal = false
    load_balancer_type = "network"
    subnets = var.subnet_ids
    tags = {
        Name="NLB"
    }
  
}

resource "aws_lb_listener" "nlb_listener" {
    load_balancer_arn = aws_lb.nlb.arn
    port = var.target_port
    protocol = "TCP"
    default_action {
        type             = "forward"
        target_group_arn = var.aws_lb_target_group
    }
}
