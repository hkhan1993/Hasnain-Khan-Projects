data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }

}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_key_pair" "EXISTING_KEY_PAIR" {
  count    = var.create_key_pair ? 0 : 1
  key_name = "MAIN_KEY_PAIR"
}