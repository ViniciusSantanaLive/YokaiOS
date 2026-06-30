# ============================================================
# YokaiOS Toolbox v2.0 - Interface Grafica Moderna
# Identidade visual: Roxo/Rosa neon sobre escuro com gradientes
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ============================================================
# CORES YOKAIOS
# ============================================================
$C = @{
    BG          = [System.Drawing.Color]::FromArgb(12, 12, 18)
    BG2         = [System.Drawing.Color]::FromArgb(18, 18, 28)
    CARD        = [System.Drawing.Color]::FromArgb(24, 24, 36)
    CARD_HOVER  = [System.Drawing.Color]::FromArgb(32, 32, 48)
    PURPLE      = [System.Drawing.Color]::FromArgb(139, 92, 246)
    PURPLE_DARK = [System.Drawing.Color]::FromArgb(109, 70, 200)
    PINK        = [System.Drawing.Color]::FromArgb(236, 72, 153)
    BLUE        = [System.Drawing.Color]::FromArgb(59, 130, 246)
    GREEN       = [System.Drawing.Color]::FromArgb(34, 197, 94)
    RED         = [System.Drawing.Color]::FromArgb(239, 68, 68)
    YELLOW      = [System.Drawing.Color]::FromArgb(234, 179, 8)
    WHITE       = [System.Drawing.Color]::FromArgb(241, 245, 249)
    GRAY        = [System.Drawing.Color]::FromArgb(148, 163, 184)
    GRAY_DARK   = [System.Drawing.Color]::FromArgb(71, 85, 105)
    SIDEBAR     = [System.Drawing.Color]::FromArgb(15, 15, 22)
}

$F = @{
    TITLE    = New-Object System.Drawing.Font("Segoe UI Semibold", 20)
    TITLE_SM = New-Object System.Drawing.Font("Segoe UI Semibold", 14)
    SUB      = New-Object System.Drawing.Font("Segoe UI Semibold", 11)
    BODY     = New-Object System.Drawing.Font("Segoe UI", 10)
    BODY_SM  = New-Object System.Drawing.Font("Segoe UI", 9)
    SMALL    = New-Object System.Drawing.Font("Segoe UI", 8)
    MONO     = New-Object System.Drawing.Font("Cascadia Code", 10)
    MONO_SM  = New-Object System.Drawing.Font("Cascadia Code", 9)
    ICON     = New-Object System.Drawing.Font("Segoe MDL2 Assets", 16)
    ICON_SM  = New-Object System.Drawing.Font("Segoe MDL2 Assets", 12)
}

# ============================================================
# COMPONENTES REUTILIZAVEIS
# ============================================================
function New-Panel {
    param([int]$X,[int]$Y,[int]$W,[int]$H,[System.Drawing.Color]$BG=$C.CARD,[int]$Radius=8)
    $p = New-Object System.Windows.Forms.Panel
    $p.Location = New-Object System.Drawing.Point($X,$Y)
    $p.Size = New-Object System.Drawing.Size($W,$H)
    $p.BackColor = $BG
    return $p
}

function New-Label {
    param([string]$Text,[System.Drawing.Font]$Font=$F.BODY,[int]$X,[int]$Y,[int]$W=200,[int]$H=25,[System.Drawing.Color]$FG=$C.WHITE,[System.Windows.Forms.HorizontalAlignment]$Align="Left")
    $l = New-Object System.Windows.Forms.Label
    $l.Text = $Text
    $l.Location = New-Object System.Drawing.Point($X,$Y)
    $l.Size = New-Object System.Drawing.Size($W,$H)
    $l.Font = $Font
    $l.ForeColor = $FG
    $l.BackColor = [System.Drawing.Color]::Transparent
    $l.TextAlign = [System.Drawing.ContentAlignment]::$Align
    return $l
}

function New-Btn {
    param([string]$Text,[System.Drawing.Color]$BG=$C.PURPLE,[int]$X,[int]$Y,[int]$W=180,[int]$H=42)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $Text
    $b.Location = New-Object System.Drawing.Point($X,$Y)
    $b.Size = New-Object System.Drawing.Size($W,$H)
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor = $BG
    $b.ForeColor = $C.WHITE
    $b.Font = $F.BODY
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $b
}

function New-Check {
    param([string]$Text,[bool]$Checked=$true,[int]$X,[int]$Y,[int]$W=350)
    $c = New-Object System.Windows.Forms.CheckBox
    $c.Text = $Text
    $c.Location = New-Object System.Drawing.Point($X,$Y)
    $c.Size = New-Object System.Drawing.Size($W,28)
    $c.ForeColor = $C.WHITE
    $c.BackColor = [System.Drawing.Color]::Transparent
    $c.Font = $F.BODY
    $c.Checked = $Checked
    return $c
}

function New-StatCard {
    param([string]$Title,[string]$Value,[string]$Sub,[int]$X,[int]$Y,[System.Drawing.Color]$Accent=$C.PURPLE)
    $card = New-Panel -X $X -Y $Y -W 175 -H 90
    
    $dot = New-Object System.Windows.Forms.Label
    $dot.Text = [char]0x25CF
    $dot.Location = New-Object System.Drawing.Point(12,12)
    $dot.AutoSize = $true
    $dot.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $dot.ForeColor = $Accent
    $dot.BackColor = [System.Drawing.Color]::Transparent
    $card.Controls.Add($dot)
    
    $card.Controls.Add((New-Label -Text $Title -Font $F.BODY_SM -X 25 -Y 10 -W 140 -H 20 -FG $C.GRAY))
    $card.Controls.Add((New-Label -Text $Value -Font $F.TITLE_SM -X 12 -Y 32 -W 155 -H 35 -FG $C.WHITE))
    $card.Controls.Add((New-Label -Text $Sub -Font $F.SMALL -X 12 -Y 68 -W 155 -H 18 -FG $C.GRAY_DARK))
    return $card
}

function New-SidebarBtn {
    param([string]$Icon,[string]$Text,[int]$Y,[bool]$Active=$false)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = "  $Icon   $Text"
    $b.Location = New-Object System.Drawing.Point(8,$Y)
    $b.Size = New-Object System.Drawing.Size(184,44)
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor = $(if($Active){$C.CARD}else{$C.SIDEBAR})
    $b.ForeColor = $(if($Active){$C.WHITE}else{$C.GRAY})
    $b.Font = $F.BODY
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    $b.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $b.Padding = New-Object System.Windows.Forms.Padding(8,0,0,0)
    return $b
}

# ============================================================
# FORM PRINCIPAL
# ============================================================
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "YokaiOS Toolbox"
$Form.Size = New-Object System.Drawing.Size(1050, 680)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $C.BG
$Form.ForeColor = $C.WHITE
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$Form.DoubleBuffered = $true

# ============================================================
# HEADER
# ============================================================
$Header = New-Panel -X 0 -Y 0 -W 1050 -H 52 -BG $C.BG2

$LogoIcon = New-Label -Text "Y" -Font (New-Object System.Drawing.Font("Segoe UI",18,[System.Drawing.FontStyle]::Bold)) -X 20 -Y 8 -W 35 -H 35 -FG $C.PURPLE
$Header.Controls.Add($LogoIcon)

$LogoText = New-Label -Text "YOKAI OS" -Font (New-Object System.Drawing.Font("Segoe UI Semibold",16)) -X 52 -Y 10 -W 200 -H 32 -FG $C.WHITE
$Header.Controls.Add($LogoText)

$HeaderSub = New-Label -Text "Toolbox v2.0" -Font $F.SMALL -X 165 -Y 14 -W 100 -H 20 -FG $C.GRAY_DARK
$Header.Controls.Add($HeaderSub)

# Botoes da janela
$BtnClose = New-Label -Text "X" -Font (New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)) -X 1010 -Y 10 -W 30 -H 30 -FG $C.GRAY
$BtnClose.Cursor = [System.Windows.Forms.Cursors]::Hand
$BtnClose.Add_Click({ $Form.Close() })
$Header.Controls.Add($BtnClose)

$BtnMin = New-Label -Text "-" -Font (New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)) -X 975 -Y 8 -W 30 -H 30 -FG $C.GRAY
$BtnMin.Cursor = [System.Windows.Forms.Cursors]::Hand
$BtnMin.Add_Click({ $Form.WindowState = "Minimized" })
$Header.Controls.Add($BtnMin)

$Form.Controls.Add($Header)

# ============================================================
# SIDEBAR
# ============================================================
$Sidebar = New-Panel -X 0 -Y 52 -W 200 -H 628 -BG $C.SIDEBAR

$MenuItems = @(
    @{Icon=[char]0xE80F; Text="Dashboard"; Active=$true},
    @{Icon=[char]0xE7FC; Text="Gaming"; Active=$false},
    @{Icon=[char]0xE9F5; Text="Performance"; Active=$false},
    @{Icon=[char]0xE72B; Text="Privacidade"; Active=$false},
    @{Icon=[char]0xE74D; Text="Debloat"; Active=$false},
    @{Icon=[char]0xE774; Text="Rede"; Active=$false},
    @{Icon=[char]0xE7BA; Text="Servicos"; Active=$false},
    @{Icon=[char]0xE9D9; Text="Benchmark"; Active=$false},
    @{Icon=[char]0xE777; Text="Restaurar"; Active=$false}
)

$MenuY = 15
$SidebarBtns = @()
foreach ($item in $MenuItems) {
    $btn = New-SidebarBtn -Icon $item.Icon -Text $item.Text -Y $MenuY -Active $item.Active
    $btn.Tag = $item.Text
    $btn.Add_Click({
        foreach ($b in $SidebarBtns) { $b.BackColor = $C.SIDEBAR; $b.ForeColor = $C.GRAY }
        $this.BackColor = $C.CARD
        $this.ForeColor = $C.WHITE
        Show-Page $this.Tag
    }.GetNewClosure())
    $Sidebar.Controls.Add($btn)
    $SidebarBtns += $btn
    $MenuY += 50
}

$Form.Controls.Add($Sidebar)

# ============================================================
# AREA DE CONTEUDO
# ============================================================
$Content = New-Panel -X 208 -Y 60 -W 834 -H 612 -BG $C.BG
$Form.Controls.Add($Content)

# ============================================================
# PAGES
# ============================================================
$Pages = @{}

# --- DASHBOARD ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Dashboard" -Font $F.TITLE -X 0 -Y 0 -W 400 -H 40))
$pg.Controls.Add((New-Label -Text "Visao geral do sistema e acoes rapidas" -Font $F.BODY_SM -X 0 -Y 35 -W 400 -H 20 -FG $C.GRAY))

# Stat Cards
$pg.Controls.Add((New-StatCard -Title "Processos" -Value "..." -Sub "em execucao" -X 0 -Y 70 -Accent $C.GREEN))
$pg.Controls.Add((New-StatCard -Title "RAM" -Value "..." -Sub "em uso" -X 185 -Y 70 -Accent $C.BLUE))
$pg.Controls.Add((New-StatCard -Title "CPU" -Value "..." -Sub "uso medio" -X 370 -Y 70 -Accent $C.PURPLE))
$pg.Controls.Add((New-StatCard -Title "Servicos" -Value "50+" -Sub "desabilitados" -X 555 -Y 70 -Accent $C.PINK))

# Acoes Rapidasection
$ActionsCard = New-Panel -X 0 -Y 180 -W 730 -H 200
$pg.Controls.Add($ActionsCard)

$ActionsCard.Controls.Add((New-Label -Text "Acoes Rapidas" -Font $F.SUB -X 15 -Y 12 -W 300 -H 25))
$ActionsCard.Controls.Add((New-Label -Text "Execute as otimizacoes com um clique" -Font $F.BODY_SM -X 15 -Y 35 -W 400 -H 20 -FG $C.GRAY))

$BtnApply = New-Btn -Text "Aplicar Todas Otimizacoes" -BG $C.PURPLE -X 15 -Y 70 -W 230 -H 48
$BtnApply.Add_Click({
    $r = [System.Windows.Forms.MessageBox]::Show("Aplicar TODAS as otimizacoes?","YokaiOS","YesNo","Warning")
    if($r -eq "Yes"){ Start-Process powershell.exe -ArgumentList '-STA','-ExecutionPolicy','Bypass','-File',"C:\Users\Administrador\OneDrive - VAIP\Documentos\Hive\YokaiOS\YokaiOS\Executables\Install-YokaiOS.ps1" -Verb RunAs }
})
$ActionsCard.Controls.Add($BtnApply)

$BtnBench = New-Btn -Text "Executar Benchmark" -BG $C.BLUE -X 260 -Y 70 -W 200 -H 48
$BtnBench.Add_Click({ Run-Benchmark })
$ActionsCard.Controls.Add($BtnBench)

$BtnVerify = New-Btn -Text "Verificar Instalacao" -BG $C.CARD_HOVER -X 475 -Y 70 -W 200 -H 48
$BtnVerify.Add_Click({
    $p = "C:\YokaiOS\Scripts\Verify-Installation.ps1"
    if(Test-Path $p){ Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$p`"" }
    else{ [System.Windows.Forms.MessageBox]::Execute("Execute a instalacao primeiro.","YokaiOS","OK","Warning") }
})
$ActionsCard.Controls.Add($BtnVerify)

$BtnToolbox = New-Btn -Text "Abrir Toolbox Avancada" -BG $C.CARD -X 15 -Y 130 -W 230 -H 48
$ActionsCard.Controls.Add($BtnToolbox)

# System Info Card
$SysCard = New-Panel -X 0 -Y 400 -W 730 -H 180
$pg.Controls.Add($SysCard)

$SysCard.Controls.Add((New-Label -Text "Informacoes do Sistema" -Font $F.SUB -X 15 -Y 12 -W 300 -H 25))
$SysCard.Controls.Add((New-Label -Text "Windows 11" -Font $F.BODY -X 15 -Y 45 -W 200 -H 20 -FG $C.GRAY))
$SysCard.Controls.Add((New-Label -Text $env:COMPUTERNAME -Font $F.MONO -X 15 -Y 70 -W 200 -H 20 -FG $C.WHITE))
$SysCard.Controls.Add((New-Label -Text "YokaiOS v2.0" -Font $F.MONO_SM -X 15 -Y 95 -W 200 -H 20 -FG $C.PURPLE))

$Pages["Dashboard"] = $pg

# --- GAMING ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Otimizacoes Gaming" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "Configuracoes para maximo desempenho em jogos" -Font $F.BODY_SM -X 0 -Y 35 -W 500 -H 20 -FG $C.GRAY))

$GameCard = New-Panel -X 0 -Y 70 -W 730 -H 480
$pg.Controls.Add($GameCard)

$GameChecks = @(
    "Desabilitar Game Mode","Desabilitar Game Bar e DVR","Desabilitar Fullscreen Optimizations",
    "Otimizar GPU Scheduling (Hardware)","Otimizar CPU Priority (Win32Priority=38)",
    "Otimizar MMCS (Multimedia Scheduler)","Timer Resolution 0.5ms","Desabilitar Aceleracao do Mouse",
    "Desabilitar Efeitos Visuais","Desabilitar Preempcao de GPU","Input Raw do Mouse (1:1)",
    "Desabilitar Filter Keys"
)

$gy = 15
foreach($chk in $GameChecks){
    $GameCard.Controls.Add((New-Check -Text $chk -X 15 -Y $gy))
    $gy += 32
}

$BtnGame = New-Btn -Text "Aplicar Gaming" -BG $C.PURPLE -X 15 -Y ($gy+15) -W 200 -H 45
$GameCard.Controls.Add($BtnGame)

$Pages["Gaming"] = $pg

# --- PERFORMANCE ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Performance" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "50+ servicos, 60+ tarefas, otimizacoes WinUtil" -Font $F.BODY_SM -X 0 -Y 35 -W 500 -H 20 -FG $C.GRAY))

$PerfCard = New-Panel -X 0 -Y 70 -W 730 -H 480
$pg.Controls.Add($PerfCard)

$PerfChecks = @(
    "Desabilitar 50+ Servicos Desnecessarios","Desabilitar 60+ Tarefas Agendadas",
    "Otimizar Memoria (Sem Compressao)","Otimizar Disco NTFS","Plano Ultimate Performance",
    "Desabilitar Paging Executive","Desabilitar Background Apps","Desabilitar Startup Programs",
    "BCDedit Otimizado","Desabilitar Mitigacoes de CPU","SvcHost Split Threshold",
    "Desabilitar Reserved Storage","Desabilitar Storage Sense","Consumer Features",
    "Delivery Optimization","WPBT","Notifications","IPv6 Preferencial","Teredo",
    "End Task no Taskbar","Explorer Auto Discovery","Menu Contexto Classico",
    "Mostrar Extensoes","Modo Escuro"
)

$py = 15
foreach($chk in $PerfChecks){
    $PerfCard.Controls.Add((New-Check -Text $chk -X 15 -Y $py))
    $py += 32
}

$BtnPerf = New-Btn -Text "Aplicar Performance" -BG $C.PURPLE -X 15 -Y ($py+15) -W 200 -H 45
$PerfCard.Controls.Add($BtnPerf)

$Pages["Performance"] = $pg

# --- PRIVACIDADE ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Privacidade" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "20+ otimizacoes para eliminar telemetria e tracking" -Font $F.BODY_SM -X 0 -Y 35 -W 500 -H 20 -FG $C.GRAY))

$PrivCard = New-Panel -X 0 -Y 70 -W 730 -H 480
$pg.Controls.Add($PrivCard)

$PrivChecks = @(
    "Desabilitar Telemetria","Desabilitar Tracking e Advertising ID","Desabilitar Activity Feed",
    "Desabilitar Cortana","Desabilitar Busca Web (Bing)","Desabilitar Propagandas",
    "Desabilitar Location Tracking","Desabilitar Input Personalization","Desabilitar SmartScreen",
    "Desabilitar Cloud Search","Desabilitar Feedback","Desabilitar WiFi Sense",
    "Desabilitar App Diagnostics","Desabilitar Speech Recognition","Desabilitar Typing Insights",
    "Desabilitar Device Monitoring","Desabilitar Search History","Desabilitar Search Suggestions",
    "Desabilitar Suggested Content","Desabilitar Privacy Experience"
)

$pry = 15
foreach($chk in $PrivChecks){
    $PrivCard.Controls.Add((New-Check -Text $chk -X 15 -Y $pry))
    $pry += 32
}

$BtnPriv = New-Btn -Text "Aplicar Privacidade" -BG $C.PURPLE -X 15 -Y ($pry+15) -W 200 -H 45
$PrivCard.Controls.Add($BtnPriv)

$Pages["Privacidade"] = $pg

# --- DEBLOAT ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Debloat" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "Remocao de bloatware e componentes desnecessarios" -Font $F.BODY_SM -X 0 -Y 35 -W 500 -H 20 -FG $C.GRAY))

$DebloatCard = New-Panel -X 0 -Y 70 -W 730 -H 400
$pg.Controls.Add($DebloatCard)

$DebloatChecks = @(
    "Remover Microsoft Edge","Remover OneDrive","Remover Cortana","Remover Copilot e IA",
    "Remover Widgets","Remover Xbox Apps","Remover Teams","Remover Apps Pre-Instalados",
    "Remover Recall (IA)","Desabilitar Copilot","Desabilitar Consumer Features","Desabilitar WPBT"
)

$dy = 15
foreach($chk in $DebloatChecks){
    $DebloatCard.Controls.Add((New-Check -Text $chk -X 15 -Y $dy))
    $dy += 32
}

$BtnDebloat = New-Btn -Text "Aplicar Debloat" -BG $C.PURPLE -X 15 -Y ($dy+15) -W 200 -H 45
$DebloatCard.Controls.Add($BtnDebloat)

$Pages["Debloat"] = $pg

# --- REDE ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Rede" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "Otimizacoes de rede para baixa latencia" -Font $F.BODY_SM -X 0 -Y 35 -W 500 -H 20 -FG $C.GRAY))

$NetCard = New-Panel -X 0 -Y 70 -W 730 -H 350
$pg.Controls.Add($NetCard)

$NetChecks = @(
    "Desabilitar Algoritmo de Nagle","Otimizar TCP Settings","DNS Cloudflare (1.1.1.1)",
    "Desabilitar Network Throttling","Desabilitar Teredo","IPv4 Preferencial",
    "Desabilitar Network Power Saving","Desabilitar Network Offloads","Flush DNS Cache"
)

$ny = 15
foreach($chk in $NetChecks){
    $NetCard.Controls.Add((New-Check -Text $chk -X 15 -Y $ny))
    $ny += 32
}

$BtnNet = New-Btn -Text "Aplicar Rede" -BG $C.PURPLE -X 15 -Y ($ny+15) -W 200 -H 45
$NetCard.Controls.Add($BtnNet)

$Pages["Rede"] = $pg

# --- SERVICOS ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Servicos" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "50+ servicos desabilitados para reduzir processos em idle" -Font $F.BODY_SM -X 0 -Y 35 -W 600 -H 20 -FG $C.GRAY))

$SvcCard = New-Panel -X 0 -Y 70 -W 730 -H 500
$pg.Controls.Add($SvcCard)

$SvcList = New-Object System.Windows.Forms.ListView
$SvcList.Location = New-Object System.Drawing.Point(10,10)
$SvcList.Size = New-Object System.Drawing.Size(710,480)
$SvcList.BackColor = $C.CARD
$SvcList.ForeColor = $C.WHITE
$SvcList.Font = $F.MONO_SM
$SvcList.View = [System.Windows.Forms.View]::Details
$SvcList.FullRowSelect = $true
$SvcList.Columns.Add("Servico",200)
$SvcList.Columns.Add("Descricao",350)
$SvcList.Columns.Add("Status",100)

$SvcData = @(
    @("DiagTrack","Telemetria do Windows","Desabilitado"),
    @("dmwappushservice","WAP Push","Desabilitado"),
    @("SysMain","Superfetch","Desabilitado"),
    @("WSearch","Indexador de Busca","Desabilitado"),
    @("wuauserv","Windows Update","Desabilitado"),
    @("DoSvc","Delivery Optimization","Desabilitado"),
    @("Spooler","Impressora","Desabilitado"),
    @("Fax","Fax","Desabilitado"),
    @("RemoteRegistry","Registro Remoto","Desabilitado"),
    @("WerSvc","Relatorio de Erros","Desabilitado"),
    @("DPS","Diagnostico","Desabilitado"),
    @("PcaSvc","Compatibilidade","Desabilitado"),
    @("XblAuthManager","Xbox Auth","Desabilitado"),
    @("XblGameSave","Xbox Game Save","Desabilitado"),
    @("XboxNetApiSvc","Xbox Network","Desabilitado"),
    @("lfsvc","Location Service","Desabilitado"),
    @("WbioSrvc","Biometric","Desabilitado"),
    @("WpcMonSvc","Parental Controls","Desabilitado"),
    @("Telemetry","Intel Telemetry","Desabilitado"),
    @("UCPD","UCPD Velocity","Desabilitado")
)

foreach($svc in $SvcData){
    $item = New-Object System.Windows.Forms.ListViewItem($svc[0])
    $item.SubItems.Add($svc[1])
    $item.SubItems.Add($svc[2])
    $item.ForeColor = $C.RED
    $SvcList.Items.Add($item)
}

$SvcCard.Controls.Add($SvcList)

$Pages["Servicos"] = $pg

# --- BENCHMARK ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Benchmark" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "Compare performance antes e depois das otimizacoes" -Font $F.BODY_SM -X 0 -Y 35 -W 500 -H 20 -FG $C.GRAY))

$BenchCard = New-Panel -X 0 -Y 70 -W 730 -H 450
$pg.Controls.Add($BenchCard)

$BenchOutput = New-Object System.Windows.Forms.RichTextBox
$BenchOutput.Location = New-Object System.Drawing.Point(10,10)
$BenchOutput.Size = New-Object System.Drawing.Size(710,380)
$BenchOutput.BackColor = $C.BG2
$BenchOutput.ForeColor = $C.GREEN
$BenchOutput.Font = $F.MONO_SM
$BenchOutput.ReadOnly = $true
$BenchOutput.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$BenchOutput.Text = "Clique em 'Executar Benchmark' para comecar..."
$BenchCard.Controls.Add($BenchOutput)

$BtnBenchRun = New-Btn -Text "Executar Benchmark" -BG $C.PURPLE -X 10 -Y 400 -W 200 -H 40
$BtnBenchRun.Add_Click({ Run-Benchmark })
$BenchCard.Controls.Add($BtnBenchRun)

$Pages["Benchmark"] = $pg

# --- RESTAURAR ---
$pg = New-Object System.Windows.Forms.Panel
$pg.Dock = [System.Windows.Forms.DockStyle]::Fill
$pg.BackColor = $C.BG
$pg.AutoScroll = $true

$pg.Controls.Add((New-Label -Text "Restaurar" -Font $F.TITLE -X 0 -Y 0 -W 500 -H 40))
$pg.Controls.Add((New-Label -Text "Restaure as configuracoes padrao do Windows" -Font $F.BODY_SM -X 0 -Y 35 -W 500 -H 20 -FG $C.GRAY))

$RestoreCard = New-Panel -X 0 -Y 70 -W 730 -H 300
$pg.Controls.Add($RestoreCard)

$RestoreCard.Controls.Add((New-Label -Text "Use se algo parar de funcionar apos as otimizacoes." -Font $F.BODY -X 15 -Y 15 -W 500 -H 25 -FG $C.GRAY))
$RestoreCard.Controls.Add((New-Label -Text "O script de backup foi criado automaticamente antes da instalacao." -Font $F.BODY_SM -X 15 -Y 40 -W 500 -H 20 -FG $C.GRAY_DARK))

$BtnRestore = New-Btn -Text "Restaurar Tudo" -BG $C.RED -X 15 -Y 80 -W 200 -H 48
$BtnRestore.Add_Click({
    $r = [System.Windows.Forms.MessageBox]::Show("Restaurar TODAS as configuracoes padrao?","YokaiOS","YesNo","Warning")
    if($r -eq "Yes"){
        $p = "C:\YokaiOS\Scripts\Restore-Defaults.ps1"
        if(Test-Path $p){ Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$p`"" -Verb RunAs }
    }
})
$RestoreCard.Controls.Add($BtnRestore)

$Pages["Restaurar"] = $pg

# ============================================================
# FUNCOES
# ============================================================
function Show-Page([string]$Name){
    $Content.Controls.Clear()
    if($Pages.ContainsKey($Name)){ $Content.Controls.Add($Pages[$Name]) }
}

function Run-Benchmark{
    $BenchOutput.Clear()
    $BenchOutput.SelectionColor = $C.PURPLE
    $BenchOutput.AppendText("=== YOKAIOS BENCHMARK ===`n")
    $BenchOutput.SelectionColor = $C.GRAY
    $BenchOutput.AppendText("Data: $(Get-Date)`n`n")
    
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $BenchOutput.SelectionColor = $C.GREEN
    $BenchOutput.AppendText("[CPU] Uso: $([math]::Round($cpu,1))%`n")
    
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize/1MB,2)
    $freeRAM = [math]::Round($os.FreePhysicalMemory/1MB,2)
    $usedRAM = [math]::Round($totalRAM - $freeRAM,2)
    $BenchOutput.AppendText("[RAM] Uso: $usedRAM GB / $totalRAM GB`n")
    
    $procCount = (Get-Process).Count
    $BenchOutput.AppendText("[PROC] Processos: $procCount`n")
    
    $svcRun = (Get-Service | Where-Object {$_.Status -eq "Running"}).Count
    $svcDis = (Get-Service | Where-Object {$_.StartType -eq "Disabled"}).Count
    $BenchOutput.AppendText("[SVC] Rodando: $svcRun | Desabilitados: $svcDis`n")
    
    $ping = Test-Connection -ComputerName 1.1.1.1 -Count 4 -ErrorAction SilentlyContinue
    if($ping){
        $avg = ($ping | Measure-Object -Property Latency -Average).Average
        $BenchOutput.AppendText("[NET] Latencia: $([math]::Round($avg,1))ms`n")
    }
    
    $BenchOutput.SelectionColor = $C.PURPLE
    $BenchOutput.AppendText("`n=== CONCLUIDO ===`n")
}

# ============================================================
# DRAG PARA MOVER JANELA
# ============================================================
$Header.Add_MouseDown({
    if($_.Button -eq [System.Windows.Forms.MouseButtons]::Left){
        $global:DragX = $_.X
        $global:DragY = $_.Y
        $global:Dragging = $true
    }
})
$Header.Add_MouseMove({
    if($global:Dragging){
        $Form.Location = New-Object System.Drawing.Point(
            ([System.Windows.Forms.Cursor]::Position.X - $global:DragX),
            ([System.Windows.Forms.Cursor]::Position.Y - $global:DragY)
        )
    }
})
$Header.Add_MouseUp({ $global:Dragging = $false })

# ============================================================
# INICIAR
# ============================================================
Show-Page "Dashboard"
[void]$Form.ShowDialog()
