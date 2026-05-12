terraform {
  backend "s3" {
    bucket       = "ecs-v2-terraform-state-848153448908"
    key          = "main/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}

resource "aws_dynamodb_table" "url_shortener" {
  name         = "url-shortener-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}