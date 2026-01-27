variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
  default     = "stgprodcistore01"

  validation {
    condition = (
      length(var.storage_account_name) >= 3 &&
      length(var.storage_account_name) <= 24 &&
      can(regex("^[a-z0-9]+$", var.storage_account_name))
    )
    error_message = "Storage account name must be 3–24 characters, lowercase letters and numbers only."
  }
}

variable "resource_group_name" {
  description = "Name of Resource Group"
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
  description = "Location of the Storage Account"
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

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be either Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "GRS"

  validation {
    condition = contains([
      "LRS",
      "GRS",
      "RAGRS",
      "ZRS",
      "GZRS",
      "RAGZRS"
    ], var.account_replication_type)

    error_message = "Invalid replication type."
  }
}

variable "tags" {
  description = "Tags to be applied to the Storage Account"
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
