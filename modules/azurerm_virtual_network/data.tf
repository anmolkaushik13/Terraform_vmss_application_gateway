data "azurerm_network_security_group" "nsg" {
for_each = var.subnets
  name = each.value.network_security_group_name
  resource_group_name = var.resource_group_name==null ? azurerm_resource_group.rg[0].name : var.resource_group_name
}

