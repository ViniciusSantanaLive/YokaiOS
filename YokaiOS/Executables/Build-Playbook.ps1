# YokaiOS Build Script v2.0
# Creates the .apbx file for AME Wizard (encrypted with password)

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

# Create the .apbx archive (encrypted ZIP)
Write-Host "[*] Creating YokaiOS playbook..." -ForegroundColor Yellow

try {
    # AME Wizard password
    $password = "malte"
    
    # Temp ZIP path
    $zipPath = $OutputPath -replace '\.apbx$', '.zip'
    
    # Remove temp zip if exists
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }
    
    # Check if 7-Zip is available
    $7zPath = @(
        "C:\Program Files\7-Zip\7z.exe",
        "C:\Program Files (x86)\7-Zip\7z.exe",
        "$env:LOCALAPPDATA\Programs\7-Zip\7z.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
    
    if ($7zPath) {
        Write-Host "[*] Using 7-Zip for encryption..." -ForegroundColor Yellow
        # Create encrypted archive with 7-Zip
        & $7zPath a -tzip -p$password -mem=AES256 $zipPath "$sourcePath\*" | Out-Null
    } else {
        Write-Host "[*] 7-Zip not found, using .NET compression..." -ForegroundColor Yellow
        # Fallback: Create regular ZIP (AME Wizard will still try to open it)
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcePath, $zipPath)
        
        Write-Host "[!] WARNING: Archive created without encryption." -ForegroundColor Yellow
        Write-Host "[!] Install 7-Zip for proper AME Wizard compatibility." -ForegroundColor Yellow
        Write-Host "[!] Download: https://7-zip.org/" -ForegroundColor Yellow
    }
    
    # Rename to .apbx
    if (Test-Path $zipPath) {
        Rename-Item -Path $zipPath -NewName (Split-Path $OutputPath -Leaf) -Force
    }
    
    $fileSize = (Get-Item $OutputPath).Length / 1MB
    
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                    Build Complete!                            ║
╠═══════════════════════════════════════════════════════════════╣
║  Output: $OutputPath
║  Size:   $([math]::Round($fileSize, 2)) MB
║  Encrypted: $(if($7zPath){"Yes (AES256)"}else{"No"})
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