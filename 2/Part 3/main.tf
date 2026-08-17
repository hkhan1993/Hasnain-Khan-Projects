resource "aws_security_group" "security_internal_services" {
  name        = "internal-services"
  description = "Internal services security group"
  vpc_id      = var.vpc_id


  dynamic "ingress" {
    for_each = toset(local.deduplicated_ports_1)

    content {
      description = "Allow internal services traffic on port ${ingress.value}"  
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

}
}
  

  resource "aws_security_group" "security_external_services" {
  
    name        = "external-services"
    description = "External services security group"
    vpc_id      = var.vpc_id

    dynamic "ingress" {
        for_each = local.deduplicated_ports_2
    
        content {
            description = "Allow external services traffic on port ${ingress.value}"  
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
