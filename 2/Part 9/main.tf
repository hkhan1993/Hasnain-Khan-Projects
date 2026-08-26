resource "aws_iam_policy" "this" {

  for_each = { for p in var.policies : p.policy_name => p }

  name        = each.value.policy_name
  description = "Managed policy for ${each.value.policy_name}"
  policy      = data.aws_iam_policy_document.this[each.key].json


}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for item in local.role_policy_attachments :
    "${item.role_name}-${item.policy_name}" => item
  }

  role       = each.value.role_name
  policy_arn = aws_iam_policy.this[each.value.policy_name].arn
}