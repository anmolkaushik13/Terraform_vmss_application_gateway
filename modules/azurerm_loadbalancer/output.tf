output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.lb_pool.id
}

output "load_balancer_id" {
  value = azurerm_lb.loadbalancer.id
}
