variable "environment" {
  type        = string
  description = "The environment for the deployment (e.g., dev, staging, prod)."
  default     = "dev"
}

variable "external_id" {
  type        = string
  description = "The external ID used for cross-account access."
  default     = ""
}
