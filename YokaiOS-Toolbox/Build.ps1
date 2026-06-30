# YokaiOS Toolbox - Build Script
# Compila a toolbox como .exe

param(
    [string]$Configuration = "Release",
    [string]$Platform = "x64"
)

$ErrorActionPreference = "Stop"

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Build Toolbox v2.0

"@ -ForegroundColor Cyan

$projectPath = "$PSScriptRoot\YokaiOS-Toolbox\YokaiOS-Toolbox.csproj"
$outputPath = "$PSScriptRoot\publish"

# Verificar .NET SDK
Write-Host "[*] Verificando .NET SDK..." -ForegroundColor Yellow
$dotnet = dotnet --version 2>$null
if (-not $dotnet) {
    Write-Host "[!] .NET SDK nao encontrado!" -ForegroundColor Red
    Write-Host "[*] Instale: https://dotnet.microsoft.com/download/dotnet/8.0" -ForegroundColor Yellow
    exit 1
}
Write-Host "[+] .NET SDK: $dotnet" -ForegroundColor Green

# Restaurar pacotes
Write-Host "[*] Restaurando pacotes..." -ForegroundColor Yellow
dotnet restore $projectPath

# Compilar
Write-Host "[*] Compilando ($Configuration/$Platform)..." -ForegroundColor Yellow
dotnet publish $projectPath -c $Configuration -r win-$Platform --self-contained true -p:PublishSingleFile=true -o $outputPath

if ($LASTEXITCODE -eq 0) {
    $exePath = "$outputPath\YokaiOS-Toolbox.exe"
    if (Test-Path $exePath) {
        $size = (Get-Item $exePath).Length / 1MB
        Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                    Build Concluido!                           ║
╠═══════════════════════════════════════════════════════════════╣
║  Output: $exePath
║  Size:   $([math]::Round($size, 2)) MB
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Green
    }
} else {
    Write-Host "[!] Erro na compilacao!" -ForegroundColor Red
}
