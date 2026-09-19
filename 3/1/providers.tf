terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "exerciseset3-bucket"               # Replace with your actual S3 bucket name
    key            = "exercise1/terraform.tfstate"       # State file path in the bucket
    region         = "us-east-1"                         # Region where bucket/table reside
    dynamodb_table = "terraform-state-locks"             # DynamoDB table for state locking
    encrypt        = true                                # Encrypt state at rest in S3
  }



}

provider "aws" {
  region = "us-east-1" # Replace with your target AWS region
}