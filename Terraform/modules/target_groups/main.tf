resource "aws_lb_target_group" "nlb_tg" {
    name =var.name
    port=var.target_port
    protocol = var.protocol
    vpc_id = var.vpc_id
    target_type = var.target_type

    health_check {
      protocol = "TCP"
      port = var.health_check_port
      interval = 10
      healthy_threshold = 3
      unhealthy_threshold = 3
      timeout = 5
    }
  
}