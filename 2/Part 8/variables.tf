variable "mandatory_tags" {
  type        = map(string)
  description = "A map of mandatory tags to apply to all resources."

  default = {
    owner       = "IT Department"
    cost-center = "XXYY"
    project     = "Terraform Training"
    environment = "development"
    tier        = "0"
  }

  validation {
    condition     = length(var.mandatory_tags) > 0
    error_message = "The mandatory_tags variable cannot be an empty map."
  }

  validation {
    condition     = alltrue([for required_key in ["owner", "project", "cost-center", "environment", "tier"] : contains(keys(var.mandatory_tags), required_key)])
    error_message = "Missing Mandatory Tag Value"
  }

  validation {
    condition     = alltrue([for k, v in var.mandatory_tags : length(trimspace(lookup(var.mandatory_tags, k, ""))) > 0])
    error_message = "The mandatory_tags variable must not be empty or whitespace."
  }

  validation {
    condition     = contains(["development", "staging", "production"], lookup(var.mandatory_tags, "environment", ""))
    error_message = "The mandatory_tags variable must contain a valid environment tag - development, staging, production"
  }

  validation {
    condition     = contains(["0", "1", "2", "3", "4"], lookup(var.mandatory_tags, "tier", ""))
    error_message = "The mandatory_tags variable must contain a valid tier tag."
  }

}