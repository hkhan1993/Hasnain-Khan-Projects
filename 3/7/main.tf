resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "shared-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "shared-public-subnet"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "web-server"
  }
}


/*
What would an edge in this graph tell a reviewer that scanning the .tf files alone might not make obvious?
An edge in this graph represents a dependency or relationship between two resources in the Terraform configuration. For example, if there is an edge from the `aws_instance.web` resource to the `aws_subnet.public` resource, it indicates that the web server instance depends on the public subnet being created first. This dependency might not be immediately obvious just by scanning the .tf files, as it requires understanding how resources interact with each other and the order in which they are provisioned. Edges help reviewers visualize these relationships and understand the flow of resource creation, which is crucial for ensuring that the infrastructure is set up correctly and efficiently.
If the graph is large and tangled, what does that suggest about how the configuration needs to be split up?
Too much complexity in a single Terraform configuration can indicate that the infrastructure is becoming difficult to manage and understand. It suggests that the configuration should be split into smaller, more manageable modules. Each module can represent a specific component or service of the infrastructure, allowing for better organization, reusability, and maintainability. By breaking down the configuration into modules, you can also improve collaboration among team members and make it easier to test and deploy changes incrementally.
*/