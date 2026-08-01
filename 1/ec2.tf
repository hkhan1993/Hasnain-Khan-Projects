resource "aws_instance" "MAIN_EC2" {
  for_each               = { for idx, subnet in aws_subnet.MAIN_Subnet : idx => subnet }
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = each.value.id
  key_name               = local.key_name
  vpc_security_group_ids = [aws_security_group.MAIN_SG.id]
  tags                   = merge(local.tags, { Name = "MAIN_EC2-${each.key}" })
  user_data              = file(local.docker_script_path)

  depends_on = [aws_subnet.MAIN_Subnet, aws_security_group.MAIN_SG]
}
