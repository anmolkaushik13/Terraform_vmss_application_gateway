output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs"
  value = {
    for key, s in azurerm_virtual_network.vnet.subnet :
    key => s.id
  }
}