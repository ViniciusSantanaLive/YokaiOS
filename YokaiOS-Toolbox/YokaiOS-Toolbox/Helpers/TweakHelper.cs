using Microsoft.Win32;
using System.Diagnostics;

namespace YokaiOS_Toolbox.Helpers
{
    public static class TweakHelper
    {
        // Registry helpers
        public static void SetRegistryValue(string path, string name, object value, RegistryValueKind kind)
        {
            try
            {
                using var key = Registry.CurrentUser.CreateSubKey(path, true);
                key?.SetValue(name, value, kind);
            }
            catch { }
        }

        public static void SetRegistryValueLM(string path, string name, object value, RegistryValueKind kind)
        {
            try
            {
                using var key = Registry.LocalMachine.CreateSubKey(path, true);
                key?.SetValue(name, value, kind);
            }
            catch { }
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
        public static void DisableService(string serviceName)
        {
            try
            {
                RunCommand($"sc.exe config {serviceName} start= disabled");
                RunCommand($"sc.exe stop {serviceName}");
            }
            catch { }
        }

        public static void EnableService(string serviceName)
        {
            try
            {
                RunCommand($"sc.exe config {serviceName} start= auto");
                RunCommand($"sc.exe start {serviceName}");
            }
            catch { }
        }

        // Command helpers
        public static void RunCommand(string command)
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
                Process.Start(psi)?.WaitForExit(5000);
            }
            catch { }
        }

        public static void RunPowerShell(string command)
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
                Process.Start(psi)?.WaitForExit(10000);
            }
            catch { }
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
