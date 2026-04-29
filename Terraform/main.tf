module "VPC" {
  source = "./modules/VPC"
}

module "ACM" {
  source = "./modules/ACM"

  zone_name   = var.zone_name
  domain_name = var.domain_name

}

module "ALB" {
  source          = "./modules/ALB"

  vpc_id = module.VPC.vpc_id
  lb_name = var.lb_name
  
  public_subnet_1_id = module.VPC.public_subnet_1_id
  public_subnet_2_id = module.VPC.public_subnet_2_id
  
  acm_certficate_arn = module.ACM.acm_certficate_arn    
  target_port = var.target_port

}

module "CodeDeploy" {
    source = "./modules/CodeDeploy"

    app_name  = var.app_name
    listener-ecsv2 = var.listener-ecsv2
    cluster_name = var.cluster_name
    service_name = var.service_name
    blue_tg_name = module.alb.blue_tg_name
    green_tg_name = module.alb.green_tg_name
    service_role_arn = module.IAM.codedeploy_role_arn
    listener_ecsv2_arn  = module.ALB.listener_ecsv2_arn
     
}

module "ECS" {
    source = "./modules/ECS"

    vpc_id              = module.VPC.vpc_id
    alb_sg_id           = module.ALB.alb_sg_id
    private_subnet_1_id = module.VPC.private_subnet_1_id
    private_subnet_2_id = module.VPC.private_subnet_2_id
    public_subnet_1_id  = module.VPC.public_subnet_1_id
    public_subnet_2_id  = module.VPC.public_subnet_2_id
    target_group_arn    = module.ALB.target_group_arn
    image               = var.image 
}

module "IAM" {
  source = "./modules/IAM"

  dynamodb_table_arn       = data.terraform_remote_state.bootstrap.outputs.dynamodb_table_arn
  github_oidc_provider_arn = data.terraform_remote_state.bootstrap.outputs.github_oidc_provider_arn
  github_actions_role_name = var.github_actions_role_name 

}

module "WAF" {
  source = "./modules/WAF"

  esv2_lb = module.ALB.esv2_lb.arn
  
}
  



