using System.Windows;
using System.Windows.Controls;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class GamingPage : Page
    {
        public GamingPage()
        {
            InitializeComponent();
        }

        private void Apply_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Aplicar otimizacoes de gaming selecionadas?", "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result != MessageBoxResult.Yes) return;

            if (ChkGameMode.IsChecked == true) TweakHelper.ApplyGameMode(true);
            if (ChkGameBar.IsChecked == true) TweakHelper.ApplyGameBar(true);
            if (ChkFSO.IsChecked == true) TweakHelper.ApplyFSO(true);
            if (ChkGPUScheduling.IsChecked == true) TweakHelper.ApplyGPUScheduling();
            if (ChkCPUPriority.IsChecked == true) TweakHelper.ApplyCPUPriority();
            if (ChkTimerRes.IsChecked == true) TweakHelper.ApplyTimerResolution();
            if (ChkMouseAccel.IsChecked == true) TweakHelper.ApplyMouseAcceleration(true);
            if (ChkVisualFX.IsChecked == true) TweakHelper.ApplyVisualEffects();

            MessageBox.Show("Gaming aplicado! Reinicie para melhor efeito.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}