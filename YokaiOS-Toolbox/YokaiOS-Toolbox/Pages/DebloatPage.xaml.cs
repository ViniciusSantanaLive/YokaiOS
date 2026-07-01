using System.Windows;
using System.Windows.Controls;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class DebloatPage : Page
    {
        public DebloatPage()
        {
            InitializeComponent();
        }

        private void Apply_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Aplicar debloat? Isso vai remover os componentes selecionados.", "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Warning);
            if (result != MessageBoxResult.Yes) return;

            if (ChkEdge.IsChecked == true) TweakHelper.RemoveEdge();
            if (ChkOneDrive.IsChecked == true) TweakHelper.RemoveOneDrive();
            if (ChkCopilot.IsChecked == true) TweakHelper.RemoveAppxPackage("Microsoft.Copilot");
            if (ChkWidgets.IsChecked == true) TweakHelper.RemoveAppxPackage("Microsoft.WidgetsPlatformRuntime");
            if (ChkXbox.IsChecked == true) TweakHelper.RemoveXboxApps();
            if (ChkTeams.IsChecked == true) TweakHelper.RemoveTeams();
            if (ChkBloatware.IsChecked == true) TweakHelper.RemoveBloatware();

            MessageBox.Show("Debloat aplicado! Reinicie para melhor efeito.", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}