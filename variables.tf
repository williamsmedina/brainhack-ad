variable "location" {
  type        = string
  description = "Ubicación/Región de Azure (por ejemplo, eastus, westus, etc.)"
  default     = "eastus"  # Asegúrate de que esta región soporte Availability Zones
}

variable "resource_group_name" {
  type        = string
  description = "Nombre del Resource Group donde se creará todo"
  default     = "rg-brainhack-lab"
}

# Credenciales para Windows Server 2016 (vm-ad)
variable "admin_username_ad" {
  type        = string
  description = "Usuario administrador para el Windows Server 2016"
}

variable "admin_password_ad" {
  type        = string
  description = "Password administrador para el Windows Server 2016"
  sensitive   = true
}

# Credenciales para Windows 10 (vm-w10)
variable "admin_username_w10" {
  type        = string
  description = "Usuario administrador para el Windows 10"
}

variable "admin_password_w10" {
  type        = string
  description = "Password administrador para el Windows 10"
  sensitive   = true
}

# Credenciales para Kali (vm-kali)
variable "admin_username_kali" {
  type        = string
  description = "Usuario administrador para la máquina Kali Linux"
}

variable "admin_password_kali" {
  type        = string
  description = "Password administrador para la máquina Kali Linux"
  sensitive   = true
}
