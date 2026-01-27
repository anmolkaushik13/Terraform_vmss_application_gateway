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
variable "tags" {
  description = "Tags to be applied to the Resource Group"
  type        = map(string)
  default = {
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
variable "virtual_network_name" {
  type        = string
  description = "Name of the Virtual Network"
  validation {
    condition = (
      length(var.virtual_network_name) <= 64 &&
      can(regex("^[a-z0-9-]+-vnet$", var.virtual_network_name))
    )
    error_message = "VNet name must be lowercase, use hyphens, end with -vnet (e.g. abc-app-prod-vnet)"
  }
  default = "abc-app-prod-vnet"
}
variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}


variable "subnets" {
  description = "Map of subnets configuration"
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    security_group_id                             = optional(string)
    network_security_group_name                   = optional(string,null)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, false)

    delegation_name = optional(string)
    delegation = optional(object({
      name    = string
      actions = list(string)
    }))
  }))
  
  default = {}
}
