variable environment {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable instance_type {
  description = "The type of instance to use for the deployment"
  type        = string
  default     = "t2.micro"
}