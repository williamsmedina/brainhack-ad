# brainhack-ad

# Despliegue de Laboratorio Vulnerable de AD en Azure con Terraform
**Terraform Azure En Desarrollo**

## 📄 Tabla de Contenidos
- [Introducción](#introducción)
- [Características](#características)
- [Prerrequisitos](#prerrequisitos)
- [Instalación](#instalación)
- [Acciones Post-Despliegue](#acciones-post-despliegue)
- [Estado de Desarrollo](#estado-de-desarrollo)
- [Mejoras Futuras](#mejoras-futuras)

## 🎉 Introducción
Bienvenido a este repositorio de **Despliegue de Laboratorio Vulnerable de AD en Azure con Terraform**.  
Este proyecto utiliza Terraform para desplegar un entorno vulnerable de Active Directory en Azure, ideal para prácticas de ciberseguridad y pruebas de penetración.

## ✨ Características
- **Despliegue Automatizado:** Provisiona máquinas Windows Server 2016 (DC), Windows 10 y Kali Linux.
- **Acceso Seguro:** Utiliza Azure Bastion para RDP/SSH sin exponer puertos.
- **Seguridad de Red:** Configuración de NSG para controlar el tráfico.

## ⚙️ Prerrequisitos
- **Terraform** (>= 1.1.0)
- **Azure CLI** (autenticado)
- **Suscripción de Azure** activa
- **Git** (opcional)

## 🛠 Instalación
1. Clona el repositorio:
   ```bash
      git clone https://github.com/williamsmedina/brainhack-ad.git
      cd brainhack-ad
Inicializa Terraform y aplica:
 
      terraform init
      terraform plan
      terraform apply

🔧 Acciones Post-Despliegue
Promover el Domain Controller:

Conéctate a la máquina Windows Server 2016.
Ejecuta **subir-a-dominio.ps1** (con privilegios de administrador).
Este script genera la contraseña de disaster recovery en disaster-recovery-password.txt y promueve el servidor a DC, reiniciándolo al finalizar.

## Configurar AD (OUs y Usuarios):

Después del reinicio, vuelve a acceder al DC.
Ejecuta **CrearOUsUsuarios.ps1** (con privilegios de administrador).
Este script genera la contraseña para usuarios en user-passwords.txt y crea las OUs y 3 usuarios genéricos en cada sub-OU de "Areas".

🛠️ Estado de Desarrollo
⚠️ Proyecto en desarrollo activo.
Actualmente se despliegan servidor, cliente, Kali Linux y red segura, junto con la configuración inicial de AD.

🔮 Mejoras Futuras
Automatizar la ejecución de scripts post-despliegue.
Ampliar escenarios de vulnerabilidad.
