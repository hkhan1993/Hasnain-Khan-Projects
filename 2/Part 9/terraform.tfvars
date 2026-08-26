policies = [
  {
    policy_name   = "ADMINACCESS2POLICY"
    sensitive     = true
    allowed_cidrs = ["10.0.1.0/24"]
    roles         = ["AdminAcess", "s3admin"]
  },
  {
    policy_name = "CICDPIPELINEROBOUSER"
    sensitive   = false
    roles       = ["EC2-SSM-Role"]

  }
]

