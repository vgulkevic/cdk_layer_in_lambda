provider "aws" {
  region  = "eu-west-1"
}

locals {
  service_prefix = "cdk-deployer"
}

terraform {
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "<my_remote_bucket>"
    key            = "prod/terraform.tfstate"
    dynamodb_table = "cdk-deployer-terraform-locks-prod"
    encrypt        = true
  }
}

module "main" {
  source     = "../resources"
  env        = "prod"
  aws_region = "eu-west-1"
}
