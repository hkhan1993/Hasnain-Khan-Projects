variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet."
  type        = list(string)
}

variable "common_tags" {
  description = "A map of common tags to apply to all resources."
  type        = map(string)
}

variable "Department" {
  description = "The department name for tagging resources."
  type        = string
}

variable "my_public_ip" {
  description = "Your public IP address for security group rules."
  type        = string
}

variable "create_key_pair" {
  description = "Set to true to generate a new key pair, or false to use an existing AWS key pair."
  type        = bool
  default     = true

}