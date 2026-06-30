using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace YokaiOS_Toolbox.Pages
{
    public sealed partial class GamingPage : Page
    {
        public GamingPage()
        {
            this.InitializeComponent();
        }

        private async void ApplyGaming_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new ContentDialog
            {
                Title = "Aplicar Gaming",
                Content = "Aplicar todas as otimizacoes de gaming?",
                PrimaryButtonText = "Aplicar",
                SecondaryButtonText = "Cancelar",
                XamlRoot = this.XamlRoot
            };

            var result = await dialog.ShowAsync();
            if (result == ContentDialogResult.Primary)
            {
                // TODO: Apply gaming optimizations
            }
        }
    }
}
