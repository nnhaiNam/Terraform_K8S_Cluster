resource "aws_lb_target_group_attachment" "ip_attachments" {
    for_each = toset(var.ip_targets)
    target_group_arn = var.target_group_arn
    target_id        = each.value
    port = var.target_port  
}