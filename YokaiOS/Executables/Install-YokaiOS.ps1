# YokaiOS Master Installation Script v2.0
# This script orchestrates all optimizations

param(
    [switch]$SkipBackup,
    [switch]$SkipReboot
)

$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

# Banner
Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Windows Gaming Optimizer v2.0

"@ -ForegroundColor Cyan

Write-Host "[*] Starting YokaiOS installation..." -ForegroundColor Yellow

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[!] This script requires Administrator privileges!" -ForegroundColor Red
    Write-Host "[*] Please run as Administrator." -ForegroundColor Yellow
    exit 1
}

# Create backup directory
if (-not $SkipBackup) {
    Write-Host "[*] Creating system backup..." -ForegroundColor Yellow
    $backupPath = "C:\YokaiOS\Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    
    # Backup registry
    reg export HKLM\SOFTWARE "$backupPath\HKLM_SOFTWARE.reg" /y 2>$null
    reg export HKLM\SYSTEM "$backupPath\HKLM_SYSTEM.reg" /y 2>$null
    reg export HKCU\SOFTWARE "$backupPath\HKCU_SOFTWARE.reg" /y 2>$null
    
    Write-Host "[+] Backup created at: $backupPath" -ForegroundColor Green
}

# Function to apply registry tweaks
function Set-RegistryTweak {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Type,
        [string]$Value
    )
    
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
}

# Function to disable service
function Disable-WindowsService {
    param([string]$ServiceName)
    
    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($service) {
        Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
        Set-Service -Name $ServiceName -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "[+] Disabled service: $ServiceName" -ForegroundColor Green
    }
}

Write-Host "`n[*] Phase 1: Disabling Telemetry and Tracking..." -ForegroundColor Yellow

# Disable Telemetry
Disable-WindowsService "DiagTrack"
Disable-WindowsService "dmwappushservice"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "AITEnable" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" "CEIPEnable" "DWord" "0"

Write-Host "[+] Telemetry disabled" -ForegroundColor Green

Write-Host "`n[*] Phase 2: Optimizing Gaming Performance..." -ForegroundColor Yellow

# GPU Optimization
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "DWord" "2"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" "EnablePreemption" "DWord" "0"

# CPU Scheduling
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "DWord" "38"

# Game Mode and Game Bar
Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\GameBar" "AllowAutoGameMode" "DWord" "0"
Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\GameBar" "AutoGameModeEnabled" "DWord" "0"
Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\GameBar" "UseNexusForGameBarEnabled" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "DWord" "0"
Set-RegistryTweak "HKCU:\System\GameConfigStore" "GameDVR_Enabled" "DWord" "0"

# Fullscreen Optimizations
Set-RegistryTweak "HKCU:\System\GameConfigStore" "GameDVR_FSEBehaviorMode" "DWord" "2"
Set-RegistryTweak "HKCU:\System\GameConfigStore" "GameDVR_HonorUserFSEBehaviorMode" "DWord" "1"

# Timer Resolution
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" "GlobalTimerResolutionRequests" "DWord" "1"
bcdedit /set disabledynamictick yes 2>$null
bcdedit /set useplatformtick yes 2>$null
bcdedit /set tscsyncpolicy enhanced 2>$null

# Mouse Optimization
Set-RegistryTweak "HKCU:\Control Panel\Mouse" "MouseSpeed" "String" "0"
Set-RegistryTweak "HKCU:\Control Panel\Mouse" "MouseThreshold1" "String" "0"
Set-RegistryTweak "HKCU:\Control Panel\Mouse" "MouseThreshold2" "String" "0"
Set-RegistryTweak "HKCU:\Control Panel\Mouse" "MouseSensitivity" "String" "10"

# MMCS Optimization
Set-RegistryTweak "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" "DWord" "10"
Set-RegistryTweak "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" "DWord" "8"
Set-RegistryTweak "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" "DWord" "6"
Set-RegistryTweak "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" "String" "High"
Set-RegistryTweak "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "SFIO Priority" "String" "High"

Write-Host "[+] Gaming optimizations applied" -ForegroundColor Green

Write-Host "`n[*] Phase 3: Disabling Unnecessary Services..." -ForegroundColor Yellow

$servicesToDisable = @(
    "SysMain",
    "WSearch",
    "wuauserv",
    "DoSvc",
    "Spooler",
    "Fax",
    "RemoteRegistry",
    "TabletInputService",
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

foreach ($service in $servicesToDisable) {
    Disable-WindowsService $service
}

Write-Host "[+] Services disabled" -ForegroundColor Green

Write-Host "`n[*] Phase 4: Optimizing Memory and Disk..." -ForegroundColor Yellow

# Memory Optimization
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingExecutive" "DWord" "1"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "LargeSystemCache" "DWord" "0"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" "DWord" "0"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" "DWord" "0"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" "DWord" "0"

# Disable Memory Compression
Disable-MMAgent -MemoryCompression 2>$null

# Disk Optimization
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "NtfsDisableLastAccessUpdate" "DWord" "2147483651"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "NtfsDisable8dot3NameCreation" "DWord" "1"

Write-Host "[+] Memory and disk optimized" -ForegroundColor Green

Write-Host "`n[*] Phase 5: Disabling Background Apps..." -ForegroundColor Yellow

Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "DWord" "1"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground" "DWord" "2"

Write-Host "[+] Background apps disabled" -ForegroundColor Green

Write-Host "`n[*] Phase 6: Applying Power Plan..." -ForegroundColor Yellow

# Create and activate Ultimate Performance power plan
powercfg /duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
powercfg /change standby-timeout-ac 0 2>$null
powercfg /change standby-timeout-dc 0 2>$null
powercfg /hibernate off 2>$null

Write-Host "[+] Power plan optimized" -ForegroundColor Green

Write-Host "`n[*] Phase 7: Optimizing Network..." -ForegroundColor Yellow

# TCP Optimization
netsh int tcp set global autotuninglevel=normal 2>$null
netsh int tcp set global ecncapability=disabled 2>$null
netsh int tcp set global timestamps=disabled 2>$null
netsh int tcp set global rss=enabled 2>$null

# DNS Optimization
$adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
foreach ($adapter in $adapters) {
    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses ("1.1.1.1","1.0.0.1") -ErrorAction SilentlyContinue
}

Write-Host "[+] Network optimized" -ForegroundColor Green

Write-Host "`n[*] Phase 8: Privacy Settings..." -ForegroundColor Yellow

# Disable Advertising ID
Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "DWord" "1"

# Disable Activity History
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" "DWord" "0"

# Disable Web Search
Set-RegistryTweak "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "DWord" "1"
Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" "DWord" "0"

# Disable Cortana
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "DWord" "0"

Write-Host "[+] Privacy settings applied" -ForegroundColor Green

Write-Host "`n[*] Phase 9: Removing Bloatware..." -ForegroundColor Yellow

$bloatware = @(
    "Microsoft.BingWeather"
    "Microsoft.BingNews"
    "Microsoft.BingFinance"
    "Microsoft.BingSports"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Todos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Clipchamp.Clipchamp"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.549981C3F5F10"
    "Disney.37853FC22B2CE"
    "SpotifyAB.SpotifyMusic"
    "king.com.CandyCrushSaga"
    "Microsoft.Windows.Copilot"
    "Microsoft.Windows.Ai.Copilot.Provider"
    "Microsoft.Copilot"
    "Microsoft.Windows.Recall"
    "MicrosoftTeams"
    "MSTeams"
)

foreach ($app in $bloatware) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like "*$app*"} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Write-Host "[+] Bloatware removed" -ForegroundColor Green

Write-Host "`n[*] Phase 10: Disabling Visual Effects..." -ForegroundColor Yellow

Set-RegistryTweak "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "DWord" "2"
Set-RegistryTweak "HKCU:\Control Panel\Desktop" "DragFullWindows" "String" "0"
Set-RegistryTweak "HKCU:\Control Panel\Desktop" "FontSmoothing" "String" "0"
Set-RegistryTweak "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate" "String" "0"
Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" "DWord" "0"

Write-Host "[+] Visual effects disabled" -ForegroundColor Green

Write-Host "`n[*] Phase 11: Disabling Scheduled Tasks..." -ForegroundColor Yellow

$tasksToDisable = @(
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "\Microsoft\Windows\Autochk\Proxy"
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "\Microsoft\Windows\Feedback\Siuf\DmClient"
    "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    "\Microsoft\Windows\Maps\MapsToastTask"
    "\Microsoft\Windows\Maps\MapsUpdateTask"
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
    "\Microsoft\Windows\PI\Sqm-Tasks"
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
    "\Microsoft\Windows\DiskFootprint\Diagnostics"
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
    "\Microsoft\Windows\UpdateOrchestrator\Reboot"
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
    "\Microsoft\Windows\TaskScheduler\Maintenance Configurator"
    "\Microsoft\Windows\TaskScheduler\Manual Maintenance"
    "\Microsoft\Windows\TaskScheduler\Regular Maintenance"
)

foreach ($task in $tasksToDisable) {
    Disable-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue
}

Write-Host "[+] Scheduled tasks disabled" -ForegroundColor Green

Write-Host "`n[*] Phase 12: BCDedit Optimizations..." -ForegroundColor Yellow

bcdedit /set disabledynamictick yes 2>$null
bcdedit /set useplatformclock true 2>$null
bcdedit /set useplatformtick yes 2>$null
bcdedit /set tscsyncpolicy enhanced 2>$null
bcdedit /set bootlog no 2>$null
bcdedit /set bootmenupolicy standard 2>$null
bcdedit /timeout 0 2>$null
bcdedit /debug off 2>$null
bcdedit /set debug no 2>$null

Write-Host "[+] BCDedit optimized" -ForegroundColor Green

Write-Host "`n[*] Phase 13: Disabling CPU Mitigations..." -ForegroundColor Yellow

Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverride" "DWord" "3"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverrideMask" "DWord" "3"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "EnableCfg" "DWord" "0"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" "DisableExceptionChainValidation" "DWord" "1"
Set-RegistryTweak "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "MoveImages" "DWord" "0"
bcdedit /set nx AlwaysOff 2>$null

Write-Host "[+] CPU mitigations disabled" -ForegroundColor Green

Write-Host "`n[*] Phase 14: Disabling AI Components..." -ForegroundColor Yellow

Set-RegistryTweak "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot" "DWord" "1"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot" "DWord" "1"
Set-RegistryTweak "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowCopilotButton" "DWord" "0"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" "DisableAIDataAnalysis" "DWord" "1"
Set-RegistryTweak "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" "DisableWindowsAI" "DWord" "1"

Write-Host "[+] AI components disabled" -ForegroundColor Green

# Create YokaiOS folder with tools
Write-Host "`n[*] Phase 15: Creating YokaiOS folder..." -ForegroundColor Yellow

New-Item -ItemType Directory -Path "C:\YokaiOS" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\YokaiOS\Tools" -Force | Out-Null
New-Item -ItemType Directory -Path "C:\YokaiOS\Scripts" -Force | Out-Null

# Create restore script
$restoreScript = @'
# YokaiOS Restore Script
# Run this to restore default Windows settings

Write-Host "[*] Restoring default Windows settings..." -ForegroundColor Yellow

# Restore Services
$services = @("DiagTrack","dmwappushservice","SysMain","WSearch","wuauserv","DoSvc","Spooler","WerSvc","DPS")
foreach ($svc in $services) {
    Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name $svc -ErrorAction SilentlyContinue
}

# Restore Registry
reg import "C:\YokaiOS\Backup_*\*.reg" 2>$null

# Restore BCDedit
bcdedit /set disabledynamictick default 2>$null
bcdedit /set useplatformclock default 2>$null
bcdedit /set useplatformtick default 2>$null
bcdedit /set tscsyncpolicy default 2>$null
bcdedit /set nx OptIn 2>$null

Write-Host "[+] Settings restored. Please reboot." -ForegroundColor Green
'@

$restoreScript | Out-File -FilePath "C:\YokaiOS\Scripts\Restore-Defaults.ps1" -Encoding UTF8

Write-Host "[+] YokaiOS folder created" -ForegroundColor Green

# Install Toolbox
Write-Host "`n[*] Phase 16: Installing YokaiOS Toolbox..." -ForegroundColor Yellow

$toolboxSource = "$PSScriptRoot\YokaiOS-Toolbox.exe"
$toolboxInstallPath = "$env:ProgramFiles\YokaiOS Toolbox"

if (Test-Path $toolboxSource) {
    # Create install directory
    New-Item -ItemType Directory -Path $toolboxInstallPath -Force | Out-Null

    # Copy toolbox
    Copy-Item -Path $toolboxSource -Destination "$toolboxInstallPath\YokaiOS-Toolbox.exe" -Force

    # Create desktop shortcut
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut("$env:USERPROFILE\Desktop\YokaiOS Toolbox.lnk")
    $shortcut.TargetPath = "$toolboxInstallPath\YokaiOS-Toolbox.exe"
    $shortcut.WorkingDirectory = $toolboxInstallPath
    $shortcut.Description = "YokaiOS Toolbox"
    $shortcut.Save()

    # Create public desktop shortcut
    $publicDesktop = "$env:PUBLIC\Desktop"
    if (Test-Path $publicDesktop) {
        $shortcut2 = $shell.CreateShortcut("$publicDesktop\YokaiOS Toolbox.lnk")
        $shortcut2.TargetPath = "$toolboxInstallPath\YokaiOS-Toolbox.exe"
        $shortcut2.WorkingDirectory = $toolboxInstallPath
        $shortcut2.Save()
    }

    # Create Start Menu shortcut
    $startMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\YokaiOS"
    New-Item -ItemType Directory -Path $startMenu -Force | Out-Null
    $shortcut3 = $shell.CreateShortcut("$startMenu\YokaiOS Toolbox.lnk")
    $shortcut3.TargetPath = "$toolboxInstallPath\YokaiOS-Toolbox.exe"
    $shortcut3.WorkingDirectory = $toolboxInstallPath
    $shortcut3.Save()

    # Add to startup (optional, runs minimized)
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "YokaiOS Toolbox" -Value "`"$toolboxInstallPath\YokaiOS-Toolbox.exe`" --minimized"

    Write-Host "[+] Toolbox installed to $toolboxInstallPath" -ForegroundColor Green
    Write-Host "[+] Shortcuts created on Desktop and Start Menu" -ForegroundColor Green
} else {
    Write-Host "[!] Toolbox exe not found at $toolboxSource" -ForegroundColor Yellow
    Write-Host "[*] You can download it later from GitHub releases" -ForegroundColor Yellow
}

# Final message
Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                    YokaiOS Installation Complete!             ║
╠═══════════════════════════════════════════════════════════════╣
║  Your Windows has been optimized for maximum gaming           ║
║  performance. Please reboot to apply all changes.             ║
║                                                               ║
║  Backup location: C:\YokaiOS\Backup_*                         ║
║  Restore script:  C:\YokaiOS\Scripts\Restore-Defaults.ps1     ║
║                                                               ║
║  Expected results:                                            ║
║  - 60-70 processes at idle                                    ║
║  - 1-1.5 GB RAM usage at idle                                 ║
║  - Ultra-low latency                                          ║
║  - Maximum FPS boost                                          ║
║                                                               ║
║  Toolbox: C:\Program Files\YokaiOS Toolbox\                   ║
║  (Atalho na area de trabalho e Menu Iniciar)                  ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

if (-not $SkipReboot) {
    $reboot = Read-Host "Do you want to reboot now? (y/n)"
    if ($reboot -eq "y") {
        Restart-Computer -Force
    }
}
