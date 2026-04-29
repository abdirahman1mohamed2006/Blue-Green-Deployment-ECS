variable "vpc_id" {  # 
    type = string
  
}

variable "alb_sg_id" { 
    type = string
  
}

variable "port" {
    type = number
    default = 5320
}

variable "cluster" {
    type = string
    default = "ESC2-Cluster"
}

variable "public_subnet_1_id" { 
  type = string
}

variable "public_subnet_2_id" { 
    type = string
  
}

variable "target_group_arn" { # outputted from alb
    type = string
  
}

variable "log_group" {
    type = string
    default = "ecsv2-logs"
  
}

variable "app_name" {
  type = string
  default = "memo-app"
}

variable "app_name_service" {
  type    = string
  default = "memo-service"
}

variable "family" {
  type    = string
  default = "memo-task"
}

variable "cpu" {
  type    = string
  default = "256"
}

variable "memory" {
  type    = string
  default = "512"
}

variable "aws_region" {
    type = string
    default = "eu-west-1"
  
}

variable "image" {
    type = string
    
  
}

variable "task_role_arn" {
  type = string
  
}

variable "execution_role_arn" {
  type = string
  
}
