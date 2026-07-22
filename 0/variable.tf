
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1" # You can change this default value as needed
}

variable "instance_type" {
  description = "The size of the EC2 instance to launch"
  type        = string
  default     = "t2.micro" # You can change this default value as needed
}


variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where resources will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to associate with resources"
  type        = string
}
