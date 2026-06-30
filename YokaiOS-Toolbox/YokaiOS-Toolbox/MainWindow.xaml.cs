using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace YokaiOS_Toolbox
{
    public partial class MainWindow : Window
    {
        private Button? _activeNav;
        private bool _isDragging;

        public MainWindow()
        {
            InitializeComponent();
            Navigate("Dashboard");
            SetActiveNav(NavDashboard);
        }

        // ==================== TITLE BAR ====================
        private void TitleBar_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ClickCount == 2)
            {
                ToggleMaximize();
            }
            else
            {
                _isDragging = true;
                DragMove();
            }
        }

        private void TitleBar_MouseUp(object sender, MouseButtonEventArgs e)
        {
            _isDragging = false;
        }

        private void TitleBar_MouseMove(object sender, MouseEventArgs e)
        {
            if (_isDragging && WindowState == WindowState.Maximized)
            {
                WindowState = WindowState.Normal;
                var mousePos = PointToScreen(e.GetPosition(this));
                Left = mousePos.X - (Width / 2);
                Top = mousePos.Y - 20;
                DragMove();
            }
        }

        private void BtnMinimize_Click(object sender, RoutedEventArgs e)
        {
            WindowState = WindowState.Minimized;
        }

        private void BtnMaximize_Click(object sender, RoutedEventArgs e)
        {
            ToggleMaximize();
        }

        private void BtnClose_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void ToggleMaximize()
        {
            WindowState = WindowState == WindowState.Maximized ? WindowState.Normal : WindowState.Maximized;
        }

        // ==================== NAVEGAÇÃO ====================
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
                _activeNav.FontWeight = FontWeights.Normal;
            }
            btn.Background = (Brush)FindResource("YokaiCard");
            btn.Foreground = (Brush)FindResource("YokaiText");
            btn.FontWeight = FontWeights.SemiBold;
            _activeNav = btn;
        }
    }
}