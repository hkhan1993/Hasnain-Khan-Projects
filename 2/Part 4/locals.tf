locals {
  aws_region = "us-east-1"

  az_subnets    = slice(data.aws_availability_zones.available.names, 0, 3)
  az_subnet_map = { for idx, az in local.az_subnets : az => idx }
}