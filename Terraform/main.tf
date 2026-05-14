data "terraform_remote_state" "bootstrap" {
  backend = "s3"

  config = {
    bucket = "ecs-v2-terraform-state-848153448908"
    key    = "bootstrap/terraform.tfstate"
    region = "eu-west-1"
  }
}




module "VPC" {
  source = "./modules/VPC"
}


module "IAM" {
  source = "./modules/IAM"

  dynamodb_table_arn       = data.terraform_remote_state.bootstrap.outputs.dynamodb_table_arn
  github_oidc_provider_arn = data.terraform_remote_state.bootstrap.outputs.github_oidc_provider_arn
  ecr_repo                 = var.ecr_repo
  github_actions_role_name = var.github_actions_role_name
  github_repo = var.github_repo
}

module "ACM" {
  source = "./modules/ACM"

  zone_name   = var.zone_name
  domain_name = var.domain_name
  record_name = var.record_name
}

module "ALB" {
  source = "./modules/ALB"

  vpc_id = module.VPC.vpc_id
  lb_name = var.lb_name

  public_subnet_1_id = module.VPC.public_subnet_1_id
  public_subnet_2_id = module.VPC.public_subnet_2_id

  acm_certificate_arn = module.ACM.acm_certificate_arn
  target_port         = var.target_port

   depends_on = [module.ACM]

}

module "ECS" {
  source = "./modules/ECS"

  vpc_id             = module.VPC.vpc_id
  alb_sg_id          = module.ALB.alb_sg
  

  target_group_arn = module.ALB.blue_target_group_arn
  image            = var.image

  task_role_arn      = module.IAM.ecs_task_role_arn
  

  public_subnet_1_id = module.VPC.public_subnet_1_id
  public_subnet_2_id = module.VPC.public_subnet_2_id
  ecs_execution_role_arn = module.IAM.ecs_execution_role_arn
  


  depends_on = [module.ALB]

}

module "CodeDeploy" {
  source = "./modules/CodeDeploy"

  app_name           = var.app_name
  cluster_name       = module.ECS.cluster_name
  service_name       = module.ECS.service_name
  blue_tg_name       = module.ALB.blue_tg_name
  green_tg_name      = module.ALB.green_tg_name
  service_role_arn   = module.IAM.codedeploy_role_arn
  listener_ecsv2_arn = module.ALB.listener_ecsv2_arn
}

module "WAF" {
  source = "./modules/WAF"

  ecsv2_lb = module.ALB.ecsv2_lb_arn
}

module "Route53" {
  source = "./modules/Route53"

  zone_name      = var.zone_name
  record_name    = "abdirahman.forum"

  alb_dns_name = module.ALB.alb_dns_name
  alb_zone_id  = module.ALB.alb_zone_id

  depends_on = [
    module.ALB,
    module.ACM
  ]
}