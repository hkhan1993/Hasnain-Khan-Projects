data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "terraform_remote_state" "VPC" {
  backend = "s3"
  config = {
    bucket = "statefilebucket1234567"
    key    = "Exercise3-4/VPC/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "IAM" {
  backend = "s3"
  config = {
    bucket = "statefilebucket1234567"
    key    = "Exercise3-4/IAM/terraform.tfstate"
    region = "us-east-1"
  }
}