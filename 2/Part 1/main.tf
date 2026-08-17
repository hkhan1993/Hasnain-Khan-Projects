resource "aws_iam_user" "users" {
  for_each = var.users
  name     = each.key

}

resource "aws_iam_group" "user_groups" {
  for_each = local.group_policies
  name     = each.key


}


resource "aws_iam_group_policy_attachment" "group_policy_attachments" {
  for_each = { for pair in local.group_policy_pairs : "${pair.group}-${pair.policy}" => pair }

  group      = aws_iam_group.user_groups[each.value.group].name
  policy_arn = each.value.policy


}

resource "aws_iam_user_group_membership" "user_group_memberships" {
  for_each = var.users

  user = aws_iam_user.users[each.key].name
  groups = [
    aws_iam_group.user_groups[each.value].name
  ]

  depends_on = [aws_iam_group.user_groups, aws_iam_user.users, aws_iam_group_policy_attachment.group_policy_attachments]
}
