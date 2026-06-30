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

            TweakHelper.RunPowerShell("Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1') }");

            MessageBox.Show("Rede aplicada!", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
