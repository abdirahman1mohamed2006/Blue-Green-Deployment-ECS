terraform {
  backend "s3" {
    bucket       = "ecs-v2-terraform-state-848153448908"
    key          = "main/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}