output "resource_group_id" {
  value = module.rg.resource_group_id
}

output "resource_group_name" {
  value = module.rg.resource_group_name
}

output "resource_group_location" {
  value = module.rg.resource_group_location
}

output "server_id" {
  value = module.sql_server.server_id
}

# output "public_ip_id" {
#   description = "Public IP ID from the Public IP module"
#   value       = module.public_ip.public_ip_id
# }

output "vnet_subnet_ids" {
  description = "Subnet IDs from the VNet module"
  value       = module.vnet.subnet_ids
}
