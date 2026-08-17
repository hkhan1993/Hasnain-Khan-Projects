variable "resource_group_name" {
  type        = string
  description = "Name of Azure Resource Group"
}

variable "az_location" {
  type        = string
  description = "Azure Region for Deployment"
  default     = "East US"

}

variable "nsg_rules" {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string

  }))

  description = "Map of NSG rules keyed by rule name"

  validation {
    condition     = length(var.nsg_rules) == length(distinct([for k, v in var.nsg_rules : v.priority]))
    error_message = "Duplicate priority found! Every NSG rule must have a unique priority number."
  }
}

