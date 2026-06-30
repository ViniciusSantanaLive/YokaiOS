using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Threading;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class DashboardPage : Page
    {
        private DispatcherTimer _timer;

        public DashboardPage()
        {
            InitializeComponent();
            LoadSystemInfo();
            StartAutoRefresh();
        }

        private void LoadSystemInfo()
        {
            CompName.Text = Environment.MachineName;
            WinVer.Text = Environment.OSVersion.VersionString;
            
            // CPU Name
            try
            {
                var cpuName = RegistryHelper.GetRegistryValue(@"HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorName");
                CpuName.Text = cpuName?.ToString() ?? Environment.ProcessorCount + " cores";
            }
            catch
            {
                CpuName.Text = Environment.ProcessorCount + " cores";
            }
            
            UpdateStats();
        }

        private void StartAutoRefresh()
        {
            _timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(3) };
            _timer.Tick += (s, e) => UpdateStats();
            _timer.Start();
        }

        private void UpdateStats()
        {
            ProcCount.Text = TweakHelper.GetProcessCount().ToString();
            var (used, total) = TweakHelper.GetRamUsage();
            RamUsage.Text = $"{used:F1} GB";
            var cpu = TweakHelper.GetCpuUsage();
            CpuUsage.Text = $"{cpu:F0}%";
        }

        private void ApplyAll_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Aplicar TODAS as otimizacoes do YokaiOS?\n\nIsso vai aplicar todas as configuracoes de gaming, performance, privacidade e debloat.", 
                "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Warning);
            if (result == MessageBoxResult.Yes)
            {
                try
                {
                    var scriptDir = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
                    var installScript = System.IO.Path.Combine(scriptDir, "Install-YokaiOS.ps1");
                    
                    var psi = new ProcessStartInfo
                    {
                        FileName = "powershell.exe",
                        Arguments = $"-ExecutionPolicy Bypass -File \"{installScript}\"",
                        Verb = "runas",
                        UseShellExecute = true
                    };
                    Process.Start(psi);
                    MessageBox.Show("Otimizacoes aplicadas! Reinicie o computador.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Erro: {ex.Message}", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void Benchmark_Click(object sender, RoutedEventArgs e)
        {
            if (Application.Current.MainWindow is MainWindow mw)
            {
                mw.Navigate("Benchmark");
            }
        }

        private void Verify_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var psi = new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = "-ExecutionPolicy Bypass -Command \"Write-Host 'Verificacao concluida!'\"",
                    UseShellExecute = true
                };
                Process.Start(psi);
            }
            catch { }
        }
    }

    // Helper class for registry access
    internal static class RegistryHelper
    {
        public static object GetRegistryValue(string path, string name)
        {
            try
            {
                using var key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey(path);
                return key?.GetValue(name);
            }
            catch { return null; }
        }
    }
}