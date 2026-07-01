// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::process::Command;
use std::path::Path;
use std::os::windows::process::CommandExt;
use serde::{Deserialize, Serialize};
use tauri::Emitter;

const CREATE_NO_WINDOW: u32 = 0x08000000;

fn is_admin() -> bool {
    let output = Command::new("net")
        .creation_flags(CREATE_NO_WINDOW)
        .args(["session"])
        .output();
    match output {
        Ok(o) => o.status.success(),
        Err(_) => false,
    }
}

fn request_admin() {
    let exe = std::env::current_exe().unwrap_or_default();
    let exe_str = exe.to_str().unwrap_or("");
    Command::new("powershell")
        .creation_flags(CREATE_NO_WINDOW)
        .args(["-Command", &format!("Start-Process '{}' -Verb RunAs", exe_str)])
        .spawn()
        .ok();
}

fn silent_ps() -> Command {
    let mut cmd = Command::new("powershell");
    cmd.creation_flags(CREATE_NO_WINDOW);
    cmd.args(["-ExecutionPolicy", "Bypass", "-NoProfile", "-WindowStyle", "Hidden", "-Command"]);
    cmd
}

fn silent_sc() -> Command {
    let mut cmd = Command::new("sc");
    cmd.creation_flags(CREATE_NO_WINDOW);
    cmd
}

fn silent_reg() -> Command {
    let mut cmd = Command::new("reg");
    cmd.creation_flags(CREATE_NO_WINDOW);
    cmd
}

fn silent_dism() -> Command {
    let mut cmd = Command::new("dism");
    cmd.creation_flags(CREATE_NO_WINDOW);
    cmd
}

#[derive(Debug, Serialize, Deserialize)]
struct SystemInfo {
    computer_name: String,
    windows_version: String,
    cpu_name: String,
    cpu_cores: u32,
}

#[derive(Debug, Serialize, Deserialize)]
struct SystemStats {
    process_count: u32,
    ram_used: f64,
    ram_total: f64,
    cpu_usage: f64,
    disabled_services: u32,
}

#[derive(Debug, Serialize, Deserialize)]
struct IsoConfig {
    iso_source: String,
    iso_path: String,
    remove_edge: bool,
    remove_onedrive: bool,
    remove_copilot: bool,
    remove_bloatware: bool,
    remove_widgets: bool,
    remove_xbox: bool,
    disable_defender: bool,
    disable_updates: bool,
    apply_gaming: bool,
    apply_privacy: bool,
    bypass_requirements: bool,
    username: String,
    password: String,
    output_path: String,
    flash_to_usb: bool,
    usb_drive: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct ProgressUpdate {
    step: u32,
    total_steps: u32,
    message: String,
    percentage: u32,
    status: String,
}

// ==================== WINDOW COMMANDS ====================

#[tauri::command]
fn minimize_window(window: tauri::Window) {
    window.minimize().ok();
}

#[tauri::command]
fn maximize_window(window: tauri::Window) {
    if window.is_maximized().unwrap_or(false) {
        window.unmaximize().ok();
    } else {
        window.maximize().ok();
    }
}

#[tauri::command]
fn close_window(window: tauri::Window) {
    window.close().ok();
}

// ==================== SYSTEM COMMANDS ====================

#[tauri::command]
fn get_system_info() -> SystemInfo {
    let computer_name = std::env::var("COMPUTERNAME").unwrap_or_else(|_| "Unknown".to_string());
    let os_version = format!("Windows {}", sysinfo::System::long_os_version().unwrap_or_else(|| "11".to_string()));
    
    let sys = sysinfo::System::new_all();
    let cpu_name = sys.cpus().first().map(|c| c.brand().to_string()).unwrap_or_else(|| "Unknown".to_string());
    let cpu_cores = sys.cpus().len() as u32;

    SystemInfo {
        computer_name,
        windows_version: os_version,
        cpu_name,
        cpu_cores,
    }
}

#[tauri::command]
fn get_system_stats() -> SystemStats {
    let sys = sysinfo::System::new_all();
    let process_count = sys.processes().len() as u32;
    let ram_used = sys.used_memory() as f64 / 1_073_741_824.0;
    let ram_total = sys.total_memory() as f64 / 1_073_741_824.0;
    let cpu_usage = sys.global_cpu_info().cpu_usage() as f64;

    // Count actually disabled services
    let disabled_services = silent_ps()
        .args(["(Get-Service | Where-Object {$_.StartType -eq 'Disabled'}).Count"])
        .output()
        .ok()
        .and_then(|o| String::from_utf8_lossy(&o.stdout).trim().parse::<u32>().ok())
        .unwrap_or(0);

    SystemStats {
        process_count,
        ram_used,
        ram_total,
        cpu_usage,
        disabled_services,
    }
}

#[tauri::command]
fn disable_service(service_name: String) -> Result<String, String> {
    let output = silent_sc()
        .args(["config", &service_name, "start=", "disabled"])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() {
        silent_sc()
            .args(["stop", &service_name])
            .output()
            .ok();
        Ok(format!("Service {} disabled", service_name))
    } else {
        Err(format!("Failed to disable {}", service_name))
    }
}

#[tauri::command]
fn enable_service(service_name: String) -> Result<String, String> {
    let output = silent_sc()
        .args(["config", &service_name, "start=", "auto"])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() {
        silent_sc()
            .args(["start", &service_name])
            .output()
            .ok();
        Ok(format!("Service {} enabled", service_name))
    } else {
        Err(format!("Failed to enable {}", service_name))
    }
}

#[tauri::command]
fn set_registry(path: String, name: String, value: String) -> Result<String, String> {
    let output = silent_reg()
        .args(["add", &path, "/v", &name, "/t", "REG_DWORD", "/d", &value, "/f"])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() {
        Ok("Registry updated".to_string())
    } else {
        Err("Failed to update registry".to_string())
    }
}

#[tauri::command]
fn run_powershell(command: String) -> Result<String, String> {
    let output = silent_ps()
        .args([&command])
        .output()
        .map_err(|e| e.to_string())?;

    Ok(String::from_utf8_lossy(&output.stdout).to_string())
}

// ==================== OPTIMIZATION COMMANDS ====================

#[tauri::command]
fn open_file_dialog(filter: String) -> Result<String, String> {
    let output = silent_ps()
        .args([&format!(
            "Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.OpenFileDialog; $d.Filter = '{}'; $d.Title = 'Selecione a ISO'; if ($d.ShowDialog() -eq 'OK') {{ $d.FileName }}",
            filter
        )])
        .output()
        .map_err(|e| e.to_string())?;

    let result = String::from_utf8_lossy(&output.stdout).trim().to_string();
    if result.is_empty() { Err("Nenhum arquivo selecionado".to_string()) } else { Ok(result) }
}

#[tauri::command]
fn save_file_dialog(filter: String, default_name: String) -> Result<String, String> {
    let output = silent_ps()
        .args([&format!(
            "Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.SaveFileDialog; $d.Filter = '{}'; $d.FileName = '{}'; $d.Title = 'Salvar ISO'; if ($d.ShowDialog() -eq 'OK') {{ $d.FileName }}",
            filter, default_name
        )])
        .output()
        .map_err(|e| e.to_string())?;

    let result = String::from_utf8_lossy(&output.stdout).trim().to_string();
    if result.is_empty() { Err("Nenhum caminho selecionado".to_string()) } else { Ok(result) }
}

#[tauri::command]
fn apply_debloat() -> Result<String, String> {
    let packages = vec![
        "Microsoft.BingWeather", "Microsoft.BingNews", "Microsoft.BingFinance",
        "Microsoft.BingSports", "Microsoft.GetHelp", "Microsoft.Getstarted",
        "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.People", "Microsoft.SkypeApp", "Microsoft.MicrosoftStickyNotes",
        "Microsoft.Todos", "Microsoft.WindowsAlarms", "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps", "Microsoft.YourPhone", "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo", "Clipchamp.Clipchamp", "Microsoft.WindowsSoundRecorder",
        "Microsoft.PowerAutomateDesktop", "SpotifyAB.SpotifyMusic",
    ];

    for pkg in packages {
        silent_ps()
            .args([&format!("Get-AppxPackage -Name '{}' | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue", pkg)])
            .output()
            .ok();
    }

    Ok("Bloatware removido com sucesso".to_string())
}

#[tauri::command]
fn apply_gaming_optimizations() -> Result<String, String> {
    let tweaks = vec![
        ("HKCU\\SOFTWARE\\Microsoft\\GameBar", "AllowAutoGameMode", "0"),
        ("HKCU\\SOFTWARE\\Microsoft\\GameBar", "AutoGameModeEnabled", "0"),
        ("HKCU\\SOFTWARE\\Microsoft\\GameBar", "UseNexusForGameBarEnabled", "0"),
        ("HKCU\\System\\GameConfigStore", "GameDVR_Enabled", "0"),
        ("HKCU\\System\\GameConfigStore", "GameDVR_FSEBehaviorMode", "2"),
        ("HKCU\\Control Panel\\Mouse", "MouseSpeed", "0"),
        ("HKCU\\Control Panel\\Mouse", "MouseThreshold1", "0"),
        ("HKCU\\Control Panel\\Mouse", "MouseThreshold2", "0"),
    ];

    for (path, name, value) in tweaks {
        set_registry(path.to_string(), name.to_string(), value.to_string()).ok();
    }

    Ok("Gaming optimizations applied".to_string())
}

#[tauri::command]
fn apply_privacy_optimizations() -> Result<String, String> {
    disable_service("DiagTrack".to_string()).ok();
    disable_service("dmwappushservice".to_string()).ok();
    
    set_registry(
        "HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection".to_string(),
        "AllowTelemetry".to_string(),
        "0".to_string()
    ).ok();

    Ok("Privacy optimizations applied".to_string())
}

#[tauri::command]
fn apply_performance_optimizations() -> Result<String, String> {
    let services = vec![
        "SysMain", "WSearch", "wuauserv", "DoSvc", "Spooler", "Fax",
        "RemoteRegistry", "WerSvc", "DPS", "PcaSvc", "XblAuthManager",
        "XblGameSave", "XboxNetApiSvc", "lfsvc", "WbioSrvc", "WpcMonSvc"
    ];

    for svc in services {
        disable_service(svc.to_string()).ok();
    }

    run_powershell("powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c".to_string()).ok();

    Ok("Performance optimizations applied".to_string())
}

#[tauri::command]
fn apply_network_optimizations() -> Result<String, String> {
    run_powershell("Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1') }".to_string()).ok();
    
    set_registry(
        "HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile".to_string(),
        "NetworkThrottlingIndex".to_string(),
        "4294967295".to_string()
    ).ok();

    Ok("Network optimizations applied".to_string())
}

#[tauri::command]
fn restore_defaults() -> Result<String, String> {
    let services = vec![
        "DiagTrack", "dmwappushservice", "SysMain", "WSearch", "wuauserv",
        "DoSvc", "Spooler", "Fax", "RemoteRegistry", "WerSvc", "DPS", "PcaSvc"
    ];

    for svc in services {
        enable_service(svc.to_string()).ok();
    }

    run_powershell("powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e".to_string()).ok();

    Ok("Defaults restored".to_string())
}

// ==================== ISO INJECTION COMMANDS ====================
// Flow correto:
// 1. extract_iso -> copia conteúdo da ISO para iso_work/
// 2. mount_wim -> monta iso_work/sources/install.wim em wim_mount/
// 3. inject_playbook -> aplica tweaks no WIM montado
// 4. unmount_wim -> desmonta WIM com commit (salva em iso_work/sources/install.wim)
// 5. create_autounattend -> coloca autounattend.xml na raiz de iso_work/
// 6. build_iso -> cria ISO a partir de iso_work/ com oscdimg

#[tauri::command]
fn get_available_drives() -> Result<Vec<String>, String> {
    let output = silent_ps()
        .args(["Get-Volume | Where-Object {$_.DriveLetter -and $_.DriveType -ne 'CD-ROM'} | Select-Object DriveLetter, FileSystemLabel, @{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}} | ConvertTo-Json"])
        .output()
        .map_err(|e| e.to_string())?;
    let stdout = String::from_utf8_lossy(&output.stdout);
    Ok(vec![stdout.to_string()])
}

#[tauri::command]
fn get_usb_drives() -> Result<Vec<String>, String> {
    let output = silent_ps()
        .args(["Get-Disk | Where-Object {$_.BusType -eq 'USB'} | Select-Object Number, FriendlyName, @{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}} | ConvertTo-Json"])
        .output()
        .map_err(|e| e.to_string())?;
    let stdout = String::from_utf8_lossy(&output.stdout);
    Ok(vec![stdout.to_string()])
}

#[tauri::command]
fn download_windows_iso(output_path: String, window: tauri::Window) -> Result<String, String> {
    window.emit("iso-progress", ProgressUpdate {
        step: 1, total_steps: 8,
        message: "Baixando ISO do Windows 11 (pode levar 10-30 min)...".to_string(),
        percentage: 5, status: "downloading".to_string(),
    }).ok();

    // Cria diretorio pai se nao existir
    if let Some(parent) = Path::new(&output_path).parent() {
        std::fs::create_dir_all(parent).ok();
    }

    // Usa aria2c se disponivel (mais rapido), senao Invoke-WebRequest
    let aria2_check = { let mut c = Command::new("where"); c.creation_flags(CREATE_NO_WINDOW); c.args(["aria2c.exe"]).output() };
    let use_aria2 = aria2_check.map(|o| o.status.success()).unwrap_or(false);

    let download_url = "https://software.download.prss.microsoft.com/dbazure/Win11_24H2_BrazilianPortuguese_x64v1.iso";

    let result = if use_aria2 {
        let mut c = Command::new("aria2c");
        c.creation_flags(CREATE_NO_WINDOW);
        c.args([&format!("--dir={}", Path::new(&output_path).parent().unwrap().to_str().unwrap()), &format!("--out={}", Path::new(&output_path).file_name().unwrap().to_str().unwrap()), "-x16", "-s16", download_url])
            .output()
    } else {
        silent_ps()
            .args([&format!("Invoke-WebRequest -Uri '{}' -OutFile '{}' -UseBasicParsing", download_url, output_path)])
            .output()
    };

    let output = result.map_err(|e| e.to_string())?;

    if output.status.success() && Path::new(&output_path).exists() {
        window.emit("iso-progress", ProgressUpdate {
            step: 1, total_steps: 8,
            message: "Download concluido!".to_string(),
            percentage: 15, status: "downloaded".to_string(),
        }).ok();
        Ok(output_path)
    } else {
        let stderr = String::from_utf8_lossy(&output.stderr);
        Err(format!("Falha no download: {}", stderr))
    }
}

#[tauri::command]
fn extract_iso(iso_path: String, work_dir: String, window: tauri::Window) -> Result<String, String> {
    window.emit("iso-progress", ProgressUpdate {
        step: 2, total_steps: 8,
        message: "Extraindo conteúdo da ISO...".to_string(),
        percentage: 18, status: "extracting".to_string(),
    }).ok();

    // Limpa diretorio de trabalho anterior
    let _ = std::fs::remove_dir_all(&work_dir);
    std::fs::create_dir_all(&format!("{}\\sources", work_dir)).map_err(|e| e.to_string())?;

    // Monta ISO
    let output = silent_ps()
        .args([&format!(
            "$img = Mount-DiskImage -ImagePath '{}' -PassThru; $vol = Get-Volume -DiskImage $img; Write-Output $vol.DriveLetter",
            iso_path
        )])
        .output()
        .map_err(|e| e.to_string())?;

    let drive_letter = String::from_utf8_lossy(&output.stdout).trim().to_string();
    if drive_letter.is_empty() {
        return Err("Falha ao montar ISO para extração".to_string());
    }
    let source = format!("{}:", drive_letter);

    // Copia todos os arquivos da ISO para work_dir
    let mut robocopy = Command::new("robocopy");
    robocopy.creation_flags(CREATE_NO_WINDOW);
    let output = robocopy
        .args([&source, &work_dir, "/E", "/NFL", "/NDL", "/NJH", "/NJS", "/nc", "/ns", "/np"])
        .output()
        .map_err(|e| e.to_string())?;

    // robocopy retorna 0-7 para sucesso, 8+ para erro
    let exit_code = output.status.code().unwrap_or(8);

    // Desmonta ISO
    silent_ps()
        .args([&format!("Dismount-DiskImage -ImagePath '{}'", iso_path)])
        .output()
        .ok();

    if exit_code < 8 {
        window.emit("iso-progress", ProgressUpdate {
            step: 2, total_steps: 8,
            message: "ISO extraída com sucesso!".to_string(),
            percentage: 25, status: "extracted".to_string(),
        }).ok();
        Ok(work_dir)
    } else {
        Err("Falha ao extrair ISO".to_string())
    }
}

#[tauri::command]
fn mount_wim(iso_work_dir: String, wim_mount_dir: String, window: tauri::Window) -> Result<String, String> {
    // Verifica se e administrador
    if !is_admin() {
        return Err("DISM precisa de privilegios de Administrador. Clique com botao direito no exe > Executar como administrador.".to_string());
    }

    window.emit("iso-progress", ProgressUpdate {
        step: 3, total_steps: 8,
        message: "Montando imagem Windows (install.wim)...".to_string(),
        percentage: 28, status: "mounting".to_string(),
    }).ok();

    let wim_path = format!("{}\\sources\\install.wim", iso_work_dir);

    // Verifica se install.wim existe, senao tenta install.esd
    if !Path::new(&wim_path).exists() {
        let esd_path = format!("{}\\sources\\install.esd", iso_work_dir);
        if Path::new(&esd_path).exists() {
            window.emit("iso-progress", ProgressUpdate {
                step: 3, total_steps: 8,
                message: "Convertendo ESD para WIM (pode levar varios minutos)...".to_string(),
                percentage: 26, status: "converting".to_string(),
            }).ok();
            let output = silent_dism()
                .args(["/Export-Image", &format!("/SourceImageFile:{}", esd_path), "/SourceIndex:1", &format!("/DestinationImageFile:{}", wim_path), "/Compress:Max", "/CheckIntegrity"])
                .output()
                .map_err(|e| format!("Erro ao executar DISM: {}", e))?;
            if !output.status.success() {
                let stderr = String::from_utf8_lossy(&output.stderr);
                let stdout = String::from_utf8_lossy(&output.stdout);
                return Err(format!("Falha ao converter ESD para WIM.\n\nSTDOUT: {}\nSTDERR: {}", stdout, stderr));
            }
            std::fs::remove_file(&esd_path).ok();
        } else {
            return Err(format!("install.wim e install.esd nao encontrados em: {}\\sources\\", iso_work_dir));
        }
    }

    // Verifica se o WIM existe agora
    if !Path::new(&wim_path).exists() {
        return Err(format!("Arquivo WIM nao existe apos conversao: {}", wim_path));
    }

    // === LIMPEZA FORÇADA ===
    // 1. Desmonta qualquer WIM pendente
    silent_dism().args(["/Unmount-Wim", "/MountDir:C:\\YokaiOS\\WIM_Mount", "/Discard"]).output().ok();
    silent_dism().args(["/Cleanup-Wim"]).output().ok();
    
    // 2. Remove diretorio de mount completamente
    let _ = std::fs::remove_dir_all(&wim_mount_dir);
    std::thread::sleep(std::time::Duration::from_millis(500));
    
    // 3. Cria diretorio limpo
    std::fs::create_dir_all(&wim_mount_dir).map_err(|e| format!("Erro ao criar diretorio de mount: {}", e))?;

    // 4. Remove atributo ReadOnly do WIM (ISOs costumam ter WIM read-only)
    Command::new("attrib")
        .creation_flags(CREATE_NO_WINDOW)
        .args(["-R", &wim_path])
        .output()
        .ok();

    // 5. Cria diretorio scratch temporario
    let scratch_dir = format!("{}\\Scratch", iso_work_dir);
    std::fs::create_dir_all(&scratch_dir).ok();

    // Monta WIM com dism + scratch dir
    let output = silent_dism()
        .args(["/Mount-Wim", &format!("/WimFile:{}", wim_path), "/Index:1", &format!("/MountDir:{}", wim_mount_dir), &format!("/ScratchDir:{}", scratch_dir)])
        .output()
        .map_err(|e| format!("Erro ao executar DISM mount: {}", e))?;

    if output.status.success() {
        window.emit("iso-progress", ProgressUpdate {
            step: 3, total_steps: 8,
            message: "Imagem montada com sucesso!".to_string(),
            percentage: 32, status: "mounted".to_string(),
        }).ok();
        Ok(wim_mount_dir)
    } else {
        let stderr = String::from_utf8_lossy(&output.stderr);
        let stdout = String::from_utf8_lossy(&output.stdout);

            // Tenta metodo alternativo: DISM via PowerShell
            let ps_output = silent_ps()
                .args([&format!("Mount-WindowsImage -ImagePath '{}' -Index 1 -Path '{}' -ScratchDir '{}'", wim_path, wim_mount_dir, scratch_dir)])
            .output();

        match ps_output {
            Ok(o) if o.status.success() => {
                window.emit("iso-progress", ProgressUpdate {
                    step: 3, total_steps: 8,
                    message: "Imagem montada com sucesso!".to_string(),
                    percentage: 32, status: "mounted".to_string(),
                }).ok();
                Ok(wim_mount_dir)
            }
            _ => {
                Err(format!("Falha ao montar WIM.\n\nArquivo: {}\nExiste: {}\nTamanho: {} bytes\n\nDISM STDOUT: {}\nDISM STDERR: {}",
                    wim_path,
                    Path::new(&wim_path).exists(),
                    std::fs::metadata(&wim_path).map(|m| m.len()).unwrap_or(0),
                    stdout.trim(),
                    stderr.trim()
                ))
            }
        }
    }
}

#[tauri::command]
fn inject_playbook(wim_mount_dir: String, iso_work_dir: String, config: IsoConfig, window: tauri::Window) -> Result<String, String> {
    let software_hive = format!("{}\\Windows\\System32\\config\\SOFTWARE", wim_mount_dir);
    let system_hive = format!("{}\\Windows\\System32\\config\\SYSTEM", wim_mount_dir);

    // === STEP 4: REMOVER BLOATWARE ===
    window.emit("iso-progress", ProgressUpdate {
        step: 4, total_steps: 8,
        message: "Removendo bloatware da imagem...".to_string(),
        percentage: 35, status: "debloating".to_string(),
    }).ok();

    let mut packages_to_remove: Vec<&str> = vec![];

    if config.remove_bloatware {
        packages_to_remove.extend_from_slice(&[
            "Microsoft.BingWeather", "Microsoft.BingNews", "Microsoft.BingFinance",
            "Microsoft.BingSports", "Microsoft.GamingApp", "Microsoft.GetHelp",
            "Microsoft.Getstarted", "Microsoft.MicrosoftOfficeHub",
            "Microsoft.MicrosoftSolitaireCollection", "Microsoft.People",
            "Microsoft.SkypeApp", "Microsoft.MicrosoftStickyNotes",
            "Microsoft.Todos", "Microsoft.WindowsAlarms", "Microsoft.WindowsFeedbackHub",
            "Microsoft.WindowsMaps", "Microsoft.YourPhone", "Microsoft.ZuneMusic",
            "Microsoft.ZuneVideo", "Clipchamp.Clipchamp", "Microsoft.WindowsSoundRecorder",
            "Microsoft.PowerAutomateDesktop", "SpotifyAB.SpotifyMusic",
            "BytedancePte.Ltd.TikTok", "Facebook.InstagramBeta", "Facebook.Facebook",
            "king.com.CandyCrushSaga", "king.com.CandyCrushSodaSaga",
            "Microsoft.549981C3F5F10", "MicrosoftTeams", "Microsoft.OutlookForWindows",
            "Microsoft.Windows.DevHome", "Microsoft.MicrosoftPowerBIForWindows",
        ]);
    }
    if config.remove_edge {
        packages_to_remove.push("Microsoft.MicrosoftEdge.Stable");
        packages_to_remove.push("Microsoft.MicrosoftEdge");
        packages_to_remove.push("Microsoft.Edge.GameAssist");
    }
    if config.remove_widgets {
        packages_to_remove.push("MicrosoftWindows.Client.WebExperience");
        packages_to_remove.push("Microsoft.WidgetsPlatformRuntime");
    }
    if config.remove_copilot {
        packages_to_remove.push("Microsoft.Copilot");
        packages_to_remove.push("Microsoft.Windows.Ai.Copilot.Provider");
    }
    if config.remove_xbox {
        packages_to_remove.extend_from_slice(&[
            "Microsoft.XboxApp", "Microsoft.XboxGameCallableUI",
            "Microsoft.XboxGamingOverlay", "Microsoft.XboxIdentityProvider",
            "Microsoft.XboxSpeechToTextOverlay", "Microsoft.Xbox.TCUI",
        ]);
    }

    for pkg in &packages_to_remove {
        silent_dism()
            .args([&format!("/Image:{}", wim_mount_dir), "/Remove-ProvisionedAppxPackage", &format!("/PackageName:{}", pkg)])
            .output()
            .ok();
    }

    // === STEP 5: REGISTRY TWEAKS (PRIVACY + GAMING + SYSTEM) ===
    window.emit("iso-progress", ProgressUpdate {
        step: 5, total_steps: 8,
        message: "Aplicando tweaks de privacidade e gaming...".to_string(),
        percentage: 45, status: "tweaking".to_string(),
    }).ok();

    // Load SOFTWARE hive ONCE
    let load_out = silent_reg()
        .args(["load", "HKLM\\YOKAISOFT", &software_hive])
        .output()
        .map_err(|e| e.to_string())?;
    if !load_out.status.success() {
        return Err("Falha ao carregar hive SOFTWARE".to_string());
    }

    // Privacy tweaks
    let privacy_reg: Vec<(&str, &str, &str)> = vec![
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\DataCollection", "AllowTelemetry", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\DataCollection", "MaxTelemetryAllowed", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\AdvertisingInfo", "DisabledByGroupPolicy", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\System", "EnableActivityFeed", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\System", "PublishUserActivities", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\System", "UploadUserActivities", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\LocationAndSensors", "DisableLocation", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\LocationAndSensors", "DisableWindowsLocationProvider", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\Windows Search", "AllowCortana", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\Windows Search", "DisableWebSearch", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\Windows Search", "ConnectedSearchUseWeb", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\Windows Search", "AllowSearchToUseLocation", "0"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager", "SystemPaneSuggestionsEnabled", "0"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager", "SilentInstalledAppsEnabled", "0"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager", "SoftLandingEnabled", "0"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\CloudContent", "DisableWindowsConsumerFeatures", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\CloudContent", "DisableTailoredExperiencesWithDiagnosticData", "1"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer", "HideSCAMeetNow", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\WindowsCopilot", "TurnOffWindowsCopilot", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\WindowsAI", "DisableWindowsAI", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\WindowsAI", "DisableAIDataAnalysis", "1"),
    ];

    // Gaming tweaks
    let gaming_reg: Vec<(&str, &str, &str)> = vec![
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile", "SystemResponsiveness", "0"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile", "NetworkThrottlingIndex", "4294967295"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games", "GPU Priority", "8"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games", "Priority", "6"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games", "Scheduling Category", "High"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games", "SFIO Priority", "High"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile\\Tasks\\Games", "Background Only", "False"),
    ];

    // System tweaks
    let system_reg: Vec<(&str, &str, &str)> = vec![
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows\\CurrentVersion\\DriverSearching", "SearchOrderConfig", "0"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows\\CurrentVersion\\Device Installer", "DisableCoInstallers", "1"),
        ("HKLM\\YOKAISOFT\\Policies\\Microsoft\\Windows\\DeliveryOptimization", "DODownloadMode", "0"),
        ("HKLM\\YOKAISOFT\\Microsoft\\Windows\\CurrentVersion\\Policies\\System", "VerboseStatus", "1"),
    ];

    // Bypass Windows 11 hardware requirements (TPM, Secure Boot, RAM, CPU)
    let bypass_reg: Vec<(&str, &str, &str)> = if config.bypass_requirements {
        vec![
            ("HKLM\\YOKAISYS\\Setup\\LabConfig", "BypassTPMCheck", "1"),
            ("HKLM\\YOKAISYS\\Setup\\LabConfig", "BypassSecureBootCheck", "1"),
            ("HKLM\\YOKAISYS\\Setup\\LabConfig", "BypassRAMCheck", "1"),
            ("HKLM\\YOKAISYS\\Setup\\LabConfig", "BypassCPUCheck", "1"),
            ("HKLM\\YOKAISOFT\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon", "EnableFirstLogonAnimation", "0"),
        ]
    } else {
        vec![]
    };

    // Apply SYSTEM hive bypasses
    let system_hive_path = format!("{}\\Windows\\System32\\config\\SYSTEM", wim_mount_dir);
    let load_sys = silent_reg()
        .args(["load", "HKLM\\YOKAISYS", &system_hive_path])
        .output()
        .map_err(|e| e.to_string())?;
    
    if load_sys.status.success() {
        for (path, name, value) in &bypass_reg {
            silent_reg()
                .args(["add", path, "/v", name, "/t", "REG_DWORD", "/d", value, "/f"])
                .output()
                .ok();
        }
        silent_reg().args(["unload", "HKLM\\YOKAISYS"]).output().ok();
    }

    // Apply all registry tweaks
    let all_tweaks = if config.apply_privacy { privacy_reg } else { vec![] };
    let all_tweaks: Vec<(&str, &str, &str)> = all_tweaks.into_iter()
        .chain(if config.apply_gaming { gaming_reg } else { vec![] }.into_iter())
        .chain(system_reg.into_iter())
        .collect();

    for (path, name, value) in &all_tweaks {
        silent_reg()
            .args(["add", path, "/v", name, "/t", "REG_DWORD", "/d", value, "/f"])
            .output()
            .ok();
    }

    // Unload SOFTWARE hive
    silent_reg().args(["unload", "HKLM\\YOKAISOFT"]).output().ok();

    // === STEP 6: DISABLE DEFENDER (opcional) ===
    window.emit("iso-progress", ProgressUpdate {
        step: 6, total_steps: 8,
        message: "Configurando segurança...".to_string(),
        percentage: 55, status: "security".to_string(),
    }).ok();

    if config.disable_defender {
        // Disable Defender via SYSTEM hive
        let load_out = silent_reg()
            .args(["load", "HKLM\\YOKAISYS", &system_hive])
            .output()
            .map_err(|e| e.to_string())?;
        if load_out.status.success() {
            silent_reg()
                .args(["add", "HKLM\\YOKAISYS\\ControlSet001\\Services\\WinDefend", "/v", "Start", "/t", "REG_DWORD", "/d", "4", "/f"])
                .output()
                .ok();
            silent_reg()
                .args(["add", "HKLM\\YOKAISYS\\ControlSet001\\Services\\SecurityHealthService", "/v", "Start", "/t", "REG_DWORD", "/d", "4", "/f"])
                .output()
                .ok();
            silent_reg().args(["unload", "HKLM\\YOKAISYS"]).output().ok();
        }
    }

    // === STEP 7: DISABLE UPDATE SERVICES (opcional) ===
    if config.disable_updates {
        let load_out = silent_reg()
            .args(["load", "HKLM\\YOKAISYS", &system_hive])
            .output()
            .map_err(|e| e.to_string())?;
        if load_out.status.success() {
            let update_services = vec!["wuauserv", "UsoSvc", "DoSvc"];
            for svc in update_services {
                silent_reg()
                    .args(["add", &format!("HKLM\\YOKAISYS\\ControlSet001\\Services\\{}", svc), "/v", "Start", "/t", "REG_DWORD", "/d", "4", "/f"])
                    .output()
                    .ok();
            }
            silent_reg().args(["unload", "HKLM\\YOKAISYS"]).output().ok();
        }
    }

    // === STEP 8: CREATE AUTOUNATTEND.XML (na raiz da ISO, NAO dentro do WIM) ===
    window.emit("iso-progress", ProgressUpdate {
        step: 7, total_steps: 8,
        message: "Criando autounattend.xml (BypassNRO + conta local)...".to_string(),
        percentage: 65, status: "autounattend".to_string(),
    }).ok();

    let autounattend = create_autounattend_xml(&config);

    // autounattend.xml na RAIZ da ISO (iso_work), NAO dentro do WIM
    let xml_path = format!("{}\\autounattend.xml", iso_work_dir);
    std::fs::write(&xml_path, &autounattend).map_err(|e| e.to_string())?;

    // Tambem cria unattend.xml para o specialize pass
    let unattend_path = format!("{}\\unattend.xml", iso_work_dir);
    std::fs::write(&unattend_path, &autounattend).ok();

    // Copia autounattend.xml para dentro do Windows\Panther tambem
    let panther_dir = format!("{}\\Windows\\Panther", wim_mount_dir);
    std::fs::create_dir_all(&panther_dir).ok();
    std::fs::write(format!("{}\\unattend.xml", panther_dir), &autounattend).ok();

    window.emit("iso-progress", ProgressUpdate {
        step: 7, total_steps: 8,
        message: "Autounattend.xml criado com sucesso!".to_string(),
        percentage: 70, status: "autounattend_done".to_string(),
    }).ok();

    Ok(format!("Bloatware removido: {} pacotes. Registry tweaks aplicados: {}. Autounattend.xml criado.", packages_to_remove.len(), all_tweaks.len()))
}

fn create_autounattend_xml(config: &IsoConfig) -> String {
    let username = if config.username.is_empty() { "User" } else { &config.username };
    let password = &config.password;

    let password_xml = if password.is_empty() {
        String::new()
    } else {
        format!("<Password><Value>{}</Value><PlainText>true</PlainText></Password>", password)
    };

    let auto_logon = if password.is_empty() {
        format!("<AutoLogon><Enabled>true</Enabled><Username>{}</Username><LogonCount>1</LogonCount></AutoLogon>", username)
    } else {
        format!("<AutoLogon><Enabled>true</Enabled><Username>{}</Username><Password><Value>{}</Value><PlainText>true</PlainText></Password><LogonCount>1</LogonCount></AutoLogon>", username, password)
    };

    // BypassNRO robusto: registry direto + comando no specialize
    format!(r#"<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="windowsPE">
    <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" language="neutral" versionScope="nonSxS" publicKeyToken="31bf3856ad364e35" languageNeutral="neutral">
      <SetupUILanguage><UILanguage>pt-BR</UILanguage></SetupUILanguage>
      <InputLocale>0416:00000416</InputLocale>
      <SystemLocale>pt-BR</SystemLocale>
      <UILanguage>pt-BR</UILanguage>
      <UserLocale>pt-BR</UserLocale>
    </component>
    <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" language="neutral" versionScope="nonSxS" publicKeyToken="31bf3856ad364e35" languageNeutral="neutral">
      <DiskConfiguration>
        <Disk wcm:action="add">
          <CreatePartitions>
            <CreatePartition wcm:action="add">
              <Order>1</Order><Type>EFI</Type><Size>260</Size>
            </CreatePartition>
            <CreatePartition wcm:action="add">
              <Order>2</Order><Type>MSR</Type><Size>16</Size>
            </CreatePartition>
            <CreatePartition wcm:action="add">
              <Order>3</Order><Type>Primary</Type><Extend>true</Extend>
            </CreatePartition>
          </CreatePartitions>
          <ModifyPartitions>
            <ModifyPartition wcm:action="add">
              <Order>1</Order><PartitionID>1</PartitionID><Format>FAT32</Format><Label>EFI</Label>
            </ModifyPartition>
            <ModifyPartition wcm:action="add">
              <Order>2</Order><PartitionID>3</PartitionID><Format>NTFS</Format><Label>OS</Label><Letter>C</Letter>
            </ModifyPartition>
          </ModifyPartitions>
          <DiskID>0</DiskID><WillWipeDisk>true</WillWipeDisk>
        </Disk>
      </DiskConfiguration>
      <ImageInstall>
        <OSImage>
          <InstallFrom><MetaData wcm:action="add"><Key>/IMAGE/NAME</Key><Value>Windows 11 Pro</Value></MetaData></InstallFrom>
          <InstallTo><DiskID>0</DiskID><PartitionID>3</PartitionID></InstallTo>
        </OSImage>
      </ImageInstall>
      <UserData>
        <ProductKey><Key></Key><WillShowUI>Never</WillShowUI></ProductKey>
        <AcceptEula>true</AcceptEula>
        <FullName>{username}</FullName>
        <Organization>YokaiOS</Organization>
      </UserData>
    </component>
  </settings>
  <settings pass="offlineServicing">
    <component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" language="neutral" versionScope="nonSxS" publicKeyToken="31bf3856ad364e35" languageNeutral="neutral">
      <EnableLUA>false</EnableLUA>
    </component>
  </settings>
  <settings pass="specialize">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" language="neutral" versionScope="nonSxS" publicKeyToken="31bf3856ad364e35" languageNeutral="neutral">
      <ComputerName>YOKAIOS</ComputerName>
    </component>
    <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" language="neutral" versionScope="nonSxS" publicKeyToken="31bf3856ad364e35" languageNeutral="neutral">
      <RunSynchronous>
        <RunSynchronousCommand wcm:action="add">
          <Order>1</Order>
          <Path>reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f</Path>
        </RunSynchronousCommand>
        <RunSynchronousCommand wcm:action="add">
          <Order>2</Order>
          <Path>reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v SkipMachineOOBE /t REG_DWORD /d 1 /f</Path>
        </RunSynchronousCommand>
        <RunSynchronousCommand wcm:action="add">
          <Order>3</Order>
          <Path>reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v SkipUserOOBE /t REG_DWORD /d 1 /f</Path>
        </RunSynchronousCommand>
        <RunSynchronousCommand wcm:action="add">
          <Order>4</Order>
          <Path>reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f</Path>
        </RunSynchronousCommand>
      </RunSynchronous>
    </component>
  </settings>
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" language="neutral" versionScope="nonSxS" publicKeyToken="31bf3856ad364e35" languageNeutral="neutral">
      {auto_logon}
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideLocalAccountScreen>true</HideLocalAccountScreen>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <NetworkLocation>Home</NetworkLocation>
        <ProtectYourPC>3</ProtectYourPC>
        <SkipMachineOOBE>true</SkipMachineOOBE>
        <SkipUserOOBE>true</SkipUserOOBE>
      </OOBE>
      <UserAccounts>
        <LocalAccounts>
          <LocalAccount wcm:action="add">
            {password_xml}
            <Description>YokaiOS User</Description>
            <DisplayName>{username}</DisplayName>
            <Group>Administrators</Group>
            <Name>{username}</Name>
          </LocalAccount>
        </LocalAccounts>
      </UserAccounts>
      <FirstLogonCommands>
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <CommandLine>reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f</CommandLine>
          <Description>Bypass Microsoft Account</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>2</Order>
          <CommandLine>reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v SkipMachineOOBE /t REG_DWORD /d 1 /f</CommandLine>
          <Description>Skip Machine OOBE</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>3</Order>
          <CommandLine>reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f</CommandLine>
          <Description>Disable Privacy Experience</Description>
        </SynchronousCommand>
      </FirstLogonCommands>
    </component>
  </settings>
</unattend>"#, username = username, password_xml = password_xml, auto_logon = auto_logon)
}

#[tauri::command]
fn unmount_wim(wim_mount_dir: String, commit: bool) -> Result<String, String> {
    let flag = if commit { "/Commit" } else { "/Discard" };
    let output = silent_dism()
        .args(["/Unmount-Wim", &format!("/MountDir:{}", wim_mount_dir), flag])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() {
        Ok("WIM desmontado com sucesso".to_string())
    } else {
        silent_dism().args(["/Cleanup-Wim"]).output().ok();
        Err("Falha ao desmontar WIM".to_string())
    }
}

#[tauri::command]
fn build_iso(iso_work_dir: String, output_path: String, window: tauri::Window) -> Result<String, String> {
    window.emit("iso-progress", ProgressUpdate {
        step: 8, total_steps: 8,
        message: "Criando ISO bootável com oscdimg...".to_string(),
        percentage: 75, status: "building".to_string(),
    }).ok();

    // Encontrar oscdimg
    let oscdimg_paths = vec![
        "C:\\Program Files (x86)\\Windows Kits\\10\\Assessment and Deployment Kit\\Deployment Tools\\amd64\\Oscdimg\\oscdimg.exe",
        "C:\\Program Files\\Windows Kits\\10\\Assessment and Deployment Kit\\Deployment Tools\\amd64\\Oscdimg\\oscdimg.exe",
    ];
    let mut oscdimg_path = String::new();
    for path in &oscdimg_paths {
        if Path::new(path).exists() {
            oscdimg_path = path.to_string();
            break;
        }
    }
    if oscdimg_path.is_empty() {
        let mut where_cmd = Command::new("where");
        where_cmd.creation_flags(CREATE_NO_WINDOW);
        if let Ok(out) = where_cmd.args(["oscdimg.exe"]).output() {
            let stdout = String::from_utf8_lossy(&out.stdout);
            if !stdout.trim().is_empty() {
                oscdimg_path = stdout.trim().lines().next().unwrap_or("").to_string();
            }
        }
    }

    // Se nao encontrou, baixa e instala automaticamente
    if oscdimg_path.is_empty() {
        window.emit("iso-progress", ProgressUpdate {
            step: 8, total_steps: 8,
            message: "oscdimg.exe nao encontrado. Baixando Windows ADK...".to_string(),
            percentage: 76, status: "downloading_adk".to_string(),
        }).ok();

        let adk_installer = format!("{}\\adksetup.exe", std::env::temp_dir().display());
        
        // Baixa o instalador do ADK
        let download_ok = silent_ps()
            .args([&format!(
                "Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=2271337' -OutFile '{}' -UseBasicParsing",
                adk_installer
            )])
            .output()
            .map(|o| o.status.success())
            .unwrap_or(false);

        if download_ok && Path::new(&adk_installer).exists() {
            window.emit("iso-progress", ProgressUpdate {
                step: 8, total_steps: 8,
                message: "Instalando Deployment Tools do ADK...".to_string(),
                percentage: 78, status: "installing_adk".to_string(),
            }).ok();

            // Instala apenas o Deployment Tools (onde fica o oscdimg)
            let install_ok = Command::new(&adk_installer)
                .creation_flags(CREATE_NO_WINDOW)
                .args(["/quiet", "/norestart", "/features", "OptionId.DeploymentTools"])
                .output()
                .map(|o| o.status.success())
                .unwrap_or(false);

            // Limpa instalador
            let _ = std::fs::remove_file(&adk_installer);

            if install_ok {
                // Verifica se instalou
                for path in &oscdimg_paths {
                    if Path::new(path).exists() {
                        oscdimg_path = path.to_string();
                        break;
                    }
                }
            }
        }

        // Se ainda nao tem, tenta baixar oscdimg isolado
        if oscdimg_path.is_empty() {
            window.emit("iso-progress", ProgressUpdate {
                step: 8, total_steps: 8,
                message: "Tentando baixar oscdimg isolado...".to_string(),
                percentage: 80, status: "downloading_oscdimg".to_string(),
            }).ok();

            let oscdimg_dir = "C:\\YokaiOS\\Tools";
            std::fs::create_dir_all(oscdimg_dir).ok();
            let oscdimg_dest = format!("{}\\oscdimg.exe", oscdimg_dir);
            
            // Tenta baixar de um mirror conhecido
            let download_ok = silent_ps()
                .args([&format!(
                    "Invoke-WebRequest -Uri 'https://github.com/AveYo/MediaCreationTool.bat/raw/main/bits/oscdimg.exe' -OutFile '{}' -UseBasicParsing",
                    oscdimg_dest
                )])
                .output()
                .map(|o| o.status.success())
                .unwrap_or(false);

            if download_ok && Path::new(&oscdimg_dest).exists() {
                oscdimg_path = oscdimg_dest;
            }
        }

        if oscdimg_path.is_empty() {
            return Err("Nao foi possivel obter o oscdimg.exe.\n\nInstale manualmente o Windows ADK:\nhttps://learn.microsoft.com/pt-br/windows-hardware/get-started/adk-install".to_string());
        }

        window.emit("iso-progress", ProgressUpdate {
            step: 8, total_steps: 8,
            message: "oscdimg instalado! Continuando...".to_string(),
            percentage: 82, status: "adk_installed".to_string(),
        }).ok();
    }

    // Caminhos de boot - estao dentro de iso_work (copiados da ISO original)
    let etfsboot = format!("{}\\boot\\etfsboot.com", iso_work_dir);
    let efisys = format!("{}\\efi\\microsoft\\boot\\efisys.bin", iso_work_dir);

    // Verifica se os arquivos de boot existem
    if !Path::new(&etfsboot).exists() {
        return Err(format!("etfsboot.com não encontrado em: {}", etfsboot));
    }
    if !Path::new(&efisys).exists() {
        return Err(format!("efisys.bin não encontrado em: {}", efisys));
    }

    // Cria diretorio de saida
    if let Some(parent) = Path::new(&output_path).parent() {
        std::fs::create_dir_all(parent).ok();
    }

    // Remove ISO anterior se existir
    let _ = std::fs::remove_file(&output_path);

    // Build ISO com oscdimg
    let mut oscdimg = Command::new(&oscdimg_path);
    oscdimg.creation_flags(CREATE_NO_WINDOW);
    let output = oscdimg
        .args([
            "-m", "-o", "-u2", "-udfver102",
            &format!("-b{}", etfsboot),
            &format!("-pEF{}", efisys),
            &iso_work_dir,
            &output_path,
        ])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() && Path::new(&output_path).exists() {
        let size_mb = std::fs::metadata(&output_path).map(|m| m.len() / 1_048_576).unwrap_or(0);
        window.emit("iso-progress", ProgressUpdate {
            step: 8, total_steps: 8,
            message: format!("ISO criada com sucesso! ({} MB)", size_mb),
            percentage: 100, status: "completed".to_string(),
        }).ok();
        Ok(output_path)
    } else {
        let stderr = String::from_utf8_lossy(&output.stderr);
        Err(format!("Falha ao criar ISO: {}", stderr))
    }
}

#[tauri::command]
fn flash_iso_to_usb(iso_path: String, usb_drive: String, window: tauri::Window) -> Result<String, String> {
    window.emit("iso-progress", ProgressUpdate {
        step: 8, total_steps: 8,
        message: format!("Gravando ISO no USB {}...", usb_drive),
        percentage: 90, status: "flashing".to_string(),
    }).ok();

    // Limpa drive letter para numero de disco se necessario
    let disk_num = usb_drive.replace(":", "").replace("\\", "");

    // Formata USB com diskpart
    let diskpart_script = format!(
        "select disk {}\nclean\ncreate partition primary\nactive\nformat fs=ntfs quick label=YOKAIOS\nassign letter={}\nexit",
        disk_num, usb_drive
    );
    let script_path = format!("{}\\yokai_diskpart.txt", std::env::temp_dir().display());
    std::fs::write(&script_path, &diskpart_script).map_err(|e| e.to_string())?;

    let mut diskpart = Command::new("diskpart");
    diskpart.creation_flags(CREATE_NO_WINDOW);
    let output = diskpart
        .args(["/s", &script_path])
        .output()
        .map_err(|e| e.to_string())?;

    if !output.status.success() {
        return Err("Falha ao formatar USB. Verifique se o drive está correto.".to_string());
    }

    // Monta ISO e copia conteudo
    let output = silent_ps()
        .args([&format!(
            "$iso = Mount-DiskImage -ImagePath '{}' -PassThru; $vol = Get-Volume -DiskImage $iso; $src = $vol.DriveLetter + ':'; Copy-Item -Path \"$src\\*\" -Destination \"{}:\" -Recurse -Force; Dismount-DiskImage -ImagePath '{}'",
            iso_path, usb_drive, iso_path
        )])
        .output()
        .map_err(|e| e.to_string())?;

    // Limpa script temporario
    std::fs::remove_file(&script_path).ok();

    if output.status.success() {
        window.emit("iso-progress", ProgressUpdate {
            step: 8, total_steps: 8,
            message: "USB gravado com sucesso!".to_string(),
            percentage: 100, status: "completed".to_string(),
        }).ok();
        Ok("USB bootável criado com sucesso!".to_string())
    } else {
        Err("Falha ao copiar arquivos para USB".to_string())
    }
}

#[tauri::command]
fn check_oscdimg() -> Result<bool, String> {
    let paths = vec![
        "C:\\Program Files (x86)\\Windows Kits\\10\\Assessment and Deployment Kit\\Deployment Tools\\amd64\\Oscdimg\\oscdimg.exe",
        "C:\\Program Files\\Windows Kits\\10\\Assessment and Deployment Kit\\Deployment Tools\\amd64\\Oscdimg\\oscdimg.exe",
    ];
    for path in paths {
        if Path::new(path).exists() { return Ok(true); }
    }
    let mut where_cmd = Command::new("where");
    where_cmd.creation_flags(CREATE_NO_WINDOW);
    if let Ok(out) = where_cmd.args(["oscdimg.exe"]).output() {
        if !String::from_utf8_lossy(&out.stdout).trim().is_empty() { return Ok(true); }
    }
    Ok(false)
}

#[tauri::command]
fn check_dism() -> Result<bool, String> {
    silent_dism().args(["/?"]).output().map_err(|e| e.to_string())?;
    Ok(true)
}

#[tauri::command]
fn check_admin() -> bool {
    is_admin()
}

#[tauri::command]
fn request_elevation() -> Result<String, String> {
    if is_admin() {
        return Ok("Ja e administrador".to_string());
    }
    request_admin();
    Ok("Solicitando elevacao...".to_string())
}

#[tauri::command]
fn cleanup_iso_work() -> Result<String, String> {
    // Forca desmontagem de qualquer WIM pendente
    silent_dism().args(["/Unmount-Wim", "/MountDir:C:\\YokaiOS\\WIM_Mount", "/Discard"]).output().ok();
    silent_dism().args(["/Unmount-Wim", "/MountDir:C:\\YokaiOS\\WIM_Mount", "/Discard"]).output().ok();
    silent_dism().args(["/Cleanup-Wim"]).output().ok();
    
    // Espera um pouco para o DISM liberar
    std::thread::sleep(std::time::Duration::from_millis(1000));

    // Remove diretorios de trabalho com retry
    let dirs = vec![
        "C:\\YokaiOS\\ISO_Work",
        "C:\\YokaiOS\\WIM_Mount",
    ];
    for dir in dirs {
        for _ in 0..3 {
            if std::fs::remove_dir_all(dir).is_ok() { break; }
            std::thread::sleep(std::time::Duration::from_millis(500));
        }
    }

    // Limpa scripts temporarios
    let temp = std::env::temp_dir();
    let _ = std::fs::remove_file(temp.join("yokai_diskpart.txt"));

    Ok("Cleanup concluido".to_string())
}

fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .invoke_handler(tauri::generate_handler![
            minimize_window,
            maximize_window,
            close_window,
            open_file_dialog,
            save_file_dialog,
            get_system_info,
            get_system_stats,
            disable_service,
            enable_service,
            set_registry,
            run_powershell,
            apply_gaming_optimizations,
            apply_privacy_optimizations,
            apply_performance_optimizations,
            apply_network_optimizations,
            apply_debloat,
            restore_defaults,
            get_available_drives,
            get_usb_drives,
            download_windows_iso,
            extract_iso,
            mount_wim,
            inject_playbook,
            unmount_wim,
            build_iso,
            flash_iso_to_usb,
            check_oscdimg,
            check_dism,
            check_admin,
            request_elevation,
            cleanup_iso_work,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
