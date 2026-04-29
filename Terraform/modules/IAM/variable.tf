variable "codedeploy_role_name" {
    type = string
    default = "ECS_v2 Codedeploy"
}

variable "ecs_execution_role_name" {
    type = string
    default = "ecsv2_execution_role"
  
}

variable "ecs_task_role_name" {
    type = string
    default = "ecs_task_role_ecsv2"
}

variable "dynamodb_table_arn" { # from the bootstrap
    type = string
  
}

variable "github_actions_role_name" {
  type = string

}

variable "github_oidc_provider_arn" {
  type = string
}

variable "github_repo" { # also from the bootstrap
  type = string
}