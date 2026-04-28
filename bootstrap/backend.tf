terraform {
  backend "s3" {
    bucket         = "ecs-v2-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "dynamodb-table"
  }
}



