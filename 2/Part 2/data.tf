data "terraform_remote_state" "part1" {
  backend = "s3"
  config = {
    bucket = "statefilebucket1234567"
    key    = "part1/terraform.tfstate"
    region = "us-east-1"
  }
}