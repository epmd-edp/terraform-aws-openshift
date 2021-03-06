resource "aws_security_group" "master_public" {
  count       = "${length(var.master_public_security_group_ids) != 0 ? 0 : 1}"
  name        = "${var.platform_name}-master-public"
  description = "Master public group for ${var.platform_name}"

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.operator_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-master-public"))}"

  vpc_id = "${var.platform_vpc_id}"
}
