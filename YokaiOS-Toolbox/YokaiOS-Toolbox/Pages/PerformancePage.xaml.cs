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

            if (ChkServices.IsChecked == true) TweakHelper.DisableUnnecessaryServices();
            if (ChkTasks.IsChecked == true) TweakHelper.DisableScheduledTasks();
            if (ChkPowerPlan.IsChecked == true) TweakHelper.ApplyPowerPlan();
            if (ChkMitigations.IsChecked == true) TweakHelper.ApplyMitigations();
            if (ChkDarkMode.IsChecked == true) TweakHelper.ApplyDarkMode(true);
            if (ChkContextMenu.IsChecked == true) TweakHelper.ApplyClassicContextMenu();
            if (ChkReservedStorage.IsChecked == true) TweakHelper.DisableReservedStorage();

            MessageBox.Show("Performance aplicada! Reinicie para melhor efeito.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}