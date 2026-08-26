data "aws_iam_policy_document" "this" {
  # Keyed by policy_name just like the resource!
  for_each = { for p in var.policies : p.policy_name => p }

  statement {
    sid       = "BasePermissions"
    actions   = ["*"]
    resources = ["*"]

    # Toggle 1: MFA Condition
    dynamic "condition" {
      for_each = each.value.sensitive ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }

    # Toggle 2: IP Restriction Condition
    dynamic "condition" {
      for_each = each.value.sensitive ? [1] : []
      content {
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = try(toset(each.value.allowed_cidrs), [])
      }
    }
  }
}