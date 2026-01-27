variable "name" {
  description = "The name of the Azure SQL Server"
  type        = string
  default     = "app-prod-ci-sql-server"
  validation {
    condition     = length(var.name) <= 63
    error_message = "SQL Server name must be 63 characters or fewer."
  }
}

variable "sql_server_version" {
  description = "The version of the SQL Server"
  type        = string
  default     = "12.0"
  validation {
    condition     = contains(["12.0", "14.0", "15.0"], var.sql_server_version)
    error_message = "Version must be one of 12.0, 14.0, or 15.0."
  }
}

variable "administrator_login" {
  description = "The administrator login for the SQL Server"
  type        = string
  default     = "sqladmin"
  validation {
    condition     = length(var.administrator_login) >= 1 && length(var.administrator_login) <= 128
    error_message = "Administrator login must be between 1 and 128 characters."
  }
}

variable "administrator_login_password" {
  description = "The administrator password for the SQL Server"
  type        = string
  sensitive   = true
  default     = "P@ssword1234!"
  validation {
    condition     = length(var.administrator_login_password) >= 8
    error_message = "Administrator password must be at least 8 characters long."
  }
}

variable "minimum_tls_version" {
  description = "The minimum TLS version for the SQL Server"
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0, 1.1, or 1.2."
  }
}

variable "resource_group_name" {
  default="abc-app-prod-ci-rg"
  description = "Name of Resource Group"
  validation {
    condition = (length(var.resource_group_name) <= 90 && can(regex("^[a-z0-9-]+-(ci|eus|wus)-rg$", var.resource_group_name)))
    error_message = "RG name must be lowercase, use hyphens, end with <location_code>-rg (e.g. abc-app-prod-ci-rg)"
  }
  type = string
}
variable "location" {
  default = "West US"
  description = "Location of Resource Group"
  type = string
  validation {
    condition = contains([
      "East US",
      "East US 2",
        "West US",
        "Central India",], var.location)
        error_message = "Invalid location use as per policy "
  }

}
variable "tags" {
  description = "Tags to be applied to the Resource Group"
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
