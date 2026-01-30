output "public_ip_ids" {
  description = "Map of Public IP names to IDs"
  value = {
    for k, v in azurerm_public_ip.pip :
    k => v.id
  }
}
