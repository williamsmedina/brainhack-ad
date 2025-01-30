############################################################
# main.tf
############################################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.20.0" 
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#########################
# RESOURCE GROUP
#########################
resource "azurerm_resource_group" "rg_lab" {
  name     = var.resource_group_name
  location = var.location
}

#########################
# VIRTUAL NETWORK & SUBNETS
#########################
resource "azurerm_virtual_network" "vnet_lab" {
  name                = "vnet-brainhack-lab"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name
  address_space       = ["10.10.10.0/24"]
}

resource "azurerm_subnet" "lab_subnet" {
  name                 = "lab-subnet"
  resource_group_name  = azurerm_resource_group.rg_lab.name
  virtual_network_name = azurerm_virtual_network.vnet_lab.name
  address_prefixes     = ["10.10.10.0/25"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_lab.name
  virtual_network_name = azurerm_virtual_network.vnet_lab.name
  address_prefixes     = ["10.10.10.128/27"]
}

#########################
# BASTION HOST
#########################
resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion-brainhack"
  resource_group_name = azurerm_resource_group.rg_lab.name
  location            = azurerm_resource_group.rg_lab.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-brainhack"
  resource_group_name = azurerm_resource_group.rg_lab.name
  location            = azurerm_resource_group.rg_lab.location
  sku                 = "Standard"

  ip_configuration {
    name                 = "ipconf-bastion"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

#########################
# NETWORK SECURITY GROUP
#########################
resource "azurerm_network_security_group" "nsg_lab" {
  name                = "nsg-brainhack-lab"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_subnet_network_security_group_association" "lab_subnet_association" {
  subnet_id                 = azurerm_subnet.lab_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_lab.id
}

#########################
# NICs para las VMs
#########################
resource "azurerm_network_interface" "nic_ad" {
  name                = "nic-ad"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  ip_configuration {
    name                          = "ipconfig-ad"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_w10" {
  name                = "nic-w10"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  ip_configuration {
    name                          = "ipconfig-w10"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_kali" {
  name                = "nic-kali"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  ip_configuration {
    name                          = "ipconfig-kali"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#########################
# MAQUINAS VIRTUALES
#########################

# 1) Windows Server 2016 (vm-ad)
resource "azurerm_windows_virtual_machine" "vm_ad" {
  name                  = "vm-ad"
  resource_group_name   = azurerm_resource_group.rg_lab.name
  location              = azurerm_resource_group.rg_lab.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username_ad
  admin_password        = var.admin_password_ad
  network_interface_ids = [azurerm_network_interface.nic_ad.id]

  # Imagen Windows Server 2016
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_disk {
    name                 = "disk-os-ad"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = {
    role        = "ActiveDirectory"
    environment = "brainhack-lab"
  }
}

# 2) Windows 10 (vm-w10)
resource "azurerm_windows_virtual_machine" "vm_w10" {
  name                  = "vm-w10"
  resource_group_name   = azurerm_resource_group.rg_lab.name
  location              = azurerm_resource_group.rg_lab.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username_w10
  admin_password        = var.admin_password_w10
  network_interface_ids = [azurerm_network_interface.nic_w10.id]

  # Imagen Windows 10 Ajustada
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-ent"   
    version   = "latest"
  }
  os_disk {
    name                 = "disk-os-w10"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = {
    role        = "Windows10-Client"
    environment = "brainhack-lab"
  }
}
# 3) Kali Linux (vm-kali)
resource "azurerm_marketplace_agreement" "kali_marketplace_agreement" {
  publisher = "kali-linux"
  offer     = "kali"
  plan      = "kali-2024-2"
}
resource "azurerm_linux_virtual_machine" "vm_kali" {
  depends_on = [ azurerm_marketplace_agreement.kali_marketplace_agreement ]
  name                  = "vm-kali"
  resource_group_name   = azurerm_resource_group.rg_lab.name
  location              = azurerm_resource_group.rg_lab.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username_kali
  admin_password        = var.admin_password_kali
  network_interface_ids = [azurerm_network_interface.nic_kali.id]
  disable_password_authentication = false

  # Imagen Kali Linux Ajustada
  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = "kali-2024-2"
    version   = "latest"
  }

plan {
    name      = "kali-2024-2"  
    product   = "kali"          
    publisher = "kali-linux"    
  }
  os_disk {
    name                 = "disk-os-kali"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = {
    role        = "attacker"
    environment = "brainhack-lab"
  }

  # Provisioner para Instalar Herramientas de Kali (Opcional, solo si la imagen no viene con ellas)
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y kali-linux-default"
    ]

    connection {
      type     = "ssh"
      user     = var.admin_username_kali
      password = var.admin_password_kali
      host     = azurerm_linux_virtual_machine.vm_kali.private_ip_address
    }
  }
}

