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

            TweakHelper.ApplyTelemetry(true);
            TweakHelper.ApplyAdvertisingId(true);
            TweakHelper.ApplyCortana(true);
            TweakHelper.ApplyWebSearch(true);
            TweakHelper.ApplyLocationTracking(true);
            TweakHelper.ApplySmartScreen(true);
            TweakHelper.ApplyFeedback(true);

            MessageBox.Show("Privacidade aplicada!\n\nReinicie para aplicar todas as mudancas.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
