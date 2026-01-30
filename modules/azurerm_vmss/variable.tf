variable "vmss_name" {
  description = "Name of the VM Scale Set"
  type        = string
  default     = "vmss-prod-ci"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.vmss_name))
    error_message = "VMSS name must be lowercase alphanumeric and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vmss_sku" {
  description = "VM size for the scale set"
  type        = string
  default     = "Standard_B2as_v2"
}

variable "instance_count" {
  description = "Number of VM instances"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1
    error_message = "Instance count must be at least 1."
  }
}

variable "admin_username" {
  description = "Admin username for VM instances"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string

  validation {
    condition     = can(regex("^ssh-rsa|^ssh-ed25519", var.ssh_public_key))
    error_message = "Must be a valid SSH public key."
  }
}

variable "subnet_id" {
  description = "Subnet ID for VMSS network interface"
  type        = string
}

variable "image_publisher" {
  description = "Image publisher"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Image offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "Image SKU"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "os_disk_type" {
  description = "OS disk storage type"
  type        = string
  default     = "Standard_LRS"
}

variable "tags" {
  description = "Tags to apply to VMSS"
  type        = map(string)
}
variable "lb_backend_pool_id" {
  description = "Load Balancer backend pool ID"
  type        = string
}

variable "admin_password" {}
