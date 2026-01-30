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
  depends_on           = [module.rg, module.nsg]
  virtual_network_name = "${local.name_pattern}-vnet"
  address_space        = ["10.0.0.0/16"]
  location             = local.location
  resource_group_name  = module.rg.resource_group_name

  subnets = {
    subnet1 = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.0.0.0/24"]
    }

    subnet2 = {
      name              = "${local.name_pattern}-subnet"
      address_prefixes  = ["10.0.1.0/24"]
      security_group_id = module.nsg.nsg_ids["subnet2"]
    }

    subnet3 = {
      name              = "appgw-subnet"
      address_prefixes  = ["10.0.2.0/24"]
      # security_group_id = module.nsg.nsg_ids["subnet3"]
    }
  }

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "nsg" {
  depends_on = [ module.rg ]
  source              = "../../modules/azurerm_network_security_group"
  location            = local.location
  resource_group_name = module.rg.resource_group_name

  subnets = {
    subnet2 = {
      name             = "${local.name_pattern}-subnet"
      address_prefixes = ["10.0.1.0/24"]
      nsg_name         = "vmss-nsg"
    }
    subnet3 = {
      name             = "appgw-subnet"
      address_prefixes = ["10.0.2.0/24"]
      nsg_name         = "appgw-nsg"
    }
  }
}



module "key_vault" {
  source              = "../../modules/azurerm_keyvault"
  key_vault_name      = "${local.name_pattern}-kv"
  location            = local.location
  resource_group_name = module.rg.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id

  secrets = {
    sql_admin1  = { length = 20, special = true }
    vmss_admin1 = { length = 16, special = true }
  }

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "sql_server" {
  source     = "../../modules/azurerm_mssql_server"
  depends_on = [module.key_vault]

  name                         = "${local.name_pattern}-sqlserver"
  resource_group_name          = module.rg.resource_group_name
  location                     = local.location
  administrator_login          = "sqladminuser"
  administrator_login_password = module.key_vault.secrets["sql_admin1"]

  minimum_tls_version = "1.2"
  sql_server_version  = "12.0"

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "sql_database" {
  source       = "../../modules/azurerm_mssql_database"
  depends_on   = [module.sql_server]
  name         = "${local.name_pattern}-sqldb"
  server_id    = module.sql_server.server_id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 10
  sku_name     = "S0"
  enclave_type = "Default"

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "storage_account" {
  source                   = "../../modules/azurerm_storage_account"
  depends_on               = [module.rg]
  storage_account_name     = "newappstorage77777"
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
  source = "../../modules/azurerm_public_ip"

  resource_group_name = module.rg.resource_group_name
  location            = local.location

  public_ips = {
    lb-pip = {
      allocation_method = "Static"
      sku               = "Standard"
    }

    appgw-pip = {
      allocation_method = "Static"
      sku               = "Standard"
    }

    bastion-pip = {
      allocation_method = "Static"
      sku               = "Standard"
    }
  }

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
  bastion_subnet_id   = module.vnet.subnet_ids["AzureBastionSubnet"]
public_ip_id = module.public_ip.public_ip_ids["bastion-pip"]

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "load_balancer" {
  source     = "../../modules/azurerm_loadbalancer"
  depends_on = [module.public_ip, module.rg]

  lb_name             = "${local.name_pattern}-lb"
  resource_group_name = module.rg.resource_group_name
  location            = local.location
public_ip_id = module.public_ip.public_ip_ids["lb-pip"]

  frontend_port = 80
  backend_port  = 80

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "vmss" {
  source     = "../../modules/azurerm_vmss"
  depends_on = [module.load_balancer]

  vmss_name           = "${local.name_pattern}-vmss"
  resource_group_name = module.rg.resource_group_name
  # location            = local.location
  location            = "West US 2"
  subnet_id           = module.vnet.subnet_ids["${local.name_pattern}-subnet"]

  lb_backend_pool_id = module.load_balancer.backend_pool_id

  admin_username = "azureuser"
  admin_password = module.key_vault.secrets["vmss_admin1"]
  ssh_public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    environment = local.environment
    project     = local.project
  }
}

module "app_gateway" {
  source     = "../../modules/azurerm_application_gateway"
  depends_on = [module.vnet, module.public_ip, module.key_vault]

  appgw_name          = "${local.name_pattern}-appgw"
  location            = local.location
  resource_group_name = module.rg.resource_group_name
  subnet_id           = module.vnet.subnet_ids["appgw-subnet"]
public_ip_id = module.public_ip.public_ip_ids["appgw-pip"]

  backend_port        = 80

  tags = {
    environment = local.environment
    project     = local.project
  }
}
