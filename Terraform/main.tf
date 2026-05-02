module "VPC" {
  source = "./modules/VPC"
  alb_sg = module.Alb.alb_sg.id
  ecs_sg = module.ECS.ecs_sg.id 
}

module "IAM" {
  source = "./modules/IAM"

  dynamodb_table_arn       = data.terraform_remote_state.bootstrap.outputs.dynamodb_table_arn
  github_oidc_provider_arn = data.terraform_remote_state.bootstrap.outputs.github_oidc_provider_arn
  github_actions_role_name = var.github_actions_role_name
  github_repo = var.github_repo
}

module "ACM" {
  source = "./modules/ACM"

  zone_name   = var.zone_name
  domain_name = var.domain_name
  record_name = var.record_name
  alb_dns_name = var.alb_dns_name
  alb_zone_id = var.alb_zone_id 

}

module "ALB" {
  source = "./modules/ALB"

  vpc_id = module.VPC.vpc_id
  lb_name = var.lb_name

  public_subnet_1_id = module.VPC.public_subnet_1_id
  public_subnet_2_id = module.VPC.public_subnet_2_id

  acm_certificate_arn = module.ACM.acm_certificate_arn
  target_port         = var.target_port
}

module "ECS" {
  source = "./modules/ECS"

  vpc_id             = module.VPC.vpc_id
  alb_sg_id          = module.ALB.alb_sg_id
  

  target_group_arn = module.ALB.blue_target_group_arn
  image            = var.image

  task_role_arn      = module.IAM.task_role_arn
  

  public_subnet_1_id = module.VPC.public_subnet_1_id
  public_subnet_2_id = module.VPC.public_subnet_2_id
  
  ecs_execution_role_arn = module.IAM.ecs_execution_role_arn

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

  ecsv2_lb = module.ALB.alb_arn
}