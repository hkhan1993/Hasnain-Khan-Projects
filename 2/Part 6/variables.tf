variable "env" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "The environment must be one of: dev, staging, prod."
  }

}

variable "subnet_id" {
  description = "The ID of the subnet where the instance will be launched"
  type        = string
}