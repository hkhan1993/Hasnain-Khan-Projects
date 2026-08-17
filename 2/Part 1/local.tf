locals {


  group_policies = {
    devops = [
      "arn:aws:iam::aws:policy/PowerUserAccess",
      "arn:aws:iam::aws:policy/AWSCloudTrail_ReadOnlyAccess"
    ]
    data_engineer = [
      "arn:aws:iam::aws:policy/AmazonS3FullAccess",
      "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
    ]
    auditor = [
      "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]
  }

  group_policy_pairs = flatten([
    for group, policies in local.group_policies : [
      for policy in policies : {
        group  = group
        policy = policy
      }
    ]
  ])



}