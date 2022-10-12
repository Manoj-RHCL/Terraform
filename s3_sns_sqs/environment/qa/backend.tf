# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "876313778020-tf-backend"
    key       = "dev11.tfstate"
    region    = "ap-south-1"
  }
}