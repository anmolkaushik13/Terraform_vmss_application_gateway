variable "lb_name" {
  description = "Load Balancer name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "public_ip_id" {
  description = "Public IP ID for frontend"
  type        = string
}

variable "lb_sku" {
  description = "Load Balancer SKU"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.lb_sku)
    error_message = "Load Balancer SKU must be Basic or Standard."
  }
}

variable "lb_protocol" {
  description = "Load balancer rule protocol"
  type        = string
  default     = "Tcp"
}

variable "frontend_port" {
  description = "Frontend port"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend port"
  type        = number
  default     = 80
}

variable "probe_protocol" {
  description = "Health probe protocol"
  type        = string
  default     = "Http"
}

variable "probe_port" {
  description = "Health probe port"
  type        = number
  default     = 80
}

variable "probe_path" {
  description = "Health probe path (HTTP only)"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags for Load Balancer"
  type        = map(string)
}
