module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.environment}-ec2"
  instance_type = var.instance_type
  ami = data.aws_ami.latest_amazon_linux.id
  version = "~>5.0"
  
  subnet_id = data.terraform_remote_state.VPC.outputs.public_subnet_ids[0]
  iam_instance_profile = data.terraform_remote_state.IAM.outputs.app_instance_profile_name
  
  tags = {
    Name        = "${var.environment}-ec2"
    Environment = var.environment
    Terraform   = "true"
  }

}