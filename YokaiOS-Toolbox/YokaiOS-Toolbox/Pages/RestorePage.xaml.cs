using System.Windows;
using System.Windows.Controls;
using YokaiOS_Toolbox.Helpers;

namespace YokaiOS_Toolbox.Pages
{
    public partial class RestorePage : Page
    {
        public RestorePage()
        {
            InitializeComponent();
        }

        private void Restore_Click(object sender, RoutedEventArgs e)
        {
            var result = MessageBox.Show("Restaurar TODAS as configuracoes padrao do Windows?\n\nIsso vai reverter todas as otimizacoes aplicadas.", 
                "YokaiOS", MessageBoxButton.YesNo, MessageBoxImage.Warning);
            if (result != MessageBoxResult.Yes) return;

            // Re-enable services
            var services = new[] { "DiagTrack", "dmwappushservice", "SysMain", "WSearch", "wuauserv", "DoSvc", "Spooler", "Fax", "RemoteRegistry", "WerSvc", "DPS", "PcaSvc" };
            foreach (var svc in services) TweakHelper.EnableService(svc);

            // Re-enable telemetry
            TweakHelper.SetRegistryValueLM(@"SOFTWARE\Policies\Microsoft\Windows\DataCollection", "AllowTelemetry", 3, Microsoft.Win32.RegistryValueKind.DWord);

            // Re-enable Game Bar
            TweakHelper.SetRegistryValue(@"SOFTWARE\Microsoft\GameBar", "UseNexusForGameBarEnabled", 1, Microsoft.Win32.RegistryValueKind.DWord);
            TweakHelper.SetRegistryValue(@"System\GameConfigStore", "GameDVR_Enabled", 1, Microsoft.Win32.RegistryValueKind.DWord);

            // Re-enable Game Mode
            TweakHelper.SetRegistryValue(@"SOFTWARE\Microsoft\GameBar", "AutoGameModeEnabled", 1, Microsoft.Win32.RegistryValueKind.DWord);

            // Restore power plan (Balanced)
            TweakHelper.RunPowerShell("powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e");

            // Re-enable transparency
            TweakHelper.ApplyTransparency(false);

            // Re-enable light theme
            TweakHelper.ApplyDarkMode(false);

            MessageBox.Show("Configuracoes padrao restauradas!\n\nReinicie o computador para aplicar todas as mudancas.", 
                "YokaiOS", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
