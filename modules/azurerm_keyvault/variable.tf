variable "key_vault_name" {
  type        = string
  description = "Key Vault name"
}

variable "location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "tenant_id" {
  type        = string
}

variable "object_id" {
  type        = string
  description = "Object ID for access policy (App Gateway or admin)"
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "tags" {
  type = map(string)
}

variable "secrets" {
  type = map(object({
    length  = optional(number, 20)
    special = optional(bool, true)
  }))
}