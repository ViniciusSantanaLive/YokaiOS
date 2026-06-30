# ============================================================
# YokaiOS Toolbox - Interface Grafica de Gerenciamento
# Identidade visual: Roxo/Rosa neon sobre escuro
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ============================================================
# CORES E ESTILO YOKAIOS
# ============================================================
$Colors = @{
    BG_DARK       = [System.Drawing.Color]::FromArgb(18, 18, 24)
    BG_CARD       = [System.Drawing.Color]::FromArgb(28, 28, 38)
    BG_HOVER      = [System.Drawing.Color]::FromArgb(38, 38, 52)
    ACCENT_PURPLE = [System.Drawing.Color]::FromArgb(139, 92, 246)
    ACCENT_PINK   = [System.Drawing.Color]::FromArgb(236, 72, 153)
    ACCENT_BLUE   = [System.Drawing.Color]::FromArgb(59, 130, 246)
    TEXT_PRIMARY   = [System.Drawing.Color]::FromArgb(241, 245, 249)
    TEXT_SECONDARY = [System.Drawing.Color]::FromArgb(148, 163, 184)
    SUCCESS       = [System.Drawing.Color]::FromArgb(34, 197, 94)
    DANGER        = [System.Drawing.Color]::FromArgb(239, 68, 68)
    WARNING       = [System.Drawing.Color]::FromArgb(234, 179, 8)
}

$Fonts = @{
    TITLE   = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    SUB     = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    BODY    = New-Object System.Drawing.Font("Segoe UI", 10)
    SMALL   = New-Object System.Drawing.Font("Segoe UI", 8)
    MONO    = New-Object System.Drawing.Font("Consolas", 9)
}

# ============================================================
# FUNCOES UTILITARIAS
# ============================================================
function New-YokaiButton {
    param([string]$Text, [System.Drawing.Color]$BGColor, [int]$X, [int]$Y, [int]$W = 200, [int]$H = 40)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $Text
    $btn.Location = New-Object System.Drawing.Point($X, $Y)
    $btn.Size = New-Object System.Drawing.Size($W, $H)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = $BGColor
    $btn.ForeColor = $Colors.TEXT_PRIMARY
    $btn.Font = $Fonts.BODY
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $btn
}

function New-YokaiLabel {
    param([string]$Text, [System.Drawing.Font]$Font, [int]$X, [int]$Y, [int]$W = 400, [int]$H = 30, [System.Drawing.Color]$FG = $Colors.TEXT_PRIMARY)
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $Text
    $lbl.Location = New-Object System.Drawing.Point($X, $Y)
    $lbl.Size = New-Object System.Drawing.Size($W, $H)
    $lbl.Font = $Font
    $lbl.ForeColor = $FG
    $lbl.BackColor = [System.Drawing.Color]::Transparent
    return $lbl
}

function New-YokaiPanel {
    param([int]$X, [int]$Y, [int]$W, [int]$H, [System.Drawing.Color]$BG = $Colors.BG_CARD)
    $pnl = New-Object System.Windows.Forms.Panel
    $pnl.Location = New-Object System.Drawing.Point($X, $Y)
    $pnl.Size = New-Object System.Drawing.Size($W, $H)
    $pnl.BackColor = $BG
    return $pnl
}

function New-YokaiCheckBox {
    param([string]$Text, [bool]$Checked, [int]$X, [int]$Y, [int]$W = 300)
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $Text
    $chk.Location = New-Object System.Drawing.Point($X, $Y)
    $chk.Size = New-Object System.Drawing.Size($W, 25)
    $chk.ForeColor = $Colors.TEXT_PRIMARY
    $chk.BackColor = [System.Drawing.Color]::Transparent
    $chk.Font = $Fonts.BODY
    $chk.Checked = $Checked
    return $chk
}

# ============================================================
# JANELA PRINCIPAL
# ============================================================
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "YokaiOS Toolbox v1.0.0"
$Form.Size = New-Object System.Drawing.Size(1000, 700)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $Colors.BG_DARK
$Form.ForeColor = $Colors.TEXT_PRIMARY
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$Form.MaximizeBox = $false

# ============================================================
# HEADER COM LOGO
# ============================================================
$HeaderPanel = New-YokaiPanel -X 0 -Y 0 -W 1000 -H 80 -BG ([System.Drawing.Color]::FromArgb(15, 15, 20))

$LogoLabel = New-YokaiLabel -Text "YOKAI OS" -Font $Fonts.TITLE -X 20 -Y 15 -W 300 -H 50 -FG $Colors.ACCENT_PURPLE
$HeaderPanel.Controls.Add($LogoLabel)

$SubLabel = New-YokaiLabel -Text "Windows 11 Ultra-Otimizado para Gaming" -Font $Fonts.SMALL -X 20 -Y 50 -W 400 -H 20 -FG $Colors.TEXT_SECONDARY
$HeaderPanel.Controls.Add($SubLabel)

$VersionLabel = New-YokaiLabel -Text "v1.0.0" -Font $Fonts.MONO -X 900 -Y 30 -W 80 -H 25 -FG $Colors.TEXT_SECONDARY
$HeaderPanel.Controls.Add($VersionLabel)

$Form.Controls.Add($HeaderPanel)

# ============================================================
# MENU LATERAL
# ============================================================
$MenuPanel = New-YokaiPanel -X 0 -Y 80 -W 200 -H 620 -BG ([System.Drawing.Color]::FromArgb(20, 20, 28))

$MenuItems = @(
    @{Text = "Dashboard"; Icon = "[*]"},
    @{Text = "Gaming"; Icon = "[G]"},
    @{Text = "Performance"; Icon = "[P]"},
    @{Text = "Privacidade"; Icon = "[L]"},
    @{Text = "Debloat"; Icon = "[D]"},
    @{Text = "Rede"; Icon = "[N]"},
    @{Text = "Servicos"; Icon = "[S]"},
    @{Text = "Benchmark"; Icon = "[B]"},
    @{Text = "Restaurar"; Icon = "[R]"}
)

$MenuY = 20
foreach ($item in $MenuItems) {
    $MenuBtn = New-YokaiButton -Text "$($item.Icon) $($item.Text)" -BGColor $Colors.BG_CARD -X 10 -Y $MenuY -W 180 -H 40
    $MenuBtn.Tag = $item.Text
    $MenuBtn.Add_Click({
        $PageName = $this.Tag
        Show-Page -PageName $PageName
    }.GetNewClosure())
    $MenuPanel.Controls.Add($MenuBtn)
    $MenuY += 50
}
$Form.Controls.Add($MenuPanel)

# ============================================================
# AREA DE CONTEUDO
# ============================================================
$ContentPanel = New-YokaiPanel -X 210 -Y 90 -W 770 -H 590
$Form.Controls.Add($ContentPanel)

# ============================================================
# PAGES
# ============================================================
$Pages = @{}

# --- DASHBOARD ---
$DashboardPage = New-Object System.Windows.Forms.Panel
$DashboardPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$DashboardPage.BackColor = $Colors.BG_DARK

$DashTitle = New-YokaiLabel -Text "Dashboard" -Font $Fonts.TITLE -X 20 -Y 10 -W 400 -H 40
$DashboardPage.Controls.Add($DashTitle)

# Status Cards
$StatusCards = @(
    @{Title = "Processos"; Value = "..."; Y = 60},
    @{Title = "RAM em Uso"; Value = "..."; Y = 160},
    @{Title = "CPU"; Value = "..."; Y = 260},
    @{Title = "Servicos YokaiOS"; Value = "40+ Desabilitados"; Y = 360}
)

foreach ($card in $StatusCards) {
    $CardPanel = New-YokaiPanel -X 20 -Y $card.Y -W 170 -H 80
    $CardTitle = New-YokaiLabel -Text $card.Title -Font $Fonts.SMALL -X 10 -Y 5 -W 150 -H 20 -FG $Colors.TEXT_SECONDARY
    $CardValue = New-YokaiLabel -Text $card.Value -Font $Fonts.SUB -X 10 -Y 30 -W 150 -H 40 -FG $Colors.ACCENT_PURPLE
    $CardPanel.Controls.Add($CardTitle)
    $CardPanel.Controls.Add($CardValue)
    $DashboardPage.Controls.Add($CardPanel)
}

# Quick Actions
$QuickTitle = New-YokaiLabel -Text "Acoes Rapidas" -Font $Fonts.SUB -X 20 -Y 460 -W 300 -H 30
$DashboardPage.Controls.Add($QuickTitle)

$BtnApplyAll = New-YokaiButton -Text "Aplicar Todas Otimizacoes" -BGColor $Colors.ACCENT_PURPLE -X 20 -Y 500 -W 250 -H 45
$BtnApplyAll.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Isso vai aplicar TODAS as otimizacoes do YokaiOS. Continuar?", "Confirmar", "YesNo", "Warning")
    if ($result -eq "Yes") {
        Apply-AllOptimizations
    }
})
$DashboardPage.Controls.Add($BtnApplyAll)

$BtnVerify = New-YokaiButton -Text "Verificar Instalacao" -BGColor $Colors.ACCENT_BLUE -X 290 -Y 500 -W 200 -H 45
$BtnVerify.Add_Click({ Verify-Installation })
$DashboardPage.Controls.Add($BtnVerify)

$Pages["Dashboard"] = $DashboardPage

# --- GAMING ---
$GamingPage = New-Object System.Windows.Forms.Panel
$GamingPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$GamingPage.BackColor = $Colors.BG_DARK

$GamingTitle = New-YokaiLabel -Text "Otimizacoes Gaming" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$GamingPage.Controls.Add($GamingTitle)

$GamingChecks = @(
    @{Text = "Desabilitar Game Mode"; Y = 60},
    @{Text = "Desabilitar Game Bar e DVR"; Y = 90},
    @{Text = "Desabilitar Fullscreen Optimizations"; Y = 120},
    @{Text = "Otimizar GPU Scheduling (Hardware)"; Y = 150},
    @{Text = "Otimizar CPU Priority (Win32Priority=38)"; Y = 180},
    @{Text = "Otimizar MMCS (Multimedia Scheduler)"; Y = 210},
    @{Text = "Timer Resolution 0.5ms"; Y = 240},
    @{Text = "Desabilitar Aceleracao do Mouse"; Y = 270},
    @{Text = "Desabilitar Efeitos Visuais"; Y = 300},
    @{Text = "Desabilitar Preempcao de GPU"; Y = 330},
    @{Text = "Input Raw do Mouse (1:1)"; Y = 360},
    @{Text = "Desabilitar Filter Keys"; Y = 390}
)

$GamingChecksY = 60
foreach ($chk in $GamingChecks) {
    $CheckBox = New-YokaiCheckBox -Text $chk.Text -Checked $true -X 30 -Y $chk.Y -W 400
    $GamingPage.Controls.Add($CheckBox)
}

$BtnApplyGaming = New-YokaiButton -Text "Aplicar Otimizacoes Gaming" -BGColor $Colors.ACCENT_PURPLE -X 20 -Y 500 -W 300 -H 45
$BtnApplyGaming.Add_Click({ Apply-GamingOptimizations })
$GamingPage.Controls.Add($BtnApplyGaming)

$Pages["Gaming"] = $GamingPage

# --- PERFORMANCE ---
$PerfPage = New-Object System.Windows.Forms.Panel
$PerfPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$PerfPage.BackColor = $Colors.BG_DARK

$PerfTitle = New-YokaiLabel -Text "Otimizacoes de Performance" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$PerfPage.Controls.Add($PerfTitle)

$PerfChecks = @(
    @{Text = "Desabilitar 50+ Servicos Desnecessarios"; Y = 60},
    @{Text = "Desabilitar 60+ Tarefas Agendadas"; Y = 90},
    @{Text = "Otimizar Memoria (Sem Compressao)"; Y = 120},
    @{Text = "Otimizar Disco NTFS"; Y = 150},
    @{Text = "Plano de Energia Ultimate Performance"; Y = 180},
    @{Text = "Desabilitar Paging Executive"; Y = 210},
    @{Text = "Desabilitar Background Apps"; Y = 240},
    @{Text = "Desabilitar Startup Programs"; Y = 270},
    @{Text = "BCDedit Otimizado"; Y = 300},
    @{Text = "Desabilitar Mitigacoes de CPU"; Y = 330},
    @{Text = "SvcHost Split Threshold"; Y = 360},
    @{Text = "Desabilitar Reserved Storage"; Y = 390},
    @{Text = "Desabilitar Storage Sense"; Y = 420}
)

foreach ($chk in $PerfChecks) {
    $CheckBox = New-YokaiCheckBox -Text $chk.Text -Checked $true -X 30 -Y $chk.Y -W 400
    $PerfPage.Controls.Add($CheckBox)
}

$BtnApplyPerf = New-YokaiButton -Text "Aplicar Performance" -BGColor $Colors.ACCENT_PURPLE -X 20 -Y 500 -W 300 -H 45
$BtnApplyPerf.Add_Click({ Apply-PerformanceOptimizations })
$PerfPage.Controls.Add($BtnApplyPerf)

$Pages["Performance"] = $PerfPage

# --- PRIVACIDADE ---
$PrivPage = New-Object System.Windows.Forms.Panel
$PrivPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$PrivPage.BackColor = $Colors.BG_DARK

$PrivTitle = New-YokaiLabel -Text "Privacidade" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$PrivPage.Controls.Add($PrivTitle)

$PrivChecks = @(
    @{Text = "Desabilitar Telemetria"; Y = 60},
    @{Text = "Desabilitar Tracking e Advertising ID"; Y = 90},
    @{Text = "Desabilitar Activity Feed / Timeline"; Y = 120},
    @{Text = "Desabilitar Cortana"; Y = 150},
    @{Text = "Desabilitar Busca Web (Bing)"; Y = 180},
    @{Text = "Desabilitar Propagandas"; Y = 210},
    @{Text = "Desabilitar Location Tracking"; Y = 240},
    @{Text = "Desabilitar Input Personalization"; Y = 270},
    @{Text = "Desabilitar SmartScreen"; Y = 300},
    @{Text = "Desabilitar Cloud Search"; Y = 330},
    @{Text = "Desabilitar Feedback Frequency"; Y = 360},
    @{Text = "Desabilitar WiFi Sense"; Y = 390},
    @{Text = "Desabilitar App Diagnostics"; Y = 420}
)

foreach ($chk in $PrivChecks) {
    $CheckBox = New-YokaiCheckBox -Text $chk.Text -Checked $true -X 30 -Y $chk.Y -W 400
    $PrivPage.Controls.Add($CheckBox)
}

$BtnApplyPriv = New-YokaiButton -Text "Aplicar Privacidade" -BGColor $Colors.ACCENT_PURPLE -X 20 -Y 500 -W 300 -H 45
$BtnApplyPriv.Add_Click({ Apply-PrivacyOptimizations })
$PrivPage.Controls.Add($BtnApplyPriv)

$Pages["Privacidade"] = $PrivPage

# --- DEBLOAT ---
$DebloatPage = New-Object System.Windows.Forms.Panel
$DebloatPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$DebloatPage.BackColor = $Colors.BG_DARK

$DebloatTitle = New-YokaiLabel -Text "Remocao de Bloatware" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$DebloatPage.Controls.Add($DebloatTitle)

$DebloatChecks = @(
    @{Text = "Remover Microsoft Edge"; Y = 60},
    @{Text = "Remover OneDrive"; Y = 90},
    @{Text = "Remover Cortana"; Y = 120},
    @{Text = "Remover Copilot e IA"; Y = 150},
    @{Text = "Remover Widgets"; Y = 180},
    @{Text = "Remover Xbox Apps"; Y = 210},
    @{Text = "Remover Teams"; Y = 240},
    @{Text = "Remover Apps Pre-Instalados"; Y = 270},
    @{Text = "Remover Recall (IA)"; Y = 300},
    @{Text = "Desabilitar Copilot"; Y = 330},
    @{Text = "Desabilitar Consumer Features"; Y = 360},
    @{Text = "Desabilitar WPBT"; Y = 390}
)

foreach ($chk in $DebloatChecks) {
    $CheckBox = New-YokaiCheckBox -Text $chk.Text -Checked $true -X 30 -Y $chk.Y -W 400
    $DebloatPage.Controls.Add($CheckBox)
}

$BtnApplyDebloat = New-YokaiButton -Text "Aplicar Debloat" -BGColor $Colors.ACCENT_PURPLE -X 20 -Y 500 -W 300 -H 45
$BtnApplyDebloat.Add_Click({ Apply-DebloatOptimizations })
$DebloatPage.Controls.Add($BtnApplyDebloat)

$Pages["Debloat"] = $DebloatPage

# --- REDE ---
$NetPage = New-Object System.Windows.Forms.Panel
$NetPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$NetPage.BackColor = $Colors.BG_DARK

$NetTitle = New-YokaiLabel -Text "Otimizacoes de Rede" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$NetPage.Controls.Add($NetTitle)

$NetChecks = @(
    @{Text = "Desabilitar Algoritmo de Nagle"; Y = 60},
    @{Text = "Otimizar TCP Settings"; Y = 90},
    @{Text = "DNS Cloudflare (1.1.1.1)"; Y = 120},
    @{Text = "Desabilitar Network Throttling"; Y = 150},
    @{Text = "Desabilitar Teredo"; Y = 180},
    @{Text = "IPv4 Preferencial"; Y = 210},
    @{Text = "Desabilitar Network Power Saving"; Y = 240},
    @{Text = "Desabilitar Network Offloads"; Y = 270},
    @{Text = "Flush DNS Cache"; Y = 300}
)

foreach ($chk in $NetChecks) {
    $CheckBox = New-YokaiCheckBox -Text $chk.Text -Checked $true -X 30 -Y $chk.Y -W 400
    $NetPage.Controls.Add($CheckBox)
}

$BtnApplyNet = New-YokaiButton -Text "Aplicar Rede" -BGColor $Colors.ACCENT_PURPLE -X 20 -Y 500 -W 300 -H 45
$BtnApplyNet.Add_Click({ Apply-NetworkOptimizations })
$NetPage.Controls.Add($BtnApplyNet)

$Pages["Rede"] = $NetPage

# --- SERVICOS ---
$SvcPage = New-Object System.Windows.Forms.Panel
$SvcPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$SvcPage.BackColor = $Colors.BG_DARK

$SvcTitle = New-YokaiLabel -Text "Gerenciamento de Servicos" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$SvcPage.Controls.Add($SvcTitle)

$SvcInfo = New-YokaiLabel -Text "Servicos desabilitados pelo YokaiOS para reduzir processos em idle:" -Font $Fonts.BODY -X 20 -Y 55 -W 700 -H 25 -FG $Colors.TEXT_SECONDARY
$SvcPage.Controls.Add($SvcInfo)

$SvcListBox = New-Object System.Windows.Forms.ListBox
$SvcListBox.Location = New-Object System.Drawing.Point(20, 85)
$SvcListBox.Size = New-Object System.Drawing.Size(730, 400)
$SvcListBox.BackColor = $Colors.BG_CARD
$SvcListBox.ForeColor = $Colors.TEXT_PRIMARY
$SvcListBox.Font = $Fonts.MONO
$SvcListBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None

$ServicesList = @(
    "DiagTrack                - Telemetria do Windows",
    "dmwappushservice         - WAP Push",
    "SysMain                  - Superfetch",
    "WSearch                  - Indexador de Busca",
    "wuauserv                 - Windows Update",
    "DoSvc                    - Delivery Optimization",
    "Spooler                  - Impressora",
    "Fax                      - Fax",
    "RemoteRegistry           - Registro Remoto",
    "TabletInputService       - Teclado Touch",
    "WerSvc                   - Relatorio de Erros",
    "DPS                      - Diagnostico",
    "PcaSvc                   - Assistente de Compatibilidade",
    "seclogon                 - Logon Secundario",
    "SSDPSRV                  - SSDP Discovery",
    "RetailDemo               - Modo Demo",
    "WalletService            - Carteira",
    "MapsBroker               - Mapas",
    "iphlpsvc                 - IPv6 Helper",
    "wisvc                    - Windows Insider",
    "WdiServiceHost           - Diagnostico Host",
    "WdiSystemHost            - Diagnostico Sistema",
    "Wecsvc                   - Event Collector",
    "UCPD                     - UCPD Velocity",
    "Telemetry                - Intel Telemetry",
    "lfsvc                    - Location Service",
    "CscService               - Offline Files",
    "SharedAccess             - ICS",
    "StorSvc                  - Storage Service",
    "Ndu                      - Network Usage",
    "GraphicsPerfSvc          - Graphics Perf",
    "TrkWks                   - Distributed Link",
    "WMPNetworkSvc            - Media Player Network",
    "XblAuthManager           - Xbox Auth",
    "XblGameSave              - Xbox Game Save",
    "XboxNetApiSvc            - Xbox Network",
    "XboxGipSvc               - Xbox Accessory",
    "SEMgrSvc                 - Payments",
    "PhoneSvc                 - Telefone",
    "TapiSrv                  - Telephony",
    "WbioSrvc                 - Biometric",
    "WpcMonSvc                - Parental Controls",
    "ScDeviceEnum             - Device Enum",
    "SensrSvc                 - Sensors",
    "OneSyncSvc               - OneSync",
    "CDPSvc                   - Connected Devices",
    "CDPUserSvc               - Connected Devices User",
    "DusmSvc                  - Data Usage"
)

foreach ($svc in $ServicesList) {
    $SvcListBox.Items.Add($svc) | Out-Null
}
$SvcPage.Controls.Add($SvcListBox)

$Pages["Servicos"] = $SvcPage

# --- BENCHMARK ---
$BenchPage = New-Object System.Windows.Forms.Panel
$BenchPage.Dock = [System.Windows.Forms.DockStyle]::Fill
$BenchPage.BackColor = $Colors.BG_DARK

$BenchTitle = New-YokaiLabel -Text "Benchmark do Sistema" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$BenchPage.Controls.Add($BenchTitle)

$BenchInfo = New-YokaiLabel -Text "Execute o benchmark ANTES e DEPOIS de aplicar as otimizacoes para comparar." -Font $Fonts.BODY -X 20 -Y 55 -W 700 -H 25 -FG $Colors.TEXT_SECONDARY
$BenchPage.Controls.Add($BenchInfo)

$BenchOutput = New-Object System.Windows.Forms.RichTextBox
$BenchOutput.Location = New-Object System.Drawing.Point(20, 90)
$BenchOutput.Size = New-Object System.Drawing.Size(730, 400)
$BenchOutput.BackColor = $Colors.BG_CARD
$BenchOutput.ForeColor = $Colors.SUCCESS
$BenchOutput.Font = $Fonts.MONO
$BenchOutput.ReadOnly = $true
$BenchOutput.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$BenchPage.Controls.Add($BenchOutput)

$BtnBenchRun = New-YokaiButton -Text "Executar Benchmark" -BGColor $Colors.ACCENT_PURPLE -X 20 -Y 500 -W 250 -H 45
$BtnBenchRun.Add_Click({ Run-Benchmark })
$BenchPage.Controls.Add($BtnBenchRun)

$BtnBenchSave = New-YokaiButton -Text "Salvar Resultados" -BGColor $Colors.ACCENT_BLUE -X 290 -Y 500 -W 200 -H 45
$BenchPage.Controls.Add($BtnBenchSave)

$Pages["Benchmark"] = $BenchPage

# --- RESTAURAR ---
$RestorePage = New-Object System.Windows.Forms.Panel
$RestorePage.Dock = [System.Windows.Forms.DockStyle]::Fill
$RestorePage.BackColor = $Colors.BG_DARK

$RestoreTitle = New-YokaiLabel -Text "Restaurar Configuracoes" -Font $Fonts.TITLE -X 20 -Y 10 -W 500 -H 40
$RestorePage.Controls.Add($RestoreTitle)

$RestoreInfo = New-YokaiLabel -Text "Restaura as configuracoes padrao do Windows. Use se algo parar de funcionar." -Font $Fonts.BODY -X 20 -Y 55 -W 700 -H 25 -FG $Colors.TEXT_SECONDARY
$RestorePage.Controls.Add($RestoreInfo)

$BtnRestoreAll = New-YokaiButton -Text "Restaurar Tudo" -BGColor $Colors.DANGER -X 20 -Y 100 -W 250 -H 50
$BtnRestoreAll.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Isso vai restaurar TODAS as configuracoes padrao do Windows. Continuar?", "Confirmar", "YesNo", "Warning")
    if ($result -eq "Yes") {
        Restore-AllDefaults
    }
})
$RestorePage.Controls.Add($BtnRestoreAll)

$BtnRestoreSvc = New-YokaiButton -Text "Restaurar Servicos" -BGColor $Colors.WARNING -X 20 -Y 160 -W 250 -H 45
$RestorePage.Controls.Add($BtnRestoreSvc)

$BtnRestoreReg = New-YokaiButton -Text "Restaurar Registro" -BGColor $Colors.WARNING -X 20 -Y 215 -W 250 -H 45
$RestorePage.Controls.Add($BtnRestoreReg)

$Pages["Restaurar"] = $RestorePage

# ============================================================
# FUNCOES DE NAVEGACAO
# ============================================================
function Show-Page {
    param([string]$PageName)
    $ContentPanel.Controls.Clear()
    if ($Pages.ContainsKey($PageName)) {
        $ContentPanel.Controls.Add($Pages[$PageName])
    }
}

function Apply-AllOptimizations {
    $BenchOutput.AppendText("[*] Aplicando todas as otimizacoes...`n")
    # Chama o script de instalacao
    $scriptPath = Join-Path $PSScriptRoot "Install-YokaiOS.ps1"
    if (Test-Path $scriptPath) {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`" -SkipReboot" -Verb RunAs -Wait
        [System.Windows.Forms.MessageBox]::Show("Otimizacoes aplicadas! Reinicie o computador.", "YokaiOS", "OK", "Information")
    }
}

function Verify-Installation {
    $scriptPath = "C:\YokaiOS\Scripts\Verify-Installation.ps1"
    if (Test-Path $scriptPath) {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`""
    } else {
        [System.Windows.Forms.MessageBox]::Show("Execute a instalacao primeiro.", "YokaiOS", "OK", "Warning")
    }
}

function Run-Benchmark {
    $BenchOutput.Clear()
    $BenchOutput.AppendText("=== YOKAIOS BENCHMARK ===`n")
    $BenchOutput.AppendText("Data: $(Get-Date)`n`n")
    
    # CPU
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $BenchOutput.AppendText("[CPU] Uso: $([math]::Round($cpu, 1))%`n")
    
    # RAM
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize/1MB, 2)
    $freeRAM = [math]::Round($os.FreePhysicalMemory/1MB, 2)
    $usedRAM = [math]::Round($totalRAM - $freeRAM, 2)
    $BenchOutput.AppendText("[RAM] Uso: $usedRAM GB / $totalRAM GB`n")
    
    # Processos
    $procCount = (Get-Process).Count
    $BenchOutput.AppendText("[PROC] Processos ativos: $procCount`n")
    
    # Servicos
    $svcRunning = (Get-Service | Where-Object {$_.Status -eq "Running"}).Count
    $BenchOutput.AppendText("[SVC] Servicos rodando: $svcRunning`n")
    
    # Latencia
    $ping = Test-Connection -ComputerName 1.1.1.1 -Count 4 -ErrorAction SilentlyContinue
    if ($ping) {
        $avg = ($ping | Measure-Object -Property Latency -Average).Average
        $BenchOutput.AppendText("[NET] Latencia: $([math]::Round($avg, 1))ms`n")
    }
    
    # Disco
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $diskFree = [math]::Round($disk.FreeSpace/1GB, 2)
    $BenchOutput.AppendText("[DISCO] Espaco livre C: $diskFree GB`n")
    
    $BenchOutput.AppendText("`n=== BENCHMARK CONCLUIDO ===`n")
}

function Restore-AllDefaults {
    $scriptPath = "C:\YokaiOS\Scripts\Restore-Defaults.ps1"
    if (Test-Path $scriptPath) {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    } else {
        [System.Windows.Forms.MessageBox]::Show("Script de restauracao nao encontrado.", "YokaiOS", "OK", "Error")
    }
}

# ============================================================
# INICIAR
# ============================================================
Show-Page -PageName "Dashboard"
[void]$Form.ShowDialog()
