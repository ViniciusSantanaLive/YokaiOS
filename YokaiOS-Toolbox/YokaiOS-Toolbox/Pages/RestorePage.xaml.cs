using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
namespace YokaiOS_Toolbox.Pages { public sealed partial class RestorePage : Page { public RestorePage() { this.InitializeComponent(); } private async void Restore_Click(object sender, RoutedEventArgs e) { var d = new ContentDialog { Title = "Restaurar", Content = "Restaurar TODAS as configuracoes padrao?", PrimaryButtonText = "Sim", SecondaryButtonText = "Nao", XamlRoot = this.XamlRoot }; if (await d.ShowAsync() == ContentDialogResult.Primary) { } } } }
