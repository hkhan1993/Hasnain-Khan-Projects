variable "mandatory_tags" {
  type        = map(string)
  description = "A map of mandatory tags to apply to all resources."

  default = {
    Application     = "Blank-App"
    Environment     = "development"
    Cost-Center     = "XXYY"
    Support-Group   = "Sec-Ops"
    Tier            = "4"
    Backup-Required = "No"
  }

  validation {
    condition     = length(var.mandatory_tags) > 0
    error_message = "The mandatory_tags variable cannot be an empty map."
  }

  validation {
    condition     = alltrue([for required_key in ["Application", "Environment", "Cost-Center", "Support-Group", "Tier", "Backup-Required"] : contains(keys(var.mandatory_tags), required_key)])
    error_message = "Missing Mandatory Tag Value"
  }

  validation {
    condition     = alltrue([for k, v in var.mandatory_tags : length(trimspace(lookup(var.mandatory_tags, k, ""))) > 0])
    error_message = "The mandatory_tags variable must not be empty or whitespace."
  }

  validation {
    condition     = contains(["development", "staging", "production", "qa", "training", "demo", "dr"], lookup(var.mandatory_tags, "Environment", ""))
    error_message = "The mandatory_tags variable must contain a valid environment tag - development, staging, production, qa, training, demo, dr"
  }

  validation {
    condition     = contains(["0", "1", "2", "3", "4"], lookup(var.mandatory_tags, "Tier", ""))
    error_message = "The mandatory_tag variable must contain a valid tier tag."
  }

  validation {
    condition     = contains(["yes", "no"], lookup(var.mandatory_tags, "Backup-Required", ""))
    error_message = "The mandatory_tags variable must contain a valid Backup-Required tag - yes or no"
  }

}
