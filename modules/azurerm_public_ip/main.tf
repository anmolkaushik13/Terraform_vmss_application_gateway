resource "azurerm_public_ip" "pip" {
  for_each = var.public_ips

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku

  tags = var.tags
}
