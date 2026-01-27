variable "public_ip_name" {
  description = "Name of the Public IP address"
  type        = string
  default     = "examplepip"

  validation {
    condition = (
      length(var.public_ip_name) >= 3 &&
      length(var.public_ip_name) <= 80 &&
      can(regex("^[a-z0-9-]+$", var.public_ip_name))
    )
    error_message = "Public IP name must be 3–80 characters, lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = "app-prod-ci-rg"

  validation {
    condition = (
      length(var.resource_group_name) <= 90 &&
      can(regex("^[a-z0-9-]+-(ci|eus|wus)-rg$", var.resource_group_name))
    )
    error_message = "RG name must be lowercase, use hyphens, and end with <location_code>-rg."
  }
}

variable "location" {
  description = "Azure region for the Public IP"
  type        = string
  default     = "West US"

  validation {
    condition = contains([
      "East US",
      "East US 2",
      "West US",
      "Central India"
    ], var.location)

    error_message = "Invalid location. Use an approved Azure region."
  }
}

variable "public_ip_allocation_method" {
  description = "Allocation method for the Public IP"
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "Allocation method must be Static or Dynamic."
  }
}

variable "public_ip_sku" {
  description = "SKU of the Public IP"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_sku)
    error_message = "Public IP SKU must be Basic or Standard."
  }
}

variable "tags" {
  description = "Tags to be applied to the Public IP"
  type        = map(string)

  default = {
    environment = "staging"
    project     = "example"
  }

  validation {
    condition = (
      length(var.tags) <= 10 &&
      contains(keys(var.tags), "environment") &&
      contains(keys(var.tags), "project")
    )
    error_message = "A maximum of 10 tags are allowed and tags must include 'environment' and 'project'."
  }
}
