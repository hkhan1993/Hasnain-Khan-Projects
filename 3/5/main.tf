resource "aws_security_group" "rds" {
  name        = "dev-rds-sg"
  description = "Allow inbound database traffic"
  vpc_id      = var.vpc_id 

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]       
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier = "appdb-postgres"

  engine               = "postgres"
  engine_version       = "15.17"
  family               = "postgres15" # DB parameter group family
  major_engine_version = "15"
  instance_class       = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = "appdb"
  username = "dbadmin"

  # Inject the secret from AWS Secrets Manager
  password = data.aws_secretsmanager_secret_version.rds_password_version.secret_string


  create_db_subnet_group = true
  subnet_ids             = [
    var.subnet_ids[0],
    var.subnet_ids[1]
  ]
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Configuration Flags
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

/*
1. What does plaintext in terraform.tfstate imply about backend security?
Because Terraform must track resource attributes to detect drift, reading a secret via a data block and passing it into a resource like aws_db_instance causes the raw secret string to be written directly into terraform.tfstate.

This implies that your state file is as sensitive as the database password itself and requires strict controls:

At-Rest Encryption (Server-Side Encryption): The backend bucket (e.g., S3) must enforce Server-Side Encryption using a Customer Managed Key (KMS CMK) rather than standard default keys, allowing granular KMS key policies to govern who can decrypt state objects.

In-Transit Encryption: The backend must enforce TLS (aws:SecureTransport) via bucket policies to prevent interception.

Strict Least-Privilege IAM Policies: s3:GetObject and s3:PutObject on the state bucket must be restricted exclusively to automated CI/CD deployment roles (or specific administrative identities). Developers should not have permission to download or view raw state files.

RBAC & State Locking: Use backend mechanisms like DynamoDB state locking to prevent concurrency issues and ensure state access is logged and audited (via AWS CloudTrail).

2. What is actually gained by Secrets Manager if the state itself isn't encrypted/restricted?
If your Terraform state file is unencrypted or exposed, Secrets Manager provides zero protection against state exposure. However, assuming standard best practices are applied to the state backend, using Secrets Manager provides critical advantages:

Eliminates Source Control Risk (VCS Exposure): Standard sensitive = true variables still require passing values via .tfvars files, environment variables (TF_VAR_), or terminal inputs. These frequently get committed to Git, cached in shell histories, or leaked in CI/CD build logs. Data source lookups keep secrets out of code and build artifacts entirely.

Separation of Duties & Access Boundaries: Developers writing Terraform code or triggering plans do not need access to read or know the production password. The secret remains inside Secrets Manager, and Terraform retrieves it using a machine IAM role during execution.

Dynamic Lifecycle Management & Out-of-Band Rotation: Passwords can be generated, updated, or rotated directly within Secrets Manager (or via AWS Lambda) without modifying, re-committing, or re-applying Terraform configurations.

Auditability & Logging: Access to the secret in Secrets Manager generates targeted AWS CloudTrail events (GetSecretValue), enabling security teams to monitor who accessed the database credentials and when.
*/