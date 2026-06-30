using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
namespace YokaiOS_Toolbox.Pages { public partial class BenchmarkPage : Page { public BenchmarkPage() { InitializeComponent(); } private void Run_Click(object sender, RoutedEventArgs e) { Output.Text = $"=== YOKAIOS BENCHMARK ===\nData: {System.DateTime.Now}\n\n[CPU] Processos: {Process.GetProcesses().Length}\n[SVC] Servicos: ..."; } } }
