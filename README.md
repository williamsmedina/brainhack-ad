# brainhack-ad

# Despliegue de Laboratorio Vulnerable de AD en Azure con Terraform
**Terraform Azure En Desarrollo**

## 📄 Tabla de Contenidos
- [brainhack-ad](#brainhack-ad)
- [Despliegue de Laboratorio Vulnerable de AD en Azure con Terraform](#despliegue-de-laboratorio-vulnerable-de-ad-en-azure-con-terraform)
  - [📄 Tabla de Contenidos](#-tabla-de-contenidos)
  - [Introducción](#introducción)
  - [Características](#características)
  - [⚙️ Prerrequisitos](#️-prerrequisitos)
  - [🛠 Instalación](#-instalación)
  - [🔧 Acciones Post-Despliegue](#-acciones-post-despliegue)
  - [Configurar AD (OUs y Usuarios):](#configurar-ad-ous-y-usuarios)
  - [🛠️ En estado de desarrollo](#️-en-estado-de-desarrollo)
  - [Qué tengo que hacer ahora?](#qué-tengo-que-hacer-ahora)

## Introducción
Bienvenido a este repositorio de **Despliegue de Laboratorio Vulnerable de AD en Azure con Terraform**.  
Este proyecto utiliza Terraform para desplegar un entorno vulnerable de Active Directory en Azure, ideal para prácticas de ciberseguridad y pruebas de penetración.

## Características
- **Despliegue Automatizado:** Provisiona máquinas Windows Server 2016 (DC), Windows 10 y Kali Linux.

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

## 🔧 Acciones Post-Despliegue

**Promover el Domain Controller:**

Conéctate a la máquina Windows Server 2016.
Ejecuta **subir-a-dominio.ps1** (con privilegios de administrador).
Este script genera la contraseña de disaster recovery en disaster-recovery-password.txt y promueve el servidor a DC, reiniciándolo al finalizar.

## Configurar AD (OUs y Usuarios):

Después del reinicio, vuelve a acceder al DC.
Ejecuta **CrearOUsUsuarios.ps1** (con privilegios de administrador).
Este script genera la contraseña para usuarios en user-passwords.txt y crea las OUs y 3 usuarios genéricos en cada sub-OU de "Areas".

## 🛠️ En estado de desarrollo
⚠️ Estoy armando esto de a poco hasta que sea un entorno medianamente decente para pruebas
Actualmente se despliegan servidor, cliente, Kali Linux y la red entre ellos, junto con la configuración inicial de AD.

## Qué tengo que hacer ahora?
- Script para configuración de un entorno vulnerable de AD
- Incluir a la PC con Windows 10 en el dominio (o por lo menos contarte cómo se hace aunque hay mucho por ahí)
- Explicar como configurar RDP en Kali Linux
- Explicar escenarios de ataque para probar

Espero que esto te sirva para aprender y disfrutar un poco.
