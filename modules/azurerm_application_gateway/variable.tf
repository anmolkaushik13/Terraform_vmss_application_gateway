variable "appgw_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "Dedicated App Gateway subnet"
}

variable "public_ip_id" {
  type = string
}

variable "backend_port" {
  type    = number
  default = 80
}

variable "sku_name" {
  type    = string
  default = "WAF_v2"
}

variable "sku_tier" {
  type    = string
  default = "WAF_v2"
}

variable "capacity" {
  type    = number
  default = 2
}

variable "tags" {
  type = map(string)
}
