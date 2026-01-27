output "public_ip_id" {
  description = "ID of the Public IP"
  value       = azurerm_public_ip.public_ip.id
}