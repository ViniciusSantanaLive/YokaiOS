using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using System.Diagnostics;

namespace YokaiOS_Toolbox.Pages
{
    public sealed partial class DashboardPage : Page
    {
        public DashboardPage()
        {
            this.InitializeComponent();
            LoadSystemInfo();
        }

        private async void LoadSystemInfo()
        {
            try
            {
                // Process count
                ProcessCount.Text = Process.GetProcesses().Length.ToString();

                // RAM
                var ram = new Microsoft.VisualBasic.Devices.ComputerInfo();
                var totalGB = ram.TotalPhysicalMemory / (1024.0 * 1024.0 * 1024.0);
                var usedGB = (ram.TotalPhysicalMemory - ram.AvailablePhysicalMemory) / (1024.0 * 1024.0 * 1024.0);
                RamUsage.Text = $"{usedGB:F1} GB";

                // Computer name
                ComputerName.Text = Environment.MachineName;

                // Windows version
                WindowsVersion.Text = Environment.OSVersion.VersionString;
            }
            catch { }
        }

        private void ApplyAll_Click(object sender, RoutedEventArgs e)
        {
            // TODO: Apply all optimizations
        }

        private void Benchmark_Click(object sender, RoutedEventArgs e)
        {
            // TODO: Navigate to benchmark
        }

        private void Verify_Click(object sender, RoutedEventArgs e)
        {
            // TODO: Verify installation
        }
    }
}
