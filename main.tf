# main.tf

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

# RESOURCE GROUP

resource "azurerm_resource_group" "rg_lab" {
  name     = var.resource_group_name
  location = var.location
}

# VIRTUAL NETWORK & SUBNETS

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

# PUBLIC IPs para cada VM

resource "azurerm_public_ip" "pip_ad" {
  name                = "pip-ad-brainhack"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip_w10" {
  name                = "pip-w10-brainhack"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip_kali" {
  name                = "pip-kali-brainhack"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NETWORK INTERFACES para las VMs (con su respectiva IP pública)

resource "azurerm_network_interface" "nic_ad" {
  name                = "nic-ad"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  ip_configuration {
    name                          = "ipconfig-ad"
    subnet_id                     = azurerm_subnet.lab_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_ad.id
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
    public_ip_address_id          = azurerm_public_ip.pip_w10.id
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
    public_ip_address_id          = azurerm_public_ip.pip_kali.id
  }
}
# NSGs para cada VM


# NSG para vm-ad (Windows Server 2016) - Permite RDP en puerto 3390
resource "azurerm_network_security_group" "nsg_ad" {
  name                = "nsg-ad"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  security_rule {
    name                       = "Allow-RDP-3389"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSG para vm-w10 (Windows 10) - Permite RDP en puerto 3390
resource "azurerm_network_security_group" "nsg_w10" {
  name                = "nsg-w10"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  security_rule {
    name                       = "Allow-RDP-3389"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSG para vm-kali (Linux) - Permite SSH en puerto 623 y RDP en puerto 3390
resource "azurerm_network_security_group" "nsg_kali" {
  name                = "nsg-kali"
  location            = azurerm_resource_group.rg_lab.location
  resource_group_name = azurerm_resource_group.rg_lab.name

  security_rule {
    name                       = "Allow-SSH-23"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "23"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-RDP-3389"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# ASOCIACIONES NSG a las NICs

resource "azurerm_network_interface_security_group_association" "nic_assoc_ad" {
  network_interface_id      = azurerm_network_interface.nic_ad.id
  network_security_group_id = azurerm_network_security_group.nsg_ad.id
}

resource "azurerm_network_interface_security_group_association" "nic_assoc_w10" {
  network_interface_id      = azurerm_network_interface.nic_w10.id
  network_security_group_id = azurerm_network_security_group.nsg_w10.id
}

resource "azurerm_network_interface_security_group_association" "nic_assoc_kali" {
  network_interface_id      = azurerm_network_interface.nic_kali.id
  network_security_group_id = azurerm_network_security_group.nsg_kali.id
}

# MAQUINAS VIRTUALES

# 1) Windows Server 2016 (vm-ad)
resource "azurerm_windows_virtual_machine" "vm_ad" {
  name                  = "vm-ad"
  resource_group_name   = azurerm_resource_group.rg_lab.name
  location              = azurerm_resource_group.rg_lab.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
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
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic_w10.id]

  # Imagen Windows 10 
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
  admin_username        = var.admin_username
  admin_password        = var.admin_password
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

}

