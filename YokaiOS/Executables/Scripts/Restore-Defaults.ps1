# YokaiOS - Script de Restauracao
# Restaura as configuracoes padrao do Windows

param(
    [switch]$Confirm
)

$ErrorActionPreference = "SilentlyContinue"

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Script de Restauracao

"@ -ForegroundColor Cyan

if (-not $Confirm) {
    $resp = Read-Host "Isso vai restaurar as configuracoes padrao do Windows. Continuar? (s/n)"
    if ($resp -ne "s") {
        Write-Host "[*] Operacao cancelada." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "`n[*] Restaurando servicos..." -ForegroundColor Yellow

$services = @(
    "DiagTrack",
    "dmwappushservice",
    "SysMain",
    "WSearch",
    "wuauserv",
    "DoSvc",
    "Spooler",
    "WerSvc",
    "DPS",
    "PcaSvc",
    "seclogon",
    "SSDPSRV",
    "RetailDemo",
    "WalletService",
    "MapsBroker",
    "iphlpsvc",
    "diagnosticshub.standardcollector.service",
    "wisvc",
    "WdiServiceHost",
    "WdiSystemHost",
    "Wecsvc",
    "UCPD"
)

foreach ($svc in $services) {
    Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $svc -ErrorAction SilentlyContinue
    Write-Host "[+] Servico restaurado: $svc" -ForegroundColor Green
}

Write-Host "`n[*] Restaurando registro..." -ForegroundColor Yellow

$backups = Get-ChildItem "C:\YokaiOS\Backup_*" -ErrorAction SilentlyContinue
if ($backups) {
    $latest = $backups | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $regFiles = Get-ChildItem "$($latest.FullName)\*.reg" -ErrorAction SilentlyContinue
    foreach ($reg in $regFiles) {
        reg import $reg.FullName 2>$null
        Write-Host "[+] Registro importado: $($reg.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "[!] Nenhum backup encontrado" -ForegroundColor Yellow
}

Write-Host "`n[*] Restaurando BCDedit..." -ForegroundColor Yellow

bcdedit /set disabledynamictick default 2>$null
bcdedit /set useplatformclock default 2>$null
bcdedit /set useplatformtick default 2>$null
bcdedit /set tscsyncpolicy default 2>$null
bcdedit /set nx OptIn 2>$null
bcdedit /set debug default 2>$null
bcdedit /timeout 10 2>$null

Write-Host "[+] BCDedit restaurado" -ForegroundColor Green

Write-Host "`n[*] Restaurando plano de energia..." -ForegroundColor Yellow

powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>$null
powercfg /hibernate on 2>$null

Write-Host "[+] Plano de energia restaurado" -ForegroundColor Green

Write-Host "`n[*] Restaurando efeitos visuais..." -ForegroundColor Yellow

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 0 -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value "1" -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value "2" -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 1 -Force

Write-Host "[+] Efeitos visuais restaurados" -ForegroundColor Green

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║              Restauracao Concluida!                           ║
╠═══════════════════════════════════════════════════════════════╣
║  As configuracoes padrao do Windows foram restauradas.        ║
║  Reinicie o computador para aplicar todas as mudancas.        ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

$reboot = Read-Host "Deseja reiniciar agora? (s/n)"
if ($reboot -eq "s") {
    Restart-Computer -Force
}
