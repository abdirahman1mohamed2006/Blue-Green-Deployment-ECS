terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "bucket-v2"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "dynamodb-table"
    encrypt        = true
  }
}