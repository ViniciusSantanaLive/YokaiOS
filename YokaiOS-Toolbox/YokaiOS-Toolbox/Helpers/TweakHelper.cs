using System;
using System.Diagnostics;
using Microsoft.Win32;

namespace YokaiOS_Toolbox.Helpers
{
    public static class TweakHelper
    {
        // Registry helpers
        public static bool SetRegistryValue(string path, string name, object value, RegistryValueKind kind)
        {
            try
            {
                using var key = Registry.CurrentUser.CreateSubKey(path, true);
                key?.SetValue(name, value, kind);
                return true;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[Registry HKCU] {path}\\{name}: {ex.Message}");
                return false;
            }
        }

        public static bool SetRegistryValueLM(string path, string name, object value, RegistryValueKind kind)
        {
            try
            {
                using var key = Registry.LocalMachine.CreateSubKey(path, true);
                key?.SetValue(name, value, kind);
                return true;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[Registry HKLM] {path}\\{name}: {ex.Message}");
                return false;
            }
        }

        public static int? GetRegistryValue(string path, string name)
        {
            try
            {
                using var key = Registry.CurrentUser.OpenSubKey(path);
                return key?.GetValue(name) as int?;
            }
            catch { return null; }
        }

        // Service helpers
        public static bool DisableService(string serviceName)
        {
            try
            {
                RunCommand($"sc.exe config {serviceName} start= disabled");
                RunCommand($"sc.exe stop {serviceName}");
                return true;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[Service] Disable {serviceName}: {ex.Message}");
                return false;
            }
        }

        public static bool EnableService(string serviceName)
        {
            try
            {
                RunCommand($"sc.exe config {serviceName} start= auto");
                RunCommand($"sc.exe start {serviceName}");
                return true;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[Service] Enable {serviceName}: {ex.Message}");
                return false;
            }
        }

        // Command helpers
        public static bool RunCommand(string command)
        {
            try
            {
                var psi = new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = $"/c {command}",
                    WindowStyle = ProcessWindowStyle.Hidden,
                    CreateNoWindow = true,
                    UseShellExecute = false
                };
                var proc = Process.Start(psi);
                proc?.WaitForExit(5000);
                return proc?.ExitCode == 0;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[CMD] {command}: {ex.Message}");
                return false;
            }
        }

        public static bool RunPowerShell(string command)
        {
            try
            {
                var psi = new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = $"-ExecutionPolicy Bypass -Command \"{command}\"",
                    WindowStyle = ProcessWindowStyle.Hidden,
                    CreateNoWindow = true,
                    UseShellExecute = false
                };
                var proc = Process.Start(psi);
                proc?.WaitForExit(10000);
                return proc?.ExitCode == 0;
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[PS] {command}: {ex.Message}");
                return false;
            }
        }

        // Gaming tweaks
        public static void ApplyGameMode(bool disable)
        {
            var val = disable ? 0 : 1;
            SetRegistryValue(@"SOFTWARE\Microsoft\GameBar", "AllowAutoGameMode", val, RegistryValueKind.DWord);
            SetRegistryValue(@"SOFTWARE\Microsoft\GameBar", "AutoGameModeEnabled", val, RegistryValueKind.DWord);
        }

        public static void ApplyGameBar(bool disable)
        {
            if (disable)
            {
                SetRegistryValue(@"SOFTWARE\Microsoft\GameBar", "UseNexusForGameBarEnabled", 0, RegistryValueKind.DWord);
                SetRegistryValueLM(@"SOFTWARE\Policies\Microsoft\Windows\GameDVR", "AllowGameDVR", 0, RegistryValueKind.DWord);
                SetRegistryValue(@"System\GameConfigStore", "GameDVR_Enabled", 0, RegistryValueKind.DWord);
            }
        }

        public static void ApplyFSO(bool disable)
        {
            if (disable)
            {
                SetRegistryValue(@"System\GameConfigStore", "GameDVR_FSEBehaviorMode", 2, RegistryValueKind.DWord);
                SetRegistryValue(@"System\GameConfigStore", "GameDVR_HonorUserFSEBehaviorMode", 1, RegistryValueKind.DWord);
                SetRegistryValue(@"System\GameConfigStore", "GameDVR_DXGIHonorFSEWindowsCompatible", 1, RegistryValueKind.DWord);
            }
        }

        // Performance tweaks
        public static void ApplyDarkMode(bool enable)
        {
            var val = enable ? 0 : 1;
            SetRegistryValue(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme", val, RegistryValueKind.DWord);
            SetRegistryValue(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "SystemUsesLightTheme", val, RegistryValueKind.DWord);
        }

        public static void ApplyTransparency(bool disable)
        {
            var val = disable ? 0 : 1;
            SetRegistryValue(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "EnableTransparency", val, RegistryValueKind.DWord);
        }

        public static void ApplyMouseAcceleration(bool disable)
        {
            if (disable)
            {
                SetRegistryValue(@"Control Panel\Mouse", "MouseSpeed", "0", RegistryValueKind.String);
                SetRegistryValue(@"Control Panel\Mouse", "MouseThreshold1", "0", RegistryValueKind.String);
                SetRegistryValue(@"Control Panel\Mouse", "MouseThreshold2", "0", RegistryValueKind.String);
            }
        }

        // Privacy tweaks
        public static void ApplyTelemetry(bool disable)
        {
            if (disable)
            {
                DisableService("DiagTrack");
                DisableService("dmwappushservice");
                SetRegistryValueLM(@"SOFTWARE\Policies\Microsoft\Windows\DataCollection", "AllowTelemetry", 0, RegistryValueKind.DWord);
            }
        }

        public static void ApplyAdvertisingId(bool disable)
        {
            var val = disable ? 0 : 1;
            SetRegistryValue(@"SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo", "Enabled", val, RegistryValueKind.DWord);
        }

        public static void ApplyCortana(bool disable)
        {
            if (disable)
            {
                SetRegistryValueLM(@"SOFTWARE\Policies\Microsoft\Windows\Windows Search", "AllowCortana", 0, RegistryValueKind.DWord);
                DisableService("WSearch");
            }
        }

        public static void ApplyWebSearch(bool disable)
        {
            if (disable)
            {
                SetRegistryValue(@"SOFTWARE\Policies\Microsoft\Windows\Explorer", "DisableSearchBoxSuggestions", 1, RegistryValueKind.DWord);
                SetRegistryValueLM(@"SOFTWARE\Policies\Microsoft\Windows\Windows Search", "ConnectedSearchUseWeb", 0, RegistryValueKind.DWord);
            }
        }

        public static void ApplyLocationTracking(bool disable)
        {
            if (disable)
            {
                DisableService("lfsvc");
                SetRegistryValueLM(@"SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors", "DisableLocation", 1, RegistryValueKind.DWord);
            }
        }

        public static void ApplySmartScreen(bool disable)
        {
            if (disable)
            {
                SetRegistryValueLM(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "SmartScreenEnabled", "Off", RegistryValueKind.String);
            }
        }

        public static void ApplyFeedback(bool disable)
        {
            if (disable)
            {
                SetRegistryValueLM(@"SOFTWARE\Policies\Microsoft\Windows\DataCollection", "DoNotShowFeedbackNotifications", 1, RegistryValueKind.DWord);
                DisableService("WerSvc");
            }
        }

        // Performance - Services
        public static void DisableUnnecessaryServices()
        {
            var services = new[] {
                "DiagTrack", "dmwappushservice", "SysMain", "WSearch", "wuauserv", "DoSvc",
                "Spooler", "Fax", "RemoteRegistry", "WerSvc", "DPS", "PcaSvc",
                "XblAuthManager", "XblGameSave", "XboxNetApiSvc", "lfsvc", "WbioSrvc",
                "WpcMonSvc", "Telemetry", "UCPD", "RetailDemo", "MapsBroker",
                "PhoneSvc", "TapiSrv", "TabletInputService", "WpcMonSvc"
            };
            foreach (var svc in services) DisableService(svc);
        }

        public static void ApplyPowerPlan()
        {
            RunPowerShell("powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c");
        }

        public static void ApplyClassicContextMenu()
        {
            SetRegistryValue(@"Software\Classes\CLSID\{86ca1aa0-a74e-4293-abe8-d26b6e0e8f1d}\InprocServer32", "", "", RegistryValueKind.String);
        }

        public static void ApplyEndTask(bool enable)
        {
            if (enable)
            {
                SetRegistryValue(@"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "TaskbarEndTask", 1, RegistryValueKind.DWord);
            }
        }

        // Debloat
        public static void RemoveAppxPackage(string packageName)
        {
            RunPowerShell($"Get-AppxPackage -Name '{packageName}' -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue");
        }

        public static void RemoveEdge()
        {
            RunPowerShell(@"
                $edgePath = '${env:ProgramFiles(x86)}\Microsoft\Edge\Application\*\Installer\setup.exe'
                $resolved = Resolve-Path -Path $edgePath -ErrorAction SilentlyContinue | Select-Object -Last 1
                if ($resolved) {
                    New-Item -Path '$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe' -Force -ErrorAction SilentlyContinue
                    Start-Process -FilePath $resolved -ArgumentList '--uninstall --system-level --force-uninstall --delete-profile' -Wait
                }
            ");
        }

        public static void RemoveOneDrive()
        {
            RunPowerShell(@"
                Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
                if (Test-Path '$env:SystemRoot\SysWOW64\OneDriveSetup.exe') {
                    Start-Process '$env:SystemRoot\SysWOW64\OneDriveSetup.exe' -ArgumentList '/uninstall' -Wait
                }
            ");
        }

        public static void RemoveXboxApps()
        {
            var xboxApps = new[] {
                "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay",
                "Microsoft.XboxIdentityProvider", "Microsoft.XboxSpeechToTextOverlay",
                "Microsoft.Xbox.TCUI", "Microsoft.GamingApp"
            };
            foreach (var app in xboxApps) RemoveAppxPackage(app);
        }

        public static void RemoveTeams()
        {
            RunPowerShell(@"
                Get-AppxPackage -Name '*Teams*' -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Get-AppxPackage -Name '*Skype*' -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
            ");
        }

        // Network tweaks
        public static void ApplyNagleDisable()
        {
            RunPowerShell(@"
                Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object {
                    $iface = $_.InterfaceIndex
                    Set-NetTCPSetting -InterfaceIndex $iface -TcpNoDelay 1 -ErrorAction SilentlyContinue
                    Set-NetTCPSetting -InterfaceIndex $iface -TcpAckFrequency 1 -ErrorAction SilentlyContinue
                }
            ");
        }

        public static void ApplyTcpOptimization()
        {
            RunPowerShell(@"
                Set-NetTCPSetting -SettingName 'Internet' -AutoTuningLevelLocal 'Normal' -ErrorAction SilentlyContinue
                Set-NetTCPSetting -SettingName 'Internet' -ScalingHeuristics 'Disabled' -ErrorAction SilentlyContinue
                netsh int tcp set global autotuninglevel=normal
                netsh int tcp set global chimney=enabled
                netsh int tcp set global dca=enabled
                netsh int tcp set global netdma=enabled
            ");
        }

        public static void ApplyNetworkThrottlingDisable()
        {
            SetRegistryValueLM(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile", "NetworkThrottlingIndex", 0xFFFFFFFF, RegistryValueKind.DWord);
        }

        public static void ApplyTeredoDisable()
        {
            RunCommand("netsh interface teredo set state disabled");
        }

        public static void ApplyIPv4Preference()
        {
            SetRegistryValueLM(@"SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters", "DisabledComponents", 0x20, RegistryValueKind.DWord);
        }

        // System info
        public static int GetProcessCount() => Process.GetProcesses().Length;

        public static double GetCpuUsage()
        {
            try
            {
                var cpuCounter = new PerformanceCounter("Processor", "% Processor Time", "_Total");
                cpuCounter.NextValue();
                System.Threading.Thread.Sleep(1000);
                return cpuCounter.NextValue();
            }
            catch { return 0; }
        }

        public static (double used, double total) GetRamUsage()
        {
            try
            {
                var psi = new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = "-Command \"$os = Get-CimInstance Win32_OperatingSystem; [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory)/1MB, 2).ToString() + '|' + [math]::Round($os.TotalVisibleMemorySize/1MB, 2).ToString()\"",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                var proc = Process.Start(psi);
                var output = proc?.StandardOutput.ReadToEnd();
                proc?.WaitForExit();
                var parts = output?.Trim().Split('|');
                if (parts?.Length == 2 && double.TryParse(parts[0], out var used) && double.TryParse(parts[1], out var total))
                    return (used, total);
                return (0, 0);
            }
            catch { return (0, 0); }
        }

        public static int GetDisabledServiceCount()
        {
            try
            {
                var psi = new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = "-Command \"(Get-Service | Where-Object {$_.StartType -eq 'Disabled'}).Count\"",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                var proc = Process.Start(psi);
                var output = proc?.StandardOutput.ReadToEnd();
                proc?.WaitForExit();
                return int.TryParse(output?.Trim(), out var count) ? count : 0;
            }
            catch { return 0; }
        }
    }
}
