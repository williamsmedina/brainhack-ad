# subir-a-dominio.ps1

# Verificar si el cmdlet Install-ADDSForest está disponible. Si no, instalar el rol AD DS e importar el módulo.
if (-not (Get-Command Install-ADDSForest -ErrorAction SilentlyContinue)) {
    Write-Output "El cmdlet Install-ADDSForest no se encontró. Se procederá a instalar el rol AD-Domain-Services..."
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
    Import-Module ADDSDeployment -ErrorAction Stop
}

# Función para generar una contraseña aleatoria 
function Generate-RandomPassword($length) {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{};:,.<>?'
    $password = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $password
}

# Generar la contraseña para disaster recovery y guardarla en el directorio actual
$dsrmPassword = Generate-RandomPassword 14
$drPasswordFile = Join-Path -Path (Get-Location) -ChildPath "disaster-recovery-password.txt"
"Disaster Recovery Password: $dsrmPassword" | Out-File -FilePath $drPasswordFile -Encoding utf8

# Verifica si el equipo ya forma parte de un dominio y lo sube
try {
    $domain = Get-ADDomain -ErrorAction Stop
} catch {
    $domain = $null
}

if ($domain -eq $null) {
    Install-ADDSForest `
        -DomainName "contoso.com" `
        -DomainMode WinThreshold `
        -ForestMode WinThreshold `
        -SafeModeAdministratorPassword (ConvertTo-SecureString $dsrmPassword -AsPlainText -Force) `
        -Force

    Write-Output "Se está promoviendo el controlador de dominio. El sistema se reiniciará automáticamente."
    exit
} else {
    Write-Output "El servidor ya es parte de un dominio."
}