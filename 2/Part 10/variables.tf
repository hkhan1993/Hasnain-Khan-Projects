variable "vpc_list" {

  type        = list(string)
  description = "List of VPCs for Peering Connection"

  validation {
    condition     = length(var.vpc_list) >= 2
    error_message = "2 of More VPCs are required for Peering"
  }
}