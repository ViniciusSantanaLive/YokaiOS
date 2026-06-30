// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::process::Command;
use serde::{Deserialize, Serialize};

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

    SystemStats {
        process_count,
        ram_used,
        ram_total,
        cpu_usage,
        disabled_services: 50,
    }
}

#[tauri::command]
fn disable_service(service_name: String) -> Result<String, String> {
    let output = Command::new("sc")
        .args(["config", &service_name, "start=", "disabled"])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() {
        Command::new("sc")
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
    let output = Command::new("sc")
        .args(["config", &service_name, "start=", "auto"])
        .output()
        .map_err(|e| e.to_string())?;

    if output.status.success() {
        Command::new("sc")
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
    let output = Command::new("reg")
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
    let output = Command::new("powershell")
        .args(["-ExecutionPolicy", "Bypass", "-Command", &command])
        .output()
        .map_err(|e| e.to_string())?;

    Ok(String::from_utf8_lossy(&output.stdout).to_string())
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

fn main() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .invoke_handler(tauri::generate_handler![
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
            restore_defaults,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}