variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "region" {
    type = string
    default = "eu-west-2"
  
}

variable "alb_sg" {   # From ALB 
    type = string
  
}

variable "ecs_sg" {  # From ECS
    type = string
  
}