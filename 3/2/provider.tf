terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }

  backend "s3" {
    bucket       = "statefilebucket1234567"
    key          = "Exercise3-2/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true  # Enables native S3 locking (.tflock file creation)
  }

}

provider "aws" {
  # TODO: Set the AWS region using a variable from variables.tf
  region = var.aws_region
}

/*
Question 1: What would happen to the real, already-running EC2 instance if you'd instead pointed at an empty remote state and run apply?
Loss of Management Tracking: Terraform reads the empty remote state and assumes 0 resources exist. It does not automatically "know" about your live EC2 instance.

Duplicate Creation or Provisioning Failure:

If names/IPs don't conflict: Terraform will attempt to spin up a brand new, duplicate EC2 instance alongside the existing one. You will start paying for two instances while the original one runs completely unmanaged ("orphaned").
If names/IPs conflict: The apply step will crash midway with resource collision errors (e.g., duplicate security group names or subnet binding conflicts).
If you later run terraform destroy: Terraform will destroy nothing from the original project setup because it doesn't know it exists in state. You would have to manually run terraform import to recover control of the original EC2 instance.

Question 2: Before migrating, is the local terraform.tfstate file safe to have ever been committed to version control? What would you do if it already was?
No, local state files should never be committed to Git or any version control system.

Plaintext Secrets Leakage: Terraform state files store every single managed resource attribute in unencrypted plain text.
Even if variables are marked sensitive = true in your .tf code, passwords, API tokens, IAM credentials, and private keys will be stored in plain text inside terraform.tfstate.
State Corruption: Git cannot merge conflicting JSON files. If two engineers push state changes simultaneously, Git merge conflicts will corrupt the state file structure.



*/