variable "zone_name" {
    type = string
    default = "abdirahman.forum"
  
}

variable "domain_name" {
    type = string
    default = "abdirahman.forum"
  
}

variable "record_name" {
    type = string
    default = "App"
  
}



variable "lb_name" {
  type = string
  default = "ecsv2_lb"
}

variable "target_port" {
    type = number
    default = 5320
  
}

variable "listener-ecsv2" {
    type = string
    default = "Ecsv2-listener"
  
}

variable "cluster_name" {
    type = string
    default = "ECSV2-cluster"
  
}

variable "service_name" {
    type = string
    default = "ECSV2-service"
  
}

variable "image" {
  type    = string
  default = "nginx:latest"
}

variable "app_name" {
    type = string
    default = "CodeDeploy-App"
  
}

variable "github_actions_role_name" {
  type = string
  default = "ecsv2_githubactionsname"
}

variable "github_repo" {
    type = string
    default = "abdirahman1mohamed2006/Blue-Green-Deployment-ECS"

  
}

variable "dynamodb_table_arn" {
    type = string
    default ="data.terraform_remote_state.bootstrap.outputs.dynamodb_table_arn" 
  
}

variable "github_oidc_provider_arn" {
  type = string
  default = "data.terraform_remote_state.bootstrap.outputs.github_oidc_provider_arn"
}