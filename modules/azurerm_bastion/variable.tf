variable "bastion_name" {
  description = "Name of the Azure Bastion Host"
  type        = string
  default     = "bastion-prod-ci"

  validation {
    condition = (
      length(var.bastion_name) >= 3 &&
      length(var.bastion_name) <= 80 &&
      can(regex("^[a-z0-9-]+$", var.bastion_name))
    )
    error_message = "Bastion name must be 3–80 characters, lowercase letters, numbers, and hyphens only."
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
    error_message = "RG name must be lowercase, use hyphens, and end with <location_code>-rg (e.g. app-prod-ci-rg)."
  }
}

variable "location" {
  description = "Azure region for Bastion Host"
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

variable "bastion_subnet_id" {
  description = "Subnet ID for Azure Bastion (must be AzureBastionSubnet)"
  type        = string

  validation {
    condition     = can(regex("AzureBastionSubnet$", var.bastion_subnet_id))
    error_message = "Subnet ID must reference a subnet named 'AzureBastionSubnet'."
  }
}

variable "public_ip_id" {
  description = "Public IP resource ID for Bastion Host"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/publicIPAddresses/.+$", var.public_ip_id))
    error_message = "Must be a valid Azure Public IP resource ID."
  }
}

variable "tags" {
  description = "Tags to be applied to the Bastion Host"
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
