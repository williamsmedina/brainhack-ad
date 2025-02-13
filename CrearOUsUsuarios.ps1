# CrearOUsUsuarios.ps1
# Este script crea un grupo de OUs', 3 usuarios genericos por OU y guarda la contraseña que les asigna en un .txt que se guardará en la ruta donde se ejecute el script 
# Importar el módulo ActiveDirectory para la administración
Import-Module ActiveDirectory

# Función para generar una contraseña aleatoria 
function Generate-RandomPassword($length) {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{};:,.<>?'
    $password = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $password
}

# Generar la contraseña para usuarios y guardar en el directorio actual
$userPassword = Generate-RandomPassword 14
$userPasswordFile = Join-Path -Path (Get-Location) -ChildPath "user-passwords.txt"
"User Password: $userPassword" | Out-File -FilePath $userPasswordFile -Encoding utf8

# Crear OUs y crear usuarios
New-ADOrganizationalUnit -Name "Areas" -Path "DC=contoso,DC=com"
New-ADOrganizationalUnit -Name "IT" -Path "OU=Areas,DC=contoso,DC=com"
New-ADOrganizationalUnit -Name "Administracion" -Path "OU=Areas,DC=contoso,DC=com"
New-ADOrganizationalUnit -Name "RRHH" -Path "OU=Areas,DC=contoso,DC=com"
New-ADOrganizationalUnit -Name "Computadoras" -Path "DC=contoso,DC=com"
New-ADOrganizationalUnit -Name "PCs" -Path "OU=Computadoras,DC=contoso,DC=com"
New-ADOrganizationalUnit -Name "Servidores" -Path "OU=Computadoras,DC=contoso,DC=com"

function Create-GenericUsers($ouDN, $prefix) {
    for ($i = 1; $i -le 3; $i++) {
        $firstName = "$prefix$i"       
        $lastName = "Usuario"           
        $samAccountName = "$prefix$i"  
        New-ADUser -Name "$firstName $lastName" `
                   -GivenName $firstName `
                   -Surname $lastName `
                   -SamAccountName $samAccountName `
                   -UserPrincipalName "$samAccountName@contoso.com" `
                   -AccountPassword (ConvertTo-SecureString $userPassword -AsPlainText -Force) `
                   -Enabled $true `
                   -Path $ouDN
    }
}

$ous = @(
    @{Name="IT"; DN="OU=IT,OU=Areas,DC=contoso,DC=com"},
    @{Name="Administracion"; DN="OU=Administracion,OU=Areas,DC=contoso,DC=com"},
    @{Name="RRHH"; DN="OU=RRHH,OU=Areas,DC=contoso,DC=com"}
)

foreach ($ou in $ous) {
    Create-GenericUsers -ouDN $ou.DN -prefix $ou.Name
}

Write-Output "Creación de OUs y usuarios completada exitosamente."