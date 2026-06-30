using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
namespace YokaiOS_Toolbox.Pages { public sealed partial class PerformancePage : Page { public PerformancePage() { this.InitializeComponent(); } private async void Apply_Click(object sender, RoutedEventArgs e) { var d = new ContentDialog { Title = "Aplicar", Content = "Aplicar otimizacoes?", PrimaryButtonText = "Sim", SecondaryButtonText = "Nao", XamlRoot = this.XamlRoot }; if (await d.ShowAsync() == ContentDialogResult.Primary) { } } } }
