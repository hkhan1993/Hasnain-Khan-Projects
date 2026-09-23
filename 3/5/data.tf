/*
{                                                                                                          
    "ARN": "arn:aws:secretsmanager:us-east-1:883225547196:secret:rdspassword-42chAL",
    "Name": "rdspassword",
    "VersionId": "72498149-2366-4793-b7f4-7e8b8144ae69"
}
*/
# 1. Look up the Secret metadata by path/name
data "aws_secretsmanager_secret" "rds_password" {
  name = "rdspassword"
}

# 2. Retrieve the actual contents (value) of that secret
data "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}