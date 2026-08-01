output "vpc_id" {
  value       = aws_vpc.MAIN_VPC.id
  description = "The ID of the VPC"
}

output "subnet_ids" {
  value       = aws_subnet.MAIN_Subnet[*].id
  description = "The IDs of the subnets"
}

output "security_group_id" {
  value       = aws_security_group.MAIN_SG.id
  description = "The ID of the security group"
}

output "ec2_instance_ids" {
  value       = [for instance in aws_instance.MAIN_EC2 : instance.id]
  description = "The IDs of the EC2 instances"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.MAIN_IGW.id
  description = "The ID of the Internet Gateway"
}

output "ec2_public_ips" {
  value       = [for instance in aws_instance.MAIN_EC2 : instance.public_ip]
  description = "The public IP addresses of the EC2 instances"
}

output "ec2_private_ips" {
  value       = [for instance in aws_instance.MAIN_EC2 : instance.private_ip]
  description = "The private IP addresses of the EC2 instances"
}

