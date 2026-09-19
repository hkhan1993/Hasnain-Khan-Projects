module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "module-vpc"
  cidr = "10.10.0.0/16"
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24"]
  public_subnets = ["10.10.0.0/24", "10.10.2.0/24", "10.10.4.0/24"]

    enable_nat_gateway = false
    create_igw = false

    tags = {
    Terraform = "true"
    Environment = "dev"
  } 

}

/*
●	What actually happens, mechanically, if two teammates run apply on this project at the same moment without locking in place?
rror message: operation error DynamoDB: PutItem, https response error StatusCode: 400,
│ Whichever apply finishes last will overwrite the S3 state file. The earlier apply's state metadata is permanently lost. 
  This creates "orphaned" resources in AWS that Terraform no longer tracks, requiring manual console cleanup or state import operations to recover.


●	Why does the key name ("vpc") matter once this same S3 bucket starts holding state for several different projects?
Using separate keys creates distinct state files. 
If a mistake happens during an apply on your database tier, only the state file pointed to by key = "databases/terraform.tfstate" is locked or modified. 
Your core networking state (key = "network/vpc.tfstate") remains untouched and safe.
In multi-team environments, you can write AWS IAM policies that grant developers access only to specific key prefixes within the bucket:Network Team $\rightarrow$ Allowed access to s3://my-bucket/network
/*App Team $\rightarrow$ Allowed access to s3://my-bucket/apps/*Prevents Locking Conflicts Across ProjectsDynamoDB locks state based on a combination of the bucket name and the key path. If two different projects use distinct keys, their locks won't block each other. 
Teammates can deploy app changes and network updates concurrently without hitting lock contention errors.

*/