variable environment {
  description = "The environment for which the resources are being created"
  type        = string
  default     = "dev"
}

variable region {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable vpc_cidr {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

