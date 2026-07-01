using System.Windows;
using System.Windows.Controls;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class PrivacyPage : Page
    {
        public PrivacyPage()
        {
            InitializeComponent();
        }

        private void Apply_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Aplicar otimizacoes de privacidade?", "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result != MessageBoxResult.Yes) return;

            if (ChkTelemetry.IsChecked == true) TweakHelper.ApplyTelemetry(true);
            if (ChkTracking.IsChecked == true) TweakHelper.ApplyAdvertisingId(true);
            if (ChkCortana.IsChecked == true) TweakHelper.ApplyCortana(true);
            if (ChkWebSearch.IsChecked == true) TweakHelper.ApplyWebSearch(true);
            if (ChkLocation.IsChecked == true) TweakHelper.ApplyLocationTracking(true);
            if (ChkSmartScreen.IsChecked == true) TweakHelper.ApplySmartScreen(true);
            if (ChkCloudSearch.IsChecked == true) TweakHelper.ApplyCloudSearch();
            if (ChkFeedback.IsChecked == true) TweakHelper.ApplyFeedback(true);

            MessageBox.Show("Privacidade aplicada! Reinicie para melhor efeito.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}