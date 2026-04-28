variable "zone_name" {
    type = string
    default = "abdirahman.forum"
  
}

variable "domain_name" {
    type = string
    default = "abdirahman.forum"
  
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
