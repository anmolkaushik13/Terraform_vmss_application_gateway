variable "public_ips" {
  description = "Map of public IPs to create"
  type = map(object({
    allocation_method = string
    sku               = string
  }))
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}
