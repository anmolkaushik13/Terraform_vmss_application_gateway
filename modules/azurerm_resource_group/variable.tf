variable "resource_group_name" {
  default="app-prod-ci-rg"
  description = "Name of Resource Group"
  validation {
    condition = (length(var.resource_group_name) <= 90 && can(regex("^[a-z0-9-]+-(ci|eus|wus)-rg$", var.resource_group_name)))
    error_message = "RG name must be lowercase, use hyphens, end with <location_code>-rg (e.g. app-prod-ci-rg)"
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