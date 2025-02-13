variable "location" {
  type        = string
  description = "Ubicación/Región de Azure (por ejemplo, eastus, westus, etc.)"
  default     = "eastus"  
}

variable "resource_group_name" {
  type        = string
  description = "Nombre del Resource Group donde se creará todo"
  default     = "rg-brainhack-lab"
}

# Credenciales únicas para las 3 VMs
variable "admin_username" {
  type        = string
  description = "Usuario administrador para todas las VMs"
}

variable "admin_password" {
  type        = string
  description = "Password administrador para todas las VMs"
  sensitive   = true
}