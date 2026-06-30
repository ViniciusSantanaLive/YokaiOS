using System.Windows;
using System.Windows.Controls;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class PerformancePage : Page
    {
        public PerformancePage()
        {
            InitializeComponent();
        }

        private void Apply_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Aplicar otimizacoes de performance?", "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result != MessageBoxResult.Yes) return;

            TweakHelper.DisableUnnecessaryServices();
            TweakHelper.ApplyPowerPlan();
            TweakHelper.ApplyDarkMode(true);
            TweakHelper.ApplyTransparency(true);
            TweakHelper.ApplyClassicContextMenu();
            TweakHelper.ApplyEndTask(true);

            MessageBox.Show("Performance aplicada!\n\nReinicie para aplicar todas as mudancas.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
