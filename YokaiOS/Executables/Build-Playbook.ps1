# YokaiOS Build Script v2.0
# Creates the .apbx file for AME Wizard

param(
    [string]$OutputPath = "C:\Users\Administrador\OneDrive - VAIP\Documentos\Hive\YokaiOS\YokaiOS-v1.0.0.apbx"
)

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Build Script v2.0

"@ -ForegroundColor Cyan

$sourcePath = "C:\Users\Administrador\OneDrive - VAIP\Documentos\Hive\YokaiOS\YokaiOS"

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

# Create the .apbx archive
Write-Host "[*] Creating YokaiOS playbook..." -ForegroundColor Yellow

try {
    # Compress to ZIP first
    $zipPath = $OutputPath -replace '\.apbx$', '.zip'
    Compress-Archive -Path "$sourcePath\*" -DestinationPath $zipPath -Force
    
    # Rename to .apbx
    Rename-Item -Path $zipPath -NewName (Split-Path $OutputPath -Leaf) -Force
    
    $fileSize = (Get-Item $OutputPath).Length / 1MB
    
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                    Build Complete!                            ║
╠═══════════════════════════════════════════════════════════════╣
║  Output: $OutputPath
║  Size:   $([math]::Round($fileSize, 2)) MB
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
