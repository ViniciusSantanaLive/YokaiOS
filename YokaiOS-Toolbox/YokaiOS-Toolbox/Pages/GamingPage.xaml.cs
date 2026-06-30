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
            var result = MessageBox.Show("Aplicar otimizacoes de gaming?", "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result != MessageBoxResult.Yes) return;

            TweakHelper.ApplyGameMode(true);
            TweakHelper.ApplyGameBar(true);
            TweakHelper.ApplyFSO(true);
            TweakHelper.ApplyMouseAcceleration(true);
            TweakHelper.SetRegistryValue(@"Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects", "VisualFXSetting", 2, Microsoft.Win32.RegistryValueKind.DWord);

            MessageBox.Show("Gaming aplicado!\n\nReinicie para aplicar todas as mudancas.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
