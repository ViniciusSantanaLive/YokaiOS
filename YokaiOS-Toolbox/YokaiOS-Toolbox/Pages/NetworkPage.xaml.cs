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

            TweakHelper.ApplyNagleDisable();
            TweakHelper.ApplyTcpOptimization();
            TweakHelper.RunPowerShell("Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1') }");
            TweakHelper.ApplyNetworkThrottlingDisable();
            TweakHelper.ApplyTeredoDisable();
            TweakHelper.ApplyIPv4Preference();

            MessageBox.Show("Rede aplicada!\n\nReinicie para aplicar todas as mudancas.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
