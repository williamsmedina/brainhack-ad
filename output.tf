output "pip_ad_ip" {
  description = "IP pública de vm-ad"
  value       = azurerm_public_ip.pip_ad.ip_address
}

output "pip_w10_ip" {
  description = "IP pública de vm-w10"
  value       = azurerm_public_ip.pip_w10.ip_address
}

output "pip_kali_ip" {
  description = "IP pública de vm-kali"
  value       = azurerm_public_ip.pip_kali.ip_address
}

output "vm_ad_private_ip" {
  description = "IP privada de vm-ad"
  value       = azurerm_network_interface.nic_ad.ip_configuration[0].private_ip_address
}

output "vm_w10_private_ip" {
  description = "IP privada de vm-w10"
  value       = azurerm_network_interface.nic_w10.ip_configuration[0].private_ip_address
}

output "vm_kali_private_ip" {
  description = "IP privada de vm-kali"
  value       = azurerm_network_interface.nic_kali.ip_configuration[0].private_ip_address
}
