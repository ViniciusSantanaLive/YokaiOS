# YokaiOS - Benchmark do Sistema
# Compara performance antes e depois das otimizacoes

param(
    [string]$OutputFile = "C:\YokaiOS\Benchmark_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
)

$ErrorActionPreference = "SilentlyContinue"

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Benchmark do Sistema

"@ -ForegroundColor Cyan

$results = @()
$results += "=== YOKAIOS BENCHMARK ==="
$results += "Data: $(Get-Date)"
$results += "Computador: $env:COMPUTERNAME"
$results += "Usuario: $env:USERNAME"
$results += ""

# CPU
$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
$results += "[CPU] Uso: $([math]::Round($cpu, 1))%"
Write-Host "[CPU] Uso: $([math]::Round($cpu, 1))%" -ForegroundColor $(if($cpu -lt 30){"Green"}elseif($cpu -lt 70){"Yellow"}else{"Red"})

# RAM
$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize/1MB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory/1MB, 2)
$usedRAM = [math]::Round($totalRAM - $freeRAM, 2)
$ramPercent = [math]::Round(($usedRAM / $totalRAM) * 100, 1)
$results += "[RAM] Uso: $usedRAM GB / $totalRAM GB ($ramPercent%)"
Write-Host "[RAM] Uso: $usedRAM GB / $totalRAM GB ($ramPercent%)" -ForegroundColor $(if($ramPercent -lt 50){"Green"}elseif($ramPercent -lt 80){"Yellow"}else{"Red"})

# Processos
$procCount = (Get-Process).Count
$results += "[PROC] Processos ativos: $procCount"
Write-Host "[PROC] Processos ativos: $procCount" -ForegroundColor $(if($procCount -lt 80){"Green"}elseif($procCount -lt 120){"Yellow"}else{"Red"})

# Servicos
$svcRunning = (Get-Service | Where-Object {$_.Status -eq "Running"}).Count
$svcDisabled = (Get-Service | Where-Object {$_.StartType -eq "Disabled"}).Count
$results += "[SVC] Servicos rodando: $svcRunning | Desabilitados: $svcDisabled"
Write-Host "[SVC] Servicos rodando: $svcRunning | Desabilitados: $svcDisabled" -ForegroundColor Cyan

# Latencia
$ping = Test-Connection -ComputerName 1.1.1.1 -Count 4 -ErrorAction SilentlyContinue
if ($ping) {
    $avg = ($ping | Measure-Object -Property Latency -Average).Average
    $results += "[NET] Latencia (Cloudflare): $([math]::Round($avg, 1))ms"
    Write-Host "[NET] Latencia: $([math]::Round($avg, 1))ms" -ForegroundColor $(if($avg -lt 30){"Green"}elseif($avg -lt 100){"Yellow"}else{"Red"})
}

# Disco
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskFree = [math]::Round($disk.FreeSpace/1GB, 2)
$diskTotal = [math]::Round($disk.Size/1GB, 2)
$results += "[DISCO] C: $diskFree GB livres de $diskTotal GB"
Write-Host "[DISCO] C: $diskFree GB livres de $diskTotal GB" -ForegroundColor Cyan

# Tarefas Agendadas
$tasksEnabled = (Get-ScheduledTask | Where-Object {$_.State -eq "Ready" -or $_.State -eq "Running"}).Count
$tasksDisabled = (Get-ScheduledTask | Where-Object {$_.State -eq "Disabled"}).Count
$results += "[TASKS] Tarefas ativas: $tasksEnabled | Desabilitadas: $tasksDisabled"
Write-Host "[TASKS] Tarefas ativas: $tasksEnabled | Desabilitadas: $tasksDisabled" -ForegroundColor Cyan

# Uptime
$lastBoot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$uptime = (Get-Date) - $lastBoot
$results += "[UPTIME] Ultimo boot: $lastBoot ($([math]::Round($uptime.TotalHours, 1)) horas)"
Write-Host "[UPTIME] Ultimo boot: $lastBoot ($([math]::Round($uptime.TotalHours, 1)) horas)" -ForegroundColor Cyan

# Top Processos
$results += ""
$results += "=== TOP 5 PROCESSOS POR RAM ==="
Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 | ForEach-Object {
    $ramMB = [math]::Round($_.WorkingSet64/1MB, 1)
    $results += "  $($_.Name): $ramMB MB"
}

$results += ""
$results += "=== TOP 5 PROCESSOS POR CPU ==="
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | ForEach-Object {
    $results += "  $($_.Name): $([math]::Round($_.CPU, 1))s"
}

$results += ""
$results += "=== BENCHMARK CONCLUIDO ==="

# Salvar
$results | Out-File -FilePath $OutputFile -Encoding UTF8
Write-Host "`n[+] Resultados salvos em: $OutputFile" -ForegroundColor Green
