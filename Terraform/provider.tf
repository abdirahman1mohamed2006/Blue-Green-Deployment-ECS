

terraform {
  backend "s3" {
    bucket         = "bucket-v2"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "dynamodb-table"
    encrypt        = true
  }
}