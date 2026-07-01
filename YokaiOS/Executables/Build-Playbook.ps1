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
    "Configuration\tweaks.yml",
    "Executables\Install-YokaiOS.ps1"
)

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $sourcePath $file
    if (-not (Test-Path $filePath)) {
        Write-Host "[!] Required file not found: $file" -ForegroundColor Red
        exit 1
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
    
    # Create encrypted 7z archive (AME Wizard requires 7z format, not ZIP)
    & $7zPath a -t7z -p$password -mhe=on $OutputPath "$sourcePath\*" | Out-Null
    
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
║  Format: 7z (encrypted)
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