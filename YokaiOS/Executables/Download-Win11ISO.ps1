# YokaiOS - Download do Windows 11 para VM
# Baixa a ISO oficial do Windows 11

$ErrorActionPreference = "Stop"

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Download Windows 11 ISO

"@ -ForegroundColor Cyan

Write-Host "[*] Abrindo pagina de download oficial da Microsoft..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Instrucoes:" -ForegroundColor Cyan
Write-Host "1. A pagina oficial da Microsoft vai abrir" -ForegroundColor White
Write-Host "2. Selecione 'Windows 11 (multi-edition ISO)'" -ForegroundColor White
Write-Host "3. Clique em 'Download'" -ForegroundColor White
Write-Host "4. Selecione o idioma 'Portugues (Brasil)'" -ForegroundColor White
Write-Host "5. Clique em 'Confirmar'" -ForegroundColor White
Write-Host "6. Clique em '64-bit Download'" -ForegroundColor White
Write-Host "7. Salve na pasta C:\VMs\ISOs\" -ForegroundColor White
Write-Host ""

# Criar pasta para ISOs
New-Item -ItemType Directory -Path "C:\VMs\ISOs" -Force | Out-Null

# Abrir pagina de download
Start-Process "https://www.microsoft.com/pt-br/software-download/windows11"

Write-Host "[*] Apos baixar a ISO, execute o Setup-VM.ps1 com o caminho da ISO:" -ForegroundColor Yellow
Write-Host ""
Write-Host '    .\Setup-VM.ps1 -ISOPath "C:\VMs\ISOs\Win11_23H2_Brazilian_x64.iso"' -ForegroundColor Green
Write-Host ""
