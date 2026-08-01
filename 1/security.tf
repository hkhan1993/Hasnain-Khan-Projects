resource "aws_security_group" "MAIN_SG" {
  name        = "MAIN_SG"
  description = "Security group for MAIN_VPC"
  vpc_id      = aws_vpc.MAIN_VPC.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = local.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }


  tags = merge(local.tags, { Name = "MAIN_SG" })
}
