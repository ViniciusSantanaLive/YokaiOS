# YokaiOS - Download e Instalacao da Toolbox
# Baixa a toolbox do GitHub releases e instala

param(
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

$installPath = "$env:ProgramFiles\YokaiOS Toolbox"
$exeName = "YokaiOS-Toolbox.exe"
$downloadUrl = "https://github.com/ViniciusSantanaLive/YokaiOS/releases/latest/download/YokaiOS-Toolbox.exe"

if (-not $Silent) {
    Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Baixando Toolbox...

"@ -ForegroundColor Cyan
}

# Verificar se ja ta instalado
if (Test-Path "$installPath\$exeName") {
    if (-not $Silent) { Write-Host "[+] Toolbox ja instalada" -ForegroundColor Green }
    exit 0
}

# Criar pasta temporaria
$tempDir = Join-Path ([IO.Path]::GetTempPath()) "YokaiOS-Toolbox"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Baixar toolbox
if (-not $Silent) { Write-Host "[*] Baixando de $downloadUrl..." -ForegroundColor Yellow }
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile "$tempDir\$exeName" -UseBasicParsing
} catch {
    if (-not $Silent) { Write-Host "[!] Erro ao baixar. Tentando com curl..." -ForegroundColor Yellow }
    & curl.exe -LSs $downloadUrl -o "$tempDir\$exeName"
}

if (-not (Test-Path "$tempDir\$exeName")) {
    if (-not $Silent) { Write-Host "[!] Falha no download!" -ForegroundColor Red }
    exit 1
}

# Criar pasta de instalacao
New-Item -ItemType Directory -Path $installPath -Force | Out-Null

# Copiar para instalacao
Copy-Item -Path "$tempDir\$exeName" -Destination "$installPath\$exeName" -Force

# Criar atalhos
$shell = New-Object -ComObject WScript.Shell

# Desktop
$shortcut = $shell.CreateShortcut("$env:USERPROFILE\Desktop\YokaiOS Toolbox.lnk")
$shortcut.TargetPath = "$installPath\$exeName"
$shortcut.WorkingDirectory = $installPath
$shortcut.Save()

# Menu Iniciar
$startMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\YokaiOS"
New-Item -ItemType Directory -Path $startMenu -Force | Out-Null
$shortcut2 = $shell.CreateShortcut("$startMenu\YokaiOS Toolbox.lnk")
$shortcut2.TargetPath = "$installPath\$exeName"
$shortcut2.WorkingDirectory = $installPath
$shortcut2.Save()

# Limpar temp
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

if (-not $Silent) {
    Write-Host "[+] Toolbox instalada em $installPath" -ForegroundColor Green
    Write-Host "[+] Atalhos criados na area de trabalho e Menu Iniciar" -ForegroundColor Green
}
