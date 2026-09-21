terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "statefilebucket1234567"
    key            = "Exercise3-4/IAM/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile     = true
    
  }

}

provider "aws" {
  region = "us-east-1"
}