resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name        = "example-sg"
    Environment = var.environment
  }

}

/*
What do you gain here over the workspace approach that's specifically about blast radius, not just tidiness?
1. Strict IAM & Permission Boundaries
Workspaces: Every workspace (dev, prod, stage) shares the exact same S3 backend bucket and IAM role. An engineer or CI/CD runner with access to run terraform apply in dev inherently possesses the permissions to modify prod.

Directories: Because dev and prod write to distinct S3 key prefixes (ec2/dev/terraform.tfstate vs ec2/prod/terraform.tfstate), you can enforce granular IAM policies. 
Developer credentials can be restricted so they can only write to arn:aws:s3:::my-bucket/ec2/dev/*. Even if an operator accidentally attempts to target prod, AWS IAM blocks the execution at the API layer.

What's the maintenance cost of this approach as a third and fourth environment get added?
As environments scale, typing or scripting these flags across 4–5 environments increases operational friction and requires wrapper scripts (Makefiles, PowerShell scripts, or Bash scripts) to stay manageable.
If environments begin to diverge architecturally—for example, prod requires Multi-AZ Auto Scaling, Elastic Load Balancers, and strict CloudWatch alarms, while dev and qa only need a single EC2 instance—keeping a single shared main.tf forces heavy use of complex conditional logic


*/