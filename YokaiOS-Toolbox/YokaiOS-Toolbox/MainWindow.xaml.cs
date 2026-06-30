using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace YokaiOS_Toolbox
{
    public partial class MainWindow : Window
    {
        private Button? _activeNav;

        public MainWindow()
        {
            InitializeComponent();
            Navigate("Dashboard");
            SetActiveNav(NavDashboard);
        }

        private void Nav_Click(object sender, RoutedEventArgs e)
        {
            if (sender is Button b && b.Tag is string page)
            {
                Navigate(page);
                SetActiveNav(b);
            }
        }

        public void Navigate(string page)
        {
            var (title, sub) = page switch
            {
                "Dashboard" => ("Dashboard", "Visao geral do sistema e acoes rapidas"),
                "Gaming" => ("Gaming", "Otimizacoes para maximo desempenho em jogos"),
                "Performance" => ("Performance", "50+ servicos, 60+ tarefas, otimizacoes WinUtil"),
                "Privacy" => ("Privacidade", "20+ otimizacoes para eliminar telemetria"),
                "Debloat" => ("Debloat", "Remocao de bloatware e componentes desnecessarios"),
                "Network" => ("Rede", "Otimizacoes de rede para baixa latencia"),
                "Services" => ("Servicos", "Gerenciamento de 50+ servicos desabilitados"),
                "Benchmark" => ("Benchmark", "Compare performance antes e depois"),
                "Restore" => ("Restaurar", "Restaure configuracoes padrao do Windows"),
                _ => ("YokaiOS", "")
            };
            PageTitle.Text = title;
            PageSubtitle.Text = sub;
            ContentFrame.Navigate(new System.Uri($"Pages/{page}Page.xaml", System.UriKind.Relative));
        }

        private void SetActiveNav(Button btn)
        {
            if (_activeNav != null)
            {
                _activeNav.Background = Brushes.Transparent;
                _activeNav.Foreground = (Brush)FindResource("YokaiText2");
            }
            btn.Background = (Brush)FindResource("YokaiCard");
            btn.Foreground = (Brush)FindResource("YokaiText");
            _activeNav = btn;
        }
    }
}
