using System.Windows;
using System.Windows.Controls;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class NetworkPage : Page
    {
        public NetworkPage()
        {
            InitializeComponent();
        }

        private void Apply_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Aplicar otimizacoes de rede?", "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result != MessageBoxResult.Yes) return;

            if (ChkNagle.IsChecked == true) TweakHelper.ApplyNagleDisable();
            if (ChkTCP.IsChecked == true) TweakHelper.ApplyTcpOptimization();
            if (ChkDNS.IsChecked == true) TweakHelper.ApplyCloudflareDNS();
            if (ChkThrottling.IsChecked == true) TweakHelper.ApplyNetworkThrottlingDisable();
            if (ChkTeredo.IsChecked == true) TweakHelper.ApplyTeredoDisable();
            if (ChkIPv4.IsChecked == true) TweakHelper.ApplyIPv4Preference();

            MessageBox.Show("Rede aplicada! Reinicie para melhor efeito.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}