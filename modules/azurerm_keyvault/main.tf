resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = var.sku_name
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set"
    ]

    certificate_permissions = [
      "Get",
      "List"
    ]
  }

  tags = var.tags
}


resource "random_password" "secrets" {
  for_each = var.secrets
  length   = lookup(each.value, "length", 20)
  special  = lookup(each.value, "special", true)
}

resource "azurerm_key_vault_secret" "dynamic_secrets" {
  for_each     = var.secrets

  name         = replace(each.key, "_", "-")
  value        = random_password.secrets[each.key].result
  key_vault_id = azurerm_key_vault.key_vault.id
}