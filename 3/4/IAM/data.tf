data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "exerciseset3_bucket_s3_permissions" {
  statement {
    sid    = "AllowS3AppBucketRead"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::exerciseset3-bucket",
      "arn:aws:s3:::exerciseset3-bucket/*"
    ]
  }
}