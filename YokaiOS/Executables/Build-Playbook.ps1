# YokaiOS Build Script v2.0
# Creates the .apbx file for AME Wizard (7z encrypted format)

param(
    [string]$OutputPath = ""
)

# Resolve paths relative to script location
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

if ([string]::IsNullOrEmpty($OutputPath)) {
    $OutputPath = Join-Path (Split-Path -Parent $RootDir) "YokaiOS-v2.0.0.apbx"
}

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Build Script v2.0

"@ -ForegroundColor Cyan

$sourcePath = $RootDir

# Verify source exists
if (-not (Test-Path $sourcePath)) {
    Write-Host "[!] Source directory not found: $sourcePath" -ForegroundColor Red
    exit 1
}

# Verify required files
$requiredFiles = @(
    "playbook.conf",
    "Configuration\custom.yml",
    "Executables\Install-YokaiOS.ps1"
)

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $sourcePath $file
    if (-not (Test-Path $filePath)) {
        Write-Host "[!] Required file not found: $file" -ForegroundColor Red
        exit 1
    }
}

# Build the Tauri Toolbox first, so the .apbx always ships the latest exe.
# (Sem este passo o build empacota um exe possivelmente desatualizado.)
$toolboxSrc = Join-Path (Split-Path -Parent $RootDir) "YokaiOS-Toolbox-Tauri"
$toolboxExeOut = Join-Path $toolboxSrc "src-tauri\target\release\yokaios-toolbox.exe"
$toolboxExeDest = Join-Path $sourcePath "Executables\YokaiOS-Toolbox.exe"

if (Test-Path $toolboxSrc) {
    $hasTauri = $false
    try { & cargo tauri --version *> $null; $hasTauri = ($LASTEXITCODE -eq 0) } catch { $hasTauri = $false }

    if ($hasTauri) {
        Write-Host "[*] Building Tauri Toolbox (cargo tauri build)..." -ForegroundColor Yellow
        Push-Location $toolboxSrc
        & cargo tauri build
        $buildOk = ($LASTEXITCODE -eq 0)
        Pop-Location
        if ($buildOk -and (Test-Path $toolboxExeOut)) {
            Copy-Item -Path $toolboxExeOut -Destination $toolboxExeDest -Force
            Write-Host "[*] Toolbox atualizada e copiada para Executables\" -ForegroundColor Green
        } else {
            Write-Host "[!] Build da Toolbox falhou - usando o exe existente em Executables\" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[!] tauri-cli nao encontrado - pulando build da Toolbox (usando exe existente)" -ForegroundColor Yellow
    }
}

# Remove existing output file
if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Force
    Write-Host "[*] Removed existing .apbx file" -ForegroundColor Yellow
}

# Create the .apbx archive (7z encrypted format)
Write-Host "[*] Creating YokaiOS playbook..." -ForegroundColor Yellow

try {
    # AME Wizard password
    $password = "malte"
    
    # Check if 7-Zip is available
    $7zPath = @(
        "C:\Program Files\7-Zip\7z.exe",
        "C:\Program Files (x86)\7-Zip\7z.exe",
        "$env:LOCALAPPDATA\Programs\7-Zip\7z.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
    
    if (-not $7zPath) {
        Write-Host "[!] 7-Zip not found!" -ForegroundColor Red
        Write-Host "[!] Please install 7-Zip from: https://7-zip.org/" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "[*] Using 7-Zip for 7z encryption..." -ForegroundColor Yellow
    
    # Create temp folder structure
    $tempFolder = Join-Path $env:TEMP "YokaiOS-Playbook-Build"
    if (Test-Path $tempFolder) {
        Remove-Item $tempFolder -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
    
    # Copy files to temp folder (maintaining structure)
    Write-Host "[*] Copying files..." -ForegroundColor Yellow
    Copy-Item -Path "$sourcePath\playbook.conf" -Destination $tempFolder -Force
    Copy-Item -Path "$sourcePath\Configuration" -Destination $tempFolder -Recurse -Force
    Copy-Item -Path "$sourcePath\Executables" -Destination $tempFolder -Recurse -Force
    Copy-Item -Path "$sourcePath\Images" -Destination $tempFolder -Recurse -Force
    
    # Create encrypted 7z archive
    Write-Host "[*] Creating encrypted archive..." -ForegroundColor Yellow
    # NOTE: o argumento de senha DEVE ir entre aspas ("-p$password"). Sem as aspas,
    # o PowerShell 5.1 mangla o parametro nativo e o 7-Zip gera um .apbx que NAO
    # decripta com a senha -> o AME rejeita o playbook. (Auditoria 01/07/2026)
    & $7zPath a -t7z "-p$password" $OutputPath "$tempFolder\*" | Out-Null
    
    # Cleanup temp folder
    Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
    
    if (-not (Test-Path $OutputPath)) {
        Write-Host "[!] Failed to create .apbx file" -ForegroundColor Red
        exit 1
    }
    
    $fileSize = (Get-Item $OutputPath).Length / 1MB
    
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                    Build Complete!                            ║
╠═══════════════════════════════════════════════════════════════╣
║  Output: $OutputPath
║  Size:   $([math]::Round($fileSize, 2)) MB
║  Format: 7z (encrypted with password)
║                                                               ║
║  To install:                                                  ║
║  1. Open AME Wizard                                          ║
║  2. Load this playbook                                        ║
║  3. Follow the installation wizard                            ║
║                                                               ║
║  Or install manually:                                         ║
║  1. Open PowerShell as Administrator                          ║
║  2. Run: .\Executables\Install-YokaiOS.ps1                   ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Green

} catch {
    Write-Host "[!] Error creating playbook: $_" -ForegroundColor Red
    exit 1
}