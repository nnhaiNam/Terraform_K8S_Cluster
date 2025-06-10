resource "aws_volume_attachment" "volume_data_attachment" {
    device_name = "/dev/xvdb"
    volume_id = var.volume_id
    instance_id = var.instance_id
}