output "app_role_arn" {
  value       = aws_iam_role.app_role.arn
  description = "The ARN of the IAM role for the application"
}

output "app_instance_profile_arn" {
  value       = aws_iam_instance_profile.app_instance_profile.arn
  description = "The ARN of the IAM instance profile for the application"
}

output "app_instance_profile_name" {
  value       = aws_iam_instance_profile.app_instance_profile.name
  description = "The name of the IAM instance profile for the application"
}

output "exerciseset3_bucket_s3_permissions_arn" {
  value       = aws_iam_policy.exerciseset3_bucket_s3_permissions.arn
  description = "The ARN of the custom S3 permissions policy"
}