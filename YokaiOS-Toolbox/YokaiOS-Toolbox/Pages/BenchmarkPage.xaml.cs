using System;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class BenchmarkPage : Page
    {
        public BenchmarkPage()
        {
            InitializeComponent();
        }

        private void Run_Click(object sender, RoutedEventArgs e)
        {
            Output.Text = "Executando benchmark...\n";
            var sb = new System.Text.StringBuilder();

            sb.AppendLine("=== YOKAIOS BENCHMARK ===");
            sb.AppendLine($"Data: {DateTime.Now}");
            sb.AppendLine($"Computador: {Environment.MachineName}");
            sb.AppendLine();

            // CPU
            var cpu = TweakHelper.GetCpuUsage();
            sb.AppendLine($"[CPU] Uso: {cpu:F1}%");

            // RAM
            var (used, total) = TweakHelper.GetRamUsage();
            sb.AppendLine($"[RAM] Uso: {used:F1} GB / {total:F1} GB");

            // Processos
            var procCount = TweakHelper.GetProcessCount();
            sb.AppendLine($"[PROC] Processos: {procCount}");

            // Servicos
            var svcDisabled = TweakHelper.GetDisabledServiceCount();
            sb.AppendLine($"[SVC] Servicos desabilitados: {svcDisabled}");

            // Latencia
            try
            {
                var ping = new System.Net.NetworkInformation.Ping();
                var reply = ping.Send("1.1.1.1", 3000);
                if (reply.Status == System.Net.NetworkInformation.IPStatus.Success)
                    sb.AppendLine($"[NET] Latencia: {reply.RoundtripTime}ms");
                else
                    sb.AppendLine("[NET] Latencia: Timeout");
            }
            catch { sb.AppendLine("[NET] Latencia: Erro"); }

            // Disco
            var disk = new DriveInfo("C");
            var freeGB = disk.AvailableFreeSpace / (1024.0 * 1024.0 * 1024.0);
            sb.AppendLine($"[DISCO] Espaco livre C: {freeGB:F1} GB");

            sb.AppendLine();
            sb.AppendLine("=== BENCHMARK CONCLUIDO ===");

            Output.Text = sb.ToString();
        }
    }
}
