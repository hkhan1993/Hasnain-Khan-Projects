resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # GitHub's official OIDC thumbprint
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_policy" "prod_permission_boundary" {
  name        = "prod-permission-boundary"
  description = "Permission boundary for production environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*", "ec2:*", "lambda:*"] # Specify the actions you want to allow
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "cicd_pipeline_role" {

  name                 = "cicd-pipeline-role-${var.environment}"
  permissions_boundary = var.environment == "prod" ? aws_iam_policy.prod_permission_boundary.arn : null

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = var.environment == "prod" ? {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "sts:ExternalId"                          = var.external_id
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = local.github_sub_claim
          }
          } : {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = local.github_sub_claim
          }
        }
      }
    ]
  })

  depends_on = [aws_iam_openid_connect_provider.github, aws_iam_policy.prod_permission_boundary]

}

resource "aws_iam_role_policy_attachment" "cicd_pipeline_role_policy_attachment" {
  role       = aws_iam_role.cicd_pipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess" # Attach the PowerUserAccess policy for demonstration purposes
}