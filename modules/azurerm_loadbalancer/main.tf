resource "azurerm_lb" "loadbalancer" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.lb_sku

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = var.public_ip_id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "lb_pool" {
  name            = "${var.lb_name}-backend-pool"
  loadbalancer_id = azurerm_lb.loadbalancer.id
}

resource "azurerm_lb_probe" "lb_prob" {
  name            = "${var.lb_name}-probe"
  loadbalancer_id = azurerm_lb.loadbalancer.id
  protocol        = var.probe_protocol
  port            = var.probe_port
  request_path    = var.probe_protocol == "Http" ? var.probe_path : null
}

resource "azurerm_lb_rule" "this" {
  name                           = "${var.lb_name}-rule"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  protocol                       = var.lb_protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_pool.id]
  probe_id                       = azurerm_lb_probe.lb_prob.id
}
