locals {
  role_policy_attachments = flatten([
    for p in var.policies : [
      for r in p.roles : {
        policy_name = p.policy_name
        role_name   = r
      }
    ]
  ])
}

