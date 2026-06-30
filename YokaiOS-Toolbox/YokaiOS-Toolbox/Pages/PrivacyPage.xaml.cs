using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
namespace YokaiOS_Toolbox.Pages { public sealed partial class PrivacyPage : Page { public PrivacyPage() { this.InitializeComponent(); } private async void Apply_Click(object sender, RoutedEventArgs e) { var d = new ContentDialog { Title = "Aplicar", Content = "Aplicar privacidade?", PrimaryButtonText = "Sim", SecondaryButtonText = "Nao", XamlRoot = this.XamlRoot }; if (await d.ShowAsync() == ContentDialogResult.Primary) { } } } }
