resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name             = subnet.value.name
      address_prefixes = subnet.value.address_prefixes

      # OPTIONAL NSG ATTACH
      security_group = lookup(subnet.value, "security_group_id", null)

      private_endpoint_network_policies             = lookup(subnet.value, "private_endpoint_network_policies", "Disabled")
      private_link_service_network_policies_enabled = lookup(subnet.value, "private_link_service_network_policies_enabled", false)
    }
  }
}
