resource "aws_security_group" "node" {
  count       = "${length(var.cluster_internal_security_group_ids) != 0 ? 0 : 1}"
  name        = "${var.platform_name}-node"
  description = "Cluster node group for ${var.platform_name}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.platform_cidr}"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map(
    "Name", "${var.platform_name}-node",
    "KubernetesCluster", "${var.platform_name}"
  ))}"

  vpc_id = "${var.platform_vpc_id}"
}
