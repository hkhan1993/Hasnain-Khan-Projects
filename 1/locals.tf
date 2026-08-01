locals {
  tags = merge(
    var.common_tags,
    {
      Department = var.Department
    }
  )

  docker_script_path = "${path.module}/scripts/docker.sh"

  key_name = var.create_key_pair ? aws_key_pair.MAIN_KEY_PAIR[0].key_name : data.aws_key_pair.EXISTING_KEY_PAIR[0].key_name
  
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.my_public_ip]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
