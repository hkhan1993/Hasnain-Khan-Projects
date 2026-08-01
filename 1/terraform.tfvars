aws_region  = "us-east-1"
vpc_cidr    = "172.16.0.0/16"
subnet_cidr = ["172.16.10.0/24", "172.16.11.0/24"]

Department = "Security"

common_tags = {
  Environment = "Dev"
  Project     = "Exercise-1"
}

create_key_pair = true

my_public_ip = "209.122.206.10/32" # Replace with your actual public IP address