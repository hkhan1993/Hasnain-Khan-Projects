variable "policies" {

  type = list(object({
    policy_name   = string
    sensitive     = bool
    allowed_cidrs = optional(set(string))
    roles         = list(string)

  }))

  default = [
    {
      policy_name = "ci-cd-s3-deploy-policy"
      sensitive   = false
      roles       = ["ci-cd-pipeline-runner-role"]

    },
    {
      policy_name   = "admin-full-access-policy"
      sensitive     = true
      allowed_cidrs = ["10.0.0.0/16"]
      roles         = ["break-glass-admin-role", "secops-auditor-role"]

    }


  ]

}