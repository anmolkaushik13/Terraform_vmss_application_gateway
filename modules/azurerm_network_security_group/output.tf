output "nsg_ids" {
  value = {
    for k, nsg in azurerm_network_security_group.nsg :
    k => nsg.id
  }
}
