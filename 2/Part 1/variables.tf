variable "users" {
  type        = map(string) # e.g. { "alice" = "devops" }
  description = "Map of usernames to their assigned role"
  default     = {}
}
