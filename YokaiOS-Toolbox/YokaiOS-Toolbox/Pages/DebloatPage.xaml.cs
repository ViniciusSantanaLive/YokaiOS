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

            TweakHelper.RemoveEdge();
            TweakHelper.RemoveOneDrive();
            TweakHelper.RemoveAppxPackage("Microsoft.549981C3F5F10");
            TweakHelper.RemoveAppxPackage("Microsoft.Copilot");
            TweakHelper.RemoveAppxPackage("Microsoft.WidgetsPlatformRuntime");

            MessageBox.Show("Debloat aplicado!", "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
