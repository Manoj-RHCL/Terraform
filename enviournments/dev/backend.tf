# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "testbucket99222"
    key       = "dev.tfstate"
    region    = "us-east-2"
  }
}