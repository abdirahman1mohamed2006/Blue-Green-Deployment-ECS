
terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"

  config = {
    bucket = "ecs-v2-terraform-state-848153448908"
    key    = "bootstrap/terraform.tfstate"
    region = "eu-west-1"
  }
}


