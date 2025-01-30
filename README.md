# brainhack-ad
# Despliegue de Laboratorio Vulnerable de AD en Azure con Terraform

![Terraform](https://img.shields.io/badge/Terraform-1.3.0-blue.svg)
![Azure](https://img.shields.io/badge/Azure-Active-blue.svg)
![En Desarrollo](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow.svg)

## 📄 Tabla de Contenidos

- [Introducción](#introducción)
- [Características](#características)
- [Prerrequisitos](#prerrequisitos)
- [Instalación](#instalación)
- [Estructura del Repositorio](#estructura-del-repositorio)
- [Estado de Desarrollo](#estado-de-desarrollo)
- [Mejoras Futuras](#mejoras-futuras)

## 🎉 Introducción

Bienvenido a este repositorio de **Despliegue de Laboratorio Vulnerable de AD en Azure con Terraform**! Este proyecto utiliza **Terraform** para automatizar el despliegue de un entorno vulnerable de Directorio Activo (AD) en **Microsoft Azure**. El laboratorio está diseñado para que entusiastas de la ciberseguridad, estudiantes y profesionales practiquen y mejoren sus habilidades de pruebas de penetración y defensa en un entorno controlado y aislado.

## ✨ Características

- **Despliegue Automatizado**: Provisiona máquinas de Windows Server 2016 (como controlador de AD), cliente Windows 10 y Kali Linux en Azure.
- **Acceso Seguro**: Utiliza **Azure Bastion** para acceso seguro vía RDP/SSH sin exponer puertos a internet.
- **Seguridad de Red**: Configuración de **Grupos de Seguridad de Red (NSG)** para controlar tráfico entrante/saliente.

## ⚙️ Prerrequisitos

Antes de comenzar, asegúrate de cumplir con estos requisitos:

- **Terraform**: Instalado (versión >= 1.1.0)
- **Azure CLI**: Instalado y autenticado
- **Suscripción de Azure**: Suscripción activa con permisos para crear recursos
- **Git**: Instalado para control de versiones (opcional)

## 🛠 Instalación

1. **Clona el Repositorio**

   ```bash
   git clone https://github.com/williamsmedina/brainhack-ad.git
   cd brainhack-ad
Inicializa Terraform

bash
Copy
terraform init
Configura Variables
Edita terraform.tfvars para definir tu región, prefijo de recursos y credenciales.

📂 Estructura del Repositorio
Copy
brainhack-ad/
├── main.tf          # Configuración principal de Terraform
├── variables.tf     # Variables personalizables
├── outputs.tf       # Salidas útiles (IPs, nombres)
├── README.md        # Este archivo
└── terraform.tfvars # Configuración de variables (ignorado por Git)

🛠️ Estado de Desarrollo
⚠️ Advertencia: Este proyecto está en desarrollo activo.

Funcionalidades actuales: Despliegue básico de servidor, cliente, Kali Linux (todavía no lo logro hacer andar, y red segura.

Pendientes: Configuración automatizada de vulnerabilidades, integración con Active Directory.

🔮 Mejoras Futuras.

Implementar escenarios guiados para pruebas de penetración.
