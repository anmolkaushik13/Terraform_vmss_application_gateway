output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = {
    for s in azurerm_virtual_network.vnet.subnet :
    s.name => s.id
  }
}
