resource "aws_instance" "env_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = lookup(local.env_instance_type, var.env, "t2.micro")
  subnet_id     = var.subnet_id
  monitoring = var.env == "prod" ? true : false

    tags = {
    Name        = "${var.env}-instance"
    }

}