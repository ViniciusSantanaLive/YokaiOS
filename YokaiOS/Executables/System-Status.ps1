# YokaiOS - Monitor de Status do Sistema
# Mostra o uso atual de recursos do sistema

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Monitor do Sistema

"@ -ForegroundColor Cyan

# Uso de CPU
$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
Write-Host "Uso de CPU: $([math]::Round($cpu, 1))%" -ForegroundColor $(if($cpu -lt 30){"Green"}elseif($cpu -lt 70){"Yellow"}else{"Red"})

# Uso de RAM
$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize/1MB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory/1MB, 2)
$usedRAM = [math]::Round($totalRAM - $freeRAM, 2)
$ramPercent = [math]::Round(($usedRAM / $totalRAM) * 100, 1)

Write-Host "Uso de RAM: $usedRAM GB / $totalRAM GB ($ramPercent%)" -ForegroundColor $(if($ramPercent -lt 50){"Green"}elseif($ramPercent -lt 80){"Yellow"}else{"Red"})

# Contagem de Processos
$processCount = (Get-Process).Count
Write-Host "Processos Ativos: $processCount" -ForegroundColor $(if($processCount -lt 80){"Green"}elseif($processCount -lt 120){"Yellow"}else{"Red"})

# Uso de Disco
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
foreach ($disk in $disks) {
    $diskPercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
    Write-Host "Disco $($disk.DeviceID) Livre: $diskPercent%" -ForegroundColor $(if($diskPercent -gt 20){"Green"}else{"Yellow"})
}

# Latencia de Rede
$ping = Test-Connection -ComputerName 1.1.1.1 -Count 4 -ErrorAction SilentlyContinue
if ($ping) {
    $avgLatency = ($ping | Measure-Object -Property Latency -Average).Average
    Write-Host "Latencia de Rede (Cloudflare): $([math]::Round($avgLatency, 1))ms" -ForegroundColor $(if($avgLatency -lt 30){"Green"}elseif($avgLatency -lt 100){"Yellow"}else{"Red"})
}

# Top 5 Processos por CPU
Write-Host "`nTop 5 Processos por CPU:" -ForegroundColor Yellow
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, @{N='CPU(s)';E={[math]::Round($_.CPU, 1)}}, @{N='RAM(MB)';E={[math]::Round($_.WorkingSet64/1MB, 1)}} | Format-Table -AutoSize

# Top 5 Processos por RAM
Write-Host "Top 5 Processos por RAM:" -ForegroundColor Yellow
Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name, @{N='RAM(MB)';E={[math]::Round($_.WorkingSet64/1MB, 1)}}, @{N='CPU(s)';E={[math]::Round($_.CPU, 1)}} | Format-Table -AutoSize

Write-Host ""
