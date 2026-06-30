using Microsoft.UI;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using YokaiOS_Toolbox.Pages;

namespace YokaiOS_Toolbox
{
    public sealed partial class MainWindow : Window
    {
        private Button? _currentNavButton;

        public MainWindow()
        {
            this.InitializeComponent();

            // Set title bar
            this.Title = "YokaiOS Toolbox";
            this.AppWindow.TitleBar.PreferredHeightOption = Microsoft.UI.Windowing.TitleBarHeightOption.Tall;

            // Navigate to Dashboard
            NavigateToPage("Dashboard");
            SetActiveNavButton(NavDashboard);
        }

        private void NavButton_Click(object sender, RoutedEventArgs e)
        {
            if (sender is Button button && button.Tag is string pageName)
            {
                NavigateToPage(pageName);
                SetActiveNavButton(button);
            }
        }

        private void NavigateToPage(string pageName)
        {
            Page? page = pageName switch
            {
                "Dashboard" => new DashboardPage(),
                "Gaming" => new GamingPage(),
                "Performance" => new PerformancePage(),
                "Privacy" => new PrivacyPage(),
                "Debloat" => new DebloatPage(),
                "Network" => new NetworkPage(),
                "Services" => new ServicesPage(),
                "Benchmark" => new BenchmarkPage(),
                "Restore" => new RestorePage(),
                _ => null
            };

            if (page != null)
            {
                ContentFrame.Content = page;
                UpdateTitleBar(pageName);
            }
        }

        private void UpdateTitleBar(string pageName)
        {
            var (title, subtitle) = pageName switch
            {
                "Dashboard" => ("Dashboard", "Visao geral do sistema e acoes rapidas"),
                "Gaming" => ("Gaming", "Otimizacoes para maximo desempenho em jogos"),
                "Performance" => ("Performance", "50+ servicos, 60+ tarefas, otimizacoes WinUtil"),
                "Privacy" => ("Privacidade", "20+ otimizacoes para eliminar telemetria e tracking"),
                "Debloat" => ("Debloat", "Remocao de bloatware e componentes desnecessarios"),
                "Network" => ("Rede", "Otimizacoes de rede para baixa latencia"),
                "Services" => ("Servicos", "Gerenciamento de 50+ servicos desabilitados"),
                "Benchmark" => ("Benchmark", "Compare performance antes e depois"),
                "Restore" => ("Restaurar", "Restaure configuracoes padrao do Windows"),
                _ => ("YokaiOS", "")
            };

            PageTitle.Text = title;
            PageSubtitle.Text = subtitle;
        }

        private void SetActiveNavButton(Button button)
        {
            if (_currentNavButton != null)
            {
                _currentNavButton.Background = new SolidColorBrush(Colors.Transparent);
                _currentNavButton.Foreground = (SolidColorBrush)Application.Current.Resources["YokaiTextSecondaryBrush"];
            }

            button.Background = (SolidColorBrush)Application.Current.Resources["YokaiCardBrush"];
            button.Foreground = (SolidColorBrush)Application.Current.Resources["YokaiTextPrimaryBrush"];
            _currentNavButton = button;
        }
    }
}
