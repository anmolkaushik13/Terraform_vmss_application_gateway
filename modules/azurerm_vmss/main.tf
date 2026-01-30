resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.vmss_sku
  instances           = var.instance_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  disable_password_authentication = false

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

 source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.os_disk_type
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name                                 = "internal"
      primary                              = true
      subnet_id                             = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.lb_backend_pool_id]
    }
  }

  tags = var.tags
}
