output "bastion_public_ip" {
  description = "IP pública para conectar al Azure Bastion"
  value       = azurerm_public_ip.bastion_pip.ip_address
}

output "vm_ad_private_ip" {
  description = "Dirección IP privada del AD"
  value       = azurerm_network_interface.nic_ad.ip_configuration[0].private_ip_address
}

output "vm_w10_private_ip" {
  description = "Dirección IP privada del Windows 10"
  value       = azurerm_network_interface.nic_w10.ip_configuration[0].private_ip_address
}

output "vm_kali_private_ip" {
  description = "Dirección IP privada del Kali"
  value       = azurerm_network_interface.nic_kali.ip_configuration[0].private_ip_address
}
