using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using System.Diagnostics;
namespace YokaiOS_Toolbox.Pages { public sealed partial class BenchmarkPage : Page { public BenchmarkPage() { this.InitializeComponent(); } private void RunBenchmark_Click(object sender, RoutedEventArgs e) { var sb = new System.Text.StringBuilder(); sb.AppendLine("=== YOKAIOS BENCHMARK ==="); sb.AppendLine($"Data: {DateTime.Now}"); sb.AppendLine(); sb.AppendLine($"[CPU] Uso: ..."); sb.AppendLine($"[RAM] Processos: {Process.GetProcesses().Length}"); sb.AppendLine($"[SVC] Servicos: ..."); BenchmarkOutput.Text = sb.ToString(); } } }
