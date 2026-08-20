variable "default_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The default instance class for the read replicas databases."
}


variable "default_allocated_storage" {
  type        = number
  default     = 20
  description = "The default allocated storage (in GB) for the read replicas databases."
}

variable "primary_subnet_ids" {
  type = list(string)
  description = "The subnet IDs for the primary database instance."
}

variable "replica_subnet_ids" {
  type = map(list(string))
  description = "A map of subnet IDs for different regions."
}
   

variable "replicas" {
  type = map(object({
    instance_class    = optional(string)
    allocated_storage = optional(number)
  }))

  default = {
    us-west-1 = {}

    us-west-2 = {
      instance_class    = "db.r6g.large"
      allocated_storage = 50
    }

  }

}