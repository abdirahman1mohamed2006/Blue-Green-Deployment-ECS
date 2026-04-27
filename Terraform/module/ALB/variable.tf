variable "vpc_id" {
  type = string
  
}

variable "lb_name" {
    type = string
  
}

variable "public_subnet_1_id" {
    type = string
  
}

variable "public_subnet_2_id" {
    type = string
  
}

variable "target_port" {
    type = string
  
}

variable "health_check_path" {
    type = string
    default = "/"
 
}

variable "health_check_matcher" {
    type = string
    default = "200"
  
}

variable "acm_certficate_arn" {
    type = string
}