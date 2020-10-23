provider "aws" {
  region = "eu-west-1"
}

locals {
  service_prefix = "cdk-deployer"
}

resource "aws_s3_bucket" "remote_state_prod" {
  bucket_prefix = "${local.service_prefix}-tfstate-prod"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks_prod" {
  name         = "${local.service_prefix}-terraform-locks-prod"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
