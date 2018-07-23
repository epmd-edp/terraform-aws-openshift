resource "aws_security_group" "platform_public" {
  name = "${var.platform_name}-platform-public"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.public_access_cidrs}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.public_access_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.platform_vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-platform-public"))}"
}

resource "aws_security_group" "infra_node" {
  name        = "${var.platform_name}-infra-node"
  description = "Infra node group for ${var.platform_name}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.platform_public.id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.platform_public.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "${var.platform_name}-infra-node"))}"

  vpc_id = "${var.platform_vpc_id}"
}
