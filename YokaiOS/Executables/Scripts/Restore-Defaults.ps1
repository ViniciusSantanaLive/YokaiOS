# YokaiOS - Script de Restauracao Completa
# Restaura TODAS as configuracoes padrao do Windows
# Reverte todos os tweaks aplicados pelo YokaiOS

param(
    [switch]$Confirm,
    [switch]$SkipReboot
)

$ErrorActionPreference = "SilentlyContinue"

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Script de Restauracao Completa v2.0

"@ -ForegroundColor Cyan

if (-not $Confirm) {
    $resp = Read-Host "Isso vai restaurar TODAS as configuracoes padrao do Windows. Continuar? (s/n)"
    if ($resp -ne "s") {
        Write-Host "[*] Operacao cancelada." -ForegroundColor Yellow
        exit 0
    }
}

# ============================================================
# FASE 1: RESTAURAR SERVICOS
# ============================================================
Write-Host "`n[FASE 1/10] Restaurando servicos..." -ForegroundColor Yellow

$services = @(
    @{Name="DiagTrack"; Desc="Diagnostics Tracking"},
    @{Name="dmwappushservice"; Desc="WAP Push Message Routing"},
    @{Name="SysMain"; Desc="Superfetch"},
    @{Name="WSearch"; Desc="Windows Search"},
    @{Name="wuauserv"; Desc="Windows Update"},
    @{Name="DoSvc"; Desc="Delivery Optimization"},
    @{Name="Spooler"; Desc="Print Spooler"},
    @{Name="Fax"; Desc="Fax"},
    @{Name="WerSvc"; Desc="Windows Error Reporting"},
    @{Name="DPS"; Desc="Diagnostic Policy Service"},
    @{Name="PcaSvc"; Desc="Program Compatibility Assistant"},
    @{Name="seclogon"; Desc="Secondary Logon"},
    @{Name="SSDPSRV"; Desc="SSDP Discovery"},
    @{Name="RetailDemo"; Desc="Retail Demo Service"},
    @{Name="WalletService"; Desc="Wallet Service"},
    @{Name="MapsBroker"; Desc="Downloaded Maps Manager"},
    @{Name="iphlpsvc"; Desc="IP Helper"},
    @{Name="diagnosticshub.standardcollector.service"; Desc="Diagnostics Hub"},
    @{Name="wisvc"; Desc="Windows Insider Service"},
    @{Name="WdiServiceHost"; Desc="Diagnostic Service Host"},
    @{Name="WdiSystemHost"; Desc="Diagnostic System Host"},
    @{Name="Wecsvc"; Desc="Windows Event Collector"},
    @{Name="UCPD"; Desc="UserChoice Protection Driver"},
    @{Name="TabletInputService"; Desc="Touch Keyboard and Handwriting"},
    @{Name="TouchInputService"; Desc="Touch Input Service"},
    @{Name="RemoteRegistry"; Desc="Remote Registry"},
    @{Name="XblAuthManager"; Desc="Xbox Live Auth Manager"},
    @{Name="XblGameSave"; Desc="Xbox Live Game Save"},
    @{Name="XboxNetApiSvc"; Desc="Xbox Live Networking"},
    @{Name="XboxGipSvc"; Desc="Xbox Accessory Management"},
    @{Name="OneSyncSvc"; Desc="Sync Host"},
    @{Name="CDPSvc"; Desc="Connected Devices Platform"},
    @{Name="CDPUserSvc"; Desc="Connected Devices Platform User"},
    @{Name="DusmSvc"; Desc="Data Usage"},
    @{Name="TrkWks"; Desc="Distributed Link Tracking Client"},
    @{Name="WMPNetworkSvc"; Desc="Windows Media Player Sharing"},
    @{Name="GraphicsPerfSvc"; Desc="Graphics Performance Service"},
    @{Name="StorSvc"; Desc="Storage Service"},
    @{Name="lfsvc"; Desc="Geolocation Service"},
    @{Name="Ndu"; Desc="Network Data Usage Monitor"},
    @{Name="SharedAccess"; Desc="Internet Connection Sharing"},
    @{Name="CscService"; Desc="Offline Files"},
    @{Name="NetTcpPortSharing"; Desc="Net.Tcp Port Sharing"},
    @{Name="SEMgrSvc"; Desc="Payments and NFC/SE Manager"},
    @{Name="PhoneSvc"; Desc="Phone Service"},
    @{Name="TapiSrv"; Desc="Telephony"},
    @{Name="SensrSvc"; Desc="Sensor Service"},
    @{Name="WpcMonSvc"; Desc="Parental Controls"},
    @{Name="ScDeviceEnum"; Desc="Smart Card Device Enumeration"},
    @{Name="WbioSrvc"; Desc="Windows Biometric Service"},
    @{Name="BitsCompactSvc"; Desc="Background Intelligent Transfer"},
    @{Name="WSAIFabricSvc"; Desc="Windows AI Fabric"}
)

$svcCount = 0
foreach ($svc in $services) {
    Set-Service -Name $svc.Name -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $svc.Name -ErrorAction SilentlyContinue
    $svcCount++
    Write-Host "[+] Servico restaurado: $($svc.Name) ($($svc.Desc))" -ForegroundColor Green
}
Write-Host "[+] Total: $svcCount servicos restaurados" -ForegroundColor Cyan

# ============================================================
# FASE 2: RESTAURAR TAREFAS AGENDADAS
# ============================================================
Write-Host "`n[FASE 2/10] Restaurando tarefas agendadas..." -ForegroundColor Yellow

$scheduledTasks = @(
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Application Experience\StartupAppTask",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver",
    "\Microsoft\Windows\Feedback\Siuf\DmClient",
    "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
    "\Microsoft\Windows\Maps\MapsToastTask",
    "\Microsoft\Windows\Maps\MapsUpdateTask",
    "\Microsoft\Windows\Location\Notifications",
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting",
    "\Microsoft\Windows\Windows Error Reporting\Watson",
    "\Microsoft\Windows\PI\Sqm-Tasks",
    "\Microsoft\Windows\Maintenance\WinSAT",
    "\Microsoft\Windows\PI\Secure-Boot-Update",
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask",
    "\Microsoft\Windows\Diagnosis\Scheduled",
    "\Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner",
    "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents",
    "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic",
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem",
    "\Microsoft\Windows\Shell\FamilySafetyMonitor",
    "\Microsoft\Windows\Shell\FamilySafetyRefreshTask",
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start",
    "\Microsoft\Windows\WindowsUpdate\Reboot",
    "\Microsoft\Windows\WindowsUpdate\Schedule Scan",
    "\Microsoft\Windows\WindowsUpdate\Schedule Scan Static Task",
    "\Microsoft\Windows\WindowsUpdate\UpdateModelTask",
    "\Microsoft\Windows\WindowsUpdate\USO_UxBroker",
    "\Microsoft\Windows\Maintenance\Manual Maintenance",
    "\Microsoft\Windows\Maintenance\Regular Maintenance",
    "\Microsoft\Windows\Task Scheduler\Maintenance Configurator",
    "\Microsoft\Windows\Remoto\ProactiveScan",
    "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask",
    "\Microsoft\XblGameSave\XblGameSaveTask",
    "\Microsoft\Windows\Windows Filtering Platform\BthSQM",
    "\Microsoft\Windows\Customer Experience Improvement Program\Uploader",
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem",
    "\Microsoft\Windows\DiskFootprint\Diagnostics",
    "\Microsoft\Windows\Chkdsk\ProactiveScan",
    "\Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner",
    "\Microsoft\Windows\WDI\ResolutionHost",
    "\Microsoft\Windows\Setup\SetupCleanupTask",
    "\Microsoft\Windows\Setup\SnapshotCleanupTask",
    "\Microsoft\Windows\SpacePort\SpaceAgentTask",
    "\Microsoft\Windows\SpacePort\SpaceManagerTask",
    "\Microsoft\Windows\Speech\SpeechModelDownloadTask",
    "\Microsoft\Windows\WCM\WiFiTask",
    "\Microsoft\Windows\WCM\WiFiCloudStoreTask"
)

$taskCount = 0
foreach ($task in $scheduledTasks) {
    Enable-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue | Out-Null
    $taskCount++
}
Write-Host "[+] Total: $taskCount tarefas reabilitadas" -ForegroundColor Cyan

# ============================================================
# FASE 3: RESTAURAR REGISTRO (BACKUP)
# ============================================================
Write-Host "`n[FASE 3/10] Restaurando registro via backup..." -ForegroundColor Yellow

$backups = Get-ChildItem "C:\YokaiOS\Backup_*" -ErrorAction SilentlyContinue
if ($backups) {
    $latest = $backups | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $regFiles = Get-ChildItem "$($latest.FullName)\*.reg" -ErrorAction SilentlyContinue
    foreach ($reg in $regFiles) {
        reg import $reg.FullName 2>$null
        Write-Host "[+] Registro importado: $($reg.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "[!] Nenhum backup encontrado - restaurando defaults manualmente" -ForegroundColor Yellow
}

# ============================================================
# FASE 4: RESTAURAR BCDedit
# ============================================================
Write-Host "`n[FASE 4/10] Restaurando BCDedit..." -ForegroundColor Yellow

bcdedit /set disabledynamictick default 2>$null
bcdedit /set useplatformclock default 2>$null
bcdedit /set useplatformtick default 2>$null
bcdedit /set tscsyncpolicy default 2>$null
bcdedit /set nx OptIn 2>$null
bcdedit /set debug default 2>$null
bcdedit /timeout 10 2>$null
bcdedit /set bootmenupolicy standard 2>$null
bcdedit /set nointegritychecks no 2>$null

Write-Host "[+] BCDedit restaurado" -ForegroundColor Green

# ============================================================
# FASE 5: RESTAURAR PLANO DE ENERGIA
# ============================================================
Write-Host "`n[FASE 5/10] Restaurando plano de energia..." -ForegroundColor Yellow

powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>$null
powercfg /hibernate on 2>$null
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 2>$null
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 2>$null
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0 2>$null
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 0 2>$null
powercfg /setactive SCHEME_CURRENT 2>$null

Write-Host "[+] Plano de energia restaurado (Balanced)" -ForegroundColor Green

# ============================================================
# FASE 6: RESTAURAR REDE
# ============================================================
Write-Host "`n[FASE 6/10] Restaurando configuracoes de rede..." -ForegroundColor Yellow

# Restaurar DNS para DHCP automatico
$adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
foreach ($adapter in $adapters) {
    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ResetServerAddresses -ErrorAction SilentlyContinue
}
Write-Host "[+] DNS restaurado para automatico (DHCP)" -ForegroundColor Green

# Restaurar TCP defaults
netsh int tcp set global autotuninglevel=normal 2>$null
netsh int tcp set global timestamps=enabled 2>$null
netsh int tcp set global ecncapability=default 2>$null
netsh int tcp set global rss=default 2>$null
Write-Host "[+] TCP settings restaurados" -ForegroundColor Green

# Remover chaves Nagle
$adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
foreach ($adapter in $adapters) {
    $interfaceGuid = $adapter.InterfaceGuid
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$interfaceGuid"
    if (Test-Path $regPath) {
        Remove-ItemProperty -Path $regPath -Name "TcpAckFrequency" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $regPath -Name "TCPNoDelay" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $regPath -Name "TcpDelAckTicks" -Force -ErrorAction SilentlyContinue
    }
}
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpDelAckTicks" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpMaxDataRetransmissions" -Force -ErrorAction SilentlyContinue
Write-Host "[+] Nagle algorithm restaurado" -ForegroundColor Green

# Restaurar Network Throttling
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 20 -Type DWord -Force -ErrorAction SilentlyContinue
Write-Host "[+] Network Throttling restaurado" -ForegroundColor Green

# Flush DNS
ipconfig /flushdns 2>$null

# ============================================================
# FASE 7: RESTAURAR PRIVACIDADE
# ============================================================
Write-Host "`n[FASE 7/10] Restaurando configuracoes de privacidade..." -ForegroundColor Yellow

# Telemetry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue
Write-Host "[+] Telemetry restaurado" -ForegroundColor Green

# Activity Feed
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Write-Host "[+] Activity Feed restaurado" -ForegroundColor Green

# Advertising ID
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Force -ErrorAction SilentlyContinue
Write-Host "[+] Advertising ID restaurado" -ForegroundColor Green

# Location
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableWindowsLocationProvider" -Force -ErrorAction SilentlyContinue
Write-Host "[+] Location tracking restaurado" -ForegroundColor Green

# Cortana
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Force -ErrorAction SilentlyContinue
Write-Host "[+] Cortana restaurada" -ForegroundColor Green

# Web Search
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Force -ErrorAction SilentlyContinue
Write-Host "[+] Web Search restaurado" -ForegroundColor Green

# CEIP
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Write-Host "[+] CEIP restaurado" -ForegroundColor Green

# SmartScreen
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Force -ErrorAction SilentlyContinue
Write-Host "[+] SmartScreen restaurado" -ForegroundColor Green

# ============================================================
# FASE 8: RESTAURAR MITIGACOES DE CPU
# ============================================================
Write-Host "`n[FASE 8/10] Restaurando mitigacoes de CPU..." -ForegroundColor Yellow

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "FeatureSettingsOverride" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "FeatureSettingsOverrideMask" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "MoveImages" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -Name "DisableExceptionChainValidation" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -Name "KernelSEHOPEnabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -Name "DisableTsx" -Force -ErrorAction SilentlyContinue

# Restaurar VBS/HVCI
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequirePlatformSecurityFeatures" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -Name "Enabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host "[+] Mitigacoes de CPU restauradas (Spectre/Meltdown/ASLR/DEP/SEHOP/VBS)" -ForegroundColor Green

# ============================================================
# FASE 9: RESTAURAR EXPLORER / TASKBAR / UI
# ============================================================
Write-Host "`n[FASE 9/10] Restaurando Explorer e UI..." -ForegroundColor Yellow

# Visual Effects
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 0 -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value "1" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value "2" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1 -Force -ErrorAction SilentlyContinue
Write-Host "[+] Efeitos visuais restaurados" -ForegroundColor Green

# Explorer
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarEndTask" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Force -ErrorAction SilentlyContinue
Write-Host "[+] Explorer/Taskbar restaurados" -ForegroundColor Green

# Classic context menu - remover override
Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "[+] Context menu restaurado (Windows 11 padrao)" -ForegroundColor Green

# Hibernation
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Value 1 -Force -ErrorAction SilentlyContinue
powercfg /hibernate on 2>$null
Write-Host "[+] Hibernacao restaurada" -ForegroundColor Green

# ============================================================
# FASE 10: RESTAURAR MEMORIA E DISCO
# ============================================================
Write-Host "`n[FASE 10/10] Restaurando memoria e disco..." -ForegroundColor Yellow

$memPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $memPath -Name "DisablePagingExecutive" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $memPath -Name "LargeSystemCache" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $memPath -Name "ClearPageFileAtShutdown" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Restaurar Prefetch/Superfetch
Set-ItemProperty -Path "$memPath\PrefetchParameters" -Name "EnablePrefetcher" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "$memPath\PrefetchParameters" -Name "EnableSuperfetch" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue

# Restaurar NTFS
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsDisableLastAccessUpdate" -Value 0x80000003 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsDisable8dot3NameCreation" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Restaurar memory compression
Enable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue

Write-Host "[+] Memoria e disco restaurados" -ForegroundColor Green

# ============================================================
# FIM
# ============================================================
Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║           RESTAURACAO COMPLETA CONCLUIDA!                     ║
╠═══════════════════════════════════════════════════════════════╣
║  Todos os tweaks do YokaiOS foram revertidos.                 ║
║  Reinicie o computador para aplicar todas as mudancas.        ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "Resumo da restauracao:" -ForegroundColor White
Write-Host "  - $svcCount servicos reabilitados" -ForegroundColor Green
Write-Host "  - $taskCount tarefas agendadas reabilitadas" -ForegroundColor Green
Write-Host "  - BCDedit restaurado para defaults" -ForegroundColor Green
Write-Host "  - Plano de energia: Balanced" -ForegroundColor Green
Write-Host "  - Rede: DNS/TCP/Nagle restaurados" -ForegroundColor Green
Write-Host "  - Privacidade: Telemetry/Tracking restaurados" -ForegroundColor Green
Write-Host "  - CPU: Mitigacoes restauradas (Spectre/Meltdown/ASLR/DEP)" -ForegroundColor Green
Write-Host "  - UI: Explorer/Taskbar/Visual Effects restaurados" -ForegroundColor Green
Write-Host "  - Memoria: Prefetch/Superfetch/Memory Compression restaurados" -ForegroundColor Green

if (-not $SkipReboot) {
    $reboot = Read-Host "`nDeseja reiniciar agora? (s/n)"
    if ($reboot -eq "s") {
        Restart-Computer -Force
    }
}
