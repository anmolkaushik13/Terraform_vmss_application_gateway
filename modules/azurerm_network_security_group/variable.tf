variable "resource_group_name" {

  description = "Name of Resource Group"
  validation {
    condition = (
      length(var.resource_group_name) <= 90 &&
      can(regex("^[a-z0-9-]+-(ci|eus|wus)-rg$", var.resource_group_name))
    )
    error_message = "RG name must be lowercase, use hyphens, end with <location_code>-rg (e.g. abc-app-prod-ci-rg)"
  }
  type = string
}
variable "location" {
  default     = "West US"
  description = "Location of Resource Group"
  type        = string
  validation {
    condition = contains([
      "East US",
      "East US 2",
      "West US",
    "Central India", ], var.location)
    error_message = "Invalid location use as per policy "
  }

}
variable "subnets" {
  description = "Map of subnets with NSG info"
  type = map(object({
    name             = string
    address_prefixes = list(string)
    nsg_name         = string
  }))
}
