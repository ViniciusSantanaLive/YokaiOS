# YokaiOS - Setup da VM de Teste no Hyper-V
# Execute como Administrador apos reiniciar

param(
    [string]$ISOPath = "",
    [int]$MemoryGB = 4,
    [int]$CPUs = 2,
    [int]$DiskGB = 64
)

$ErrorActionPreference = "Stop"

Write-Host @"

 ╦ ╦╔═╗╦═╗╦╔═╦  ╔═╗╔═╗
 ║║║║ ║╠╦╝╠╩╗║  ║ ║║ ║
 ╚╩╝╚═╝╩╚═╩ ╩╩═╝╚═╝╚═╝
  Setup VM de Teste - Hyper-V

"@ -ForegroundColor Cyan

$VMName = "YokaiOS-Teste"
$VHDPath = "C:\VMs\$VMName\$VMName.vhdx"
$SwitchName = "Default Switch"

# Criar pasta da VM
Write-Host "[*] Criando pasta da VM..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "C:\VMs\$VMName" -Force | Out-Null

# Criar disco virtual
Write-Host "[*] Criando disco virtual ($DiskGB GB)..." -ForegroundColor Yellow
New-VHD -Path $VHDPath -SizeBytes ($DiskGB * 1GB) -Dynamic | Out-Null

# Criar VM
Write-Host "[*] Criando VM..." -ForegroundColor Yellow
New-VM -Name $VMName `
    -MemoryStartupBytes ($MemoryGB * 1GB) `
    -VHDPath $VHDPath `
    -SwitchName $SwitchName `
    -Generation 2 `
    -Path "C:\VMs\$VMName" | Out-Null

# Configurar processadores
Write-Host "[*] Configurando $CPUs processadores..." -ForegroundColor Yellow
Set-VMProcessor -VMName $VMName -Count $CPUs

# Configurar memoria dinamica
Write-Host "[*] Configurando memoria dinamica..." -ForegroundColor Yellow
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $true -MinimumBytes (2 * 1GB) -MaximumBytes ($MemoryGB * 1GB)

# Habilitar TPM (necessario para Windows 11)
Write-Host "[*] Habilitando TPM..." -ForegroundColor Yellow
Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
Enable-VMTPM -VMName $VMName

# Desabilitar Secure Boot (para instalar mais facil)
Write-Host "[*] Desabilitando Secure Boot..." -ForegroundColor Yellow
Set-VMFirmware -VMName $VMName -EnableSecureBoot Off

# Configurar boot para DVD
if ($ISOPath -and (Test-Path $ISOPath)) {
    Write-Host "[*] Montando ISO: $ISOPath" -ForegroundColor Yellow
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath
    
    # Configurar boot para DVD
    $dvd = Get-VMDvdDrive -VMName $VMName
    Set-VMFirmware -VMName $VMName -FirstBootDevice $dvd
    
    Write-Host "[+] ISO montada com sucesso!" -ForegroundColor Green
}

# Habilitar Nested Virtualization (para testar melhor)
Write-Host "[*] Habilitando virtualizacao aninhada..." -ForegroundColor Yellow
Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true

# Snapshot antes de comecar
Write-Host "[*] Criando snapshot inicial..." -ForegroundColor Yellow
Checkpoint-VM -VMName $VMName -SnapshotName "Estado Inicial"

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║              VM Criada com Sucesso!                           ║
╠═══════════════════════════════════════════════════════════════╣
║  Nome: $VMName
║  RAM: $MemoryGB GB (dinamica)
║  CPU: $CPUs vCPUs
║  Disco: $DiskGB GB
║  TPM: Habilitado
║                                                               ║
║  Para iniciar:                                                ║
║  1. Abra o Gerenciador do Hyper-V                             ║
║  2. Clique com botao direito em $VMName                       ║
║  3. Selecione "Conectar"                                      ║
║  4. Clique em "Iniciar"                                       ║
║                                                               ║
║  Ou execute:                                                  ║
║  Start-VM -Name "$VMName"                                     ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Perguntar se quer iniciar agora
$start = Read-Host "Deseja iniciar a VM agora? (s/n)"
if ($start -eq "s") {
    Start-VM -Name $VMName
    Write-Host "[+] VM iniciada! Conecte pelo Gerenciador do Hyper-V." -ForegroundColor Green
    vmconnect.exe localhost $VMName
}
