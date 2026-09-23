data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"] # Canonical

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "dev_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]


  tags = {
    Name = "DevServer"
  }
}

/*
PS C:\Users\Khan-\OneDrive\Documents\Terraform\Exercises\3\6> terraform plan 
data.aws_ami.amazon_linux: Reading...
data.aws_ami.amazon_linux: Read complete after 1s [id=ami-0c349b6bf2ea5c9c9]
aws_instance.dev_server: Refreshing state... [id=i-016276192b8e3a224]

No changes. Your infrastructure matches the configuration.

PS C:\Users\Khan-\OneDrive\Documents\Terraform\Exercises\3\6> terraform plan -replace="aws_instance.dev_server"
......
Plan: 1 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ server_instance_id = "i-016276192b8e3a224" -> (known after apply)
  ~ server_private_ip  = "10.128.13.108" -> (known after apply


  PS C:\Users\Khan-\OneDrive\Documents\Terraform\Exercises\3\6> terraform apply -replace="aws_instance.dev_server"
......
  Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

server_instance_id = "i-01b33d212b735709b"
server_private_ip = "10.128.13.99"
*/

/*
Why is editing main.tf with a throwaway comment or dummy tag worse than using -replace?
It Pollutes Git History
It Alters Actual AWS Metadata
Risk of Leftover Garbage: Developers frequently forget to delete temporary comments or dummy variables.
Precision Control: -replace is an imperative execution flag passed at runtime—it explicitly targets a single resource for replacement.

When would untaint (or dropping -replace) be the right move?
You would want to cancel or untaint a resource in scenarios where destroying the instance would cause catastrophic data loss or downtime
Unsaved Data on Ephemeral Storage: Have extract data manually before replacing the instance.
Emergency Service Recovery: The underlying AWS issue (like a temporary network interface freeze or stuck system process) resolved itself or was fixed out-of-band, making a full instance rebuild unnecessary.

*/