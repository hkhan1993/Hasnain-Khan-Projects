output "role_arn" {
  description = "The ARN of the IAM role for the CI/CD pipeline"
  value       = aws_iam_role.cicd_pipeline_role.arn
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for GitHub Actions"
  value       = aws_iam_openid_connect_provider.github.arn
}