module "rg" {
  source = "../../modules/azurerm_resource_group"

  resource_group_name = "${local.name_pattern}-rg"
  location            = local.location
  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "vnet" {
  source               = "../../modules/azurerm_virtual_network"
  depends_on           = [module.rg]
  virtual_network_name = "${local.name_pattern}-vnet"
  address_space        = ["10.0.0.0/16"]
  location             = local.location
  resource_group_name  = module.rg.resource_group_name
  tags = {
    environment = local.environment
    project     = local.project
  }
  subnets = {
    subnet1 = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.0.0.0/24"]
    }
    subnet2 = {
      name             = "${local.name_pattern}-subnet"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

module "sql_server" {
  source                       = "../../modules/azurerm_mssql_server"
  depends_on                   = [module.rg]
  name                         = "${local.name_pattern}-sqlserver"
  resource_group_name          = module.rg.resource_group_name
  location                     = local.location
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssw0rd1234!"
  minimum_tls_version          = "1.2"
  sql_server_version           = "12.0"

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "sql-database" {
  depends_on   = [module.sql_server, module.rg]
  source       = "../../modules/azurerm_mssql_database"
  name         = "${local.name_pattern}-sqldb"
  server_id    = module.sql_server.server_id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 10
  sku_name     = "S0"
  enclave_type = "None"
  tags = {
    environment = local.environment
    project     = local.project
  }

}

module "storage_account" {
  depends_on               = [module.rg]
  source                   = "../../modules/azurerm_storage_account"
  storage_account_name     = "newappstorage"
  resource_group_name      = module.rg.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "public_ip" {
  source                      = "../../modules/azurerm_public_ip"
  depends_on                  = [module.rg]
  public_ip_name              = "${local.name_pattern}-pip"
  resource_group_name         = module.rg.resource_group_name
  location                    = local.location
  public_ip_allocation_method = "Static"
  public_ip_sku               = "Standard"
  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "bastion" {
  source              = "../../modules/azurerm_bastion"
  depends_on          = [module.public_ip, module.vnet]
  bastion_name        = "${local.name_pattern}-bastion"
  resource_group_name = module.rg.resource_group_name
  location            = local.location
  bastion_subnet_id   = module.vnet.subnet_ids["subnet1"]
  public_ip_id        = module.public_ip.public_ip_id
  tags = {
    environment = local.environment
    project     = local.project
  }
}
