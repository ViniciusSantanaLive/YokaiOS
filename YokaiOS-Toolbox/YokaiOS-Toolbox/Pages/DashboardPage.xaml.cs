using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
namespace YokaiOS_Toolbox.Pages { public partial class DashboardPage : Page { public DashboardPage() { InitializeComponent(); ProcCount.Text = Process.GetProcesses().Length.ToString(); CompName.Text = System.Environment.MachineName; WinVer.Text = System.Environment.OSVersion.VersionString; } } }
