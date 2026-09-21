resource "aws_iam_role" "app_role" {
  name               = "${var.environment}-custom-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "exerciseset3_bucket_s3_permissions" {
  name        = "${var.environment}-exerciseset3-bucket-s3-permissions"
  description = "Custom policy to allow S3 access to exerciseset3-bucket"
  policy      = data.aws_iam_policy_document.exerciseset3_bucket_s3_permissions.json
}


resource "aws_iam_role_policy_attachment" "attach_custom" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.exerciseset3_bucket_s3_permissions.arn
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.environment}-app-instance-profile"
  role = aws_iam_role.app_role.name
}