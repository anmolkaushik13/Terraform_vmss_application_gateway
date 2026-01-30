variable "name" {
  description = "The name of the SQL Database"
  type        = string
  default     = "app-prod-ci-sql-db"
  validation {
    condition     = length(var.name) <= 128
    error_message = "SQL Database name must be 128 characters or fewer."
  }
}
variable "server_id" {
  description = "The ID of the Azure SQL Server that this database will be created on"
  type        = string
  validation {
    condition     = length(var.server_id) > 0
    error_message = "server_id cannot be empty. Provide a valid Azure SQL Server ID."
  }
}


variable "collation" {
  description = "The collation of the SQL Database"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
  validation {
    condition     = can(regex("^[a-zA-Z0-9_]+$", var.collation))
    error_message = "Collation must contain only letters, numbers, and underscores."
  }
}

variable "license_type" {
  description = "The license type for the SQL Database"
  type        = string
  default     = "LicenseIncluded"
  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.license_type)
    error_message = "License type must be either 'LicenseIncluded' or 'BasePrice'."
  }
}

variable "max_size_gb" {
  description = "The maximum size of the SQL Database in GB"
  type        = number
  default     = 2
  validation {
    condition     = var.max_size_gb > 0
    error_message = "Maximum size must be a positive number."
  }
}

variable "sku_name" {
  description = "The SKU name for the SQL Database"
  type        = string
  default     = "S0"
  validation {
    condition     = length(var.sku_name) > 0
    error_message = "SKU name cannot be empty."
  }
}

variable "enclave_type" {
  type    = string
  default = "Default"

  validation {
    condition     = contains(["Default", "VBS"], var.enclave_type)
    error_message = "enclave_type must be Default or VBS"
  }
}

variable "tags" {
  description = "Tags to apply to the SQL Database"
  type        = map(string)
  default     = {
    environment = "Development"
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
