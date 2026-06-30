# YokaiOS - Script de Verificacao Pos-Instalacao
# Verifica se todas as otimizacoes foram aplicadas corretamente

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Verificacao Pos-Instalacao

"@ -ForegroundColor Cyan

$checks = @()
$passed = 0
$failed = 0

# Verificar Telemetria
$diagtrack = Get-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
if ($diagtrack.StartType -eq "Disabled") {
    $checks += "[OK] Servico de Telemetria Desabilitado"
    $passed++
} else {
    $checks += "[FALHA] Servico de Telemetria Nao Desabilitado"
    $failed++
}

# Verificar Game Mode
$gameMode = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "AllowAutoGameMode" -ErrorAction SilentlyContinue
if ($gameMode.AllowAutoGameMode -eq 0) {
    $checks += "[OK] Game Mode Desabilitado"
    $passed++
} else {
    $checks += "[FALHA] Game Mode Nao Desabilitado"
    $failed++
}

# Verificar Superfetch
$sysmain = Get-Service -Name "SysMain" -ErrorAction SilentlyContinue
if ($sysmain.StartType -eq "Disabled") {
    $checks += "[OK] Superfetch Desabilitado"
    $passed++
} else {
    $checks += "[FALHA] Superfetch Nao Desabilitado"
    $failed++
}

# Verificar Plano de Energia
$powerPlan = powercfg /getactivescheme
if ($powerPlan -match "Ultimate Performance") {
    $checks += "[OK] Plano Ultimate Performance Ativo"
    $passed++
} else {
    $checks += "[FALHA] Plano Nao Definido como Ultimate"
    $failed++
}

# Verificar Apps em Segundo Plano
$bgApps = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -ErrorAction SilentlyContinue
if ($bgApps.GlobalUserDisabled -eq 1) {
    $checks += "[OK] Apps em Segundo Plano Desabilitados"
    $passed++
} else {
    $checks += "[FALHA] Apps em Segundo Plano Nao Desabilitados"
    $failed++
}

# Verificar Compressao de Memoria
$memComp = Get-MMAgent -ErrorAction SilentlyContinue
if ($memComp.MemoryCompression -eq $false) {
    $checks += "[OK] Compressao de Memoria Desabilitada"
    $passed++
} else {
    $checks += "[FALHA] Compressao de Memoria Nao Desabilitada"
    $failed++
}

# Verificar Win32PrioritySeparation
$priority = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -ErrorAction SilentlyContinue
if ($priority.Win32PrioritySeparation -eq 38) {
    $checks += "[OK] Prioridade de CPU Otimizada"
    $passed++
} else {
    $checks += "[FALHA] Prioridade de CPU Nao Otimizada"
    $failed++
}

# Verificar Cortana
$cortana = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
if ($cortana.AllowCortana -eq 0) {
    $checks += "[OK] Cortana Desabilitada"
    $passed++
} else {
    $checks += "[FALHA] Cortana Nao Desabilitada"
    $failed++
}

# Verificar Bing Search
$bing = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -ErrorAction SilentlyContinue
if ($bing.BingSearchEnabled -eq 0) {
    $checks += "[OK] Busca Bing Desabilitada"
    $passed++
} else {
    $checks += "[FALHA] Busca Bing Nao Desabilitada"
    $failed++
}

# Verificar Copilot
$copilot = Get-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -ErrorAction SilentlyContinue
if ($copilot.TurnOffWindowsCopilot -eq 1) {
    $checks += "[OK] Copilot Desabilitado"
    $passed++
} else {
    $checks += "[FALHA] Copilot Nao Desabilitado"
    $failed++
}

# Exibir Resultados
Write-Host "`n=== Resultados da Verificacao ===" -ForegroundColor Yellow
Write-Host ""

foreach ($check in $checks) {
    if ($check -match "OK") {
        Write-Host $check -ForegroundColor Green
    } else {
        Write-Host $check -ForegroundColor Red
    }
}

Write-Host "`n=== Resumo ===" -ForegroundColor Yellow
Write-Host "Aprovados: $passed" -ForegroundColor Green
Write-Host "Reprovados: $failed" -ForegroundColor Red
Write-Host "Total:     $($passed + $failed)" -ForegroundColor Cyan

if ($failed -eq 0) {
    Write-Host "`n[+] Todas as otimizacoes foram aplicadas com sucesso!" -ForegroundColor Green
} else {
    Write-Host "`n[!] Algumas otimizacoes falharam. Verifique o log." -ForegroundColor Yellow
}

# Contar processos
$processCount = (Get-Process).Count
Write-Host "`n[*] Processos ativos: $processCount" -ForegroundColor Cyan
if ($processCount -lt 80) {
    Write-Host "[+] Excelente! Sistema enxuto." -ForegroundColor Green
} elseif ($processCount -lt 120) {
    Write-Host "[!] Aceitavel, mas pode melhorar." -ForegroundColor Yellow
} else {
    Write-Host "[!] Muitos processos ativos. Verifique o que esta rodando." -ForegroundColor Red
}

# Uso de RAM
$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize/1MB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory/1MB, 2)
$usedRAM = [math]::Round($totalRAM - $freeRAM, 2)

Write-Host "[*] RAM em uso: $usedRAM GB / $totalRAM GB" -ForegroundColor Cyan
if ($usedRAM -lt 2) {
    Write-Host "[+] Excelente! Uso de RAM baixo." -ForegroundColor Green
} elseif ($usedRAM -lt 3) {
    Write-Host "[!] Aceitavel." -ForegroundColor Yellow
} else {
    Write-Host "[!] Uso de RAM alto. Verifique o que esta rodando." -ForegroundColor Red
}

Write-Host ""
