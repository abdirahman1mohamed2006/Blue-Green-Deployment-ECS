variable "zone_name" {
  type = string
}

variable "domain_name" {
  type = string

}


variable "record_name" {
  type = string

}

variable "alb_dns_name" {
  type = string

}

variable "alb_zone_id" {
  type = string

}

variable "hosted_zone_id" {
  type = string
  default = "Z00508175299IH6BCTIZ"
  
}