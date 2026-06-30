# YokaiOS - Instalacao da Toolbox
# Copia a toolbox para Program Files e cria atalhos

param(
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

$installPath = "$env:ProgramFiles\YokaiOS Toolbox"
$exeName = "YokaiOS-Toolbox.exe"
$sourcePath = "$PSScriptRoot\$exeName"

if (-not $Silent) {
    Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Instalando Toolbox...

"@ -ForegroundColor Cyan
}

# Verificar se ja ta instalado
if (Test-Path "$installPath\$exeName") {
    if (-not $Silent) { Write-Host "[+] Toolbox ja instalada em $installPath" -ForegroundColor Green }
    exit 0
}

# Criar pasta de instalacao
if (-not $Silent) { Write-Host "[*] Criando pasta de instalacao..." -ForegroundColor Yellow }
New-Item -ItemType Directory -Path $installPath -Force | Out-Null

# Copiar exe
if (-not $Silent) { Write-Host "[*] Copiando toolbox..." -ForegroundColor Yellow }
Copy-Item -Path $sourcePath -Destination "$installPath\$exeName" -Force

# Criar atalho na area de trabalho
if (-not $Silent) { Write-Host "[*] Criando atalho na area de trabalho..." -ForegroundColor Yellow }
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("$env:USERPROFILE\Desktop\YokaiOS Toolbox.lnk")
$shortcut.TargetPath = "$installPath\$exeName"
$shortcut.WorkingDirectory = $installPath
$shortcut.Description = "YokaiOS Toolbox - Windows 11 Ultra-Otimizado para Gaming"
$shortcut.Save()

# Criar atalho no menu iniciar
if (-not $Silent) { Write-Host "[*] Criando atalho no Menu Iniciar..." -ForegroundColor Yellow }
$startMenuPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\YokaiOS"
New-Item -ItemType Directory -Path $startMenuPath -Force | Out-Null
$shortcut2 = $shell.CreateShortcut("$startMenuPath\YokaiOS Toolbox.lnk")
$shortcut2.TargetPath = "$installPath\$exeName"
$shortcut2.WorkingDirectory = $installPath
$shortcut2.Description = "YokaiOS Toolbox"
$shortcut2.Save()

# Criar atalho no desktop do usuario publico (aparece pra todos)
$publicDesktop = "$env:PUBLIC\Desktop"
if (Test-Path $publicDesktop) {
    $shortcut3 = $shell.CreateShortcut("$publicDesktop\YokaiOS Toolbox.lnk")
    $shortcut3.TargetPath = "$installPath\$exeName"
    $shortcut3.WorkingDirectory = $installPath
    $shortcut3.Description = "YokaiOS Toolbox"
    $shortcut3.Save()
}

if (-not $Silent) {
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║              Toolbox Instalada com Sucesso!                   ║
╠═══════════════════════════════════════════════════════════════╣
║  Local: $installPath\$exeName
║  Atalho: Area de trabalho + Menu Iniciar
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Green
}
