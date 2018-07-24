resource "aws_elb" "master" {
  name     = "${var.platform_name}-master-internal"
  internal = "${var.internet_facing == "external" ? 0 : 1 }"
  subnets = [ "${split(",", var.internet_facing == "external" ? join(",", var.public_subnet_ids) : join(",", var.private_subnet_ids))}"]

  security_groups = [
    "${aws_security_group.node.id}",
  ]

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-internal"))}"

  listener {
    instance_port     = 8443
    instance_protocol = "tcp"
    lb_port           = 8443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:22"
    interval            = 30
  }
}
