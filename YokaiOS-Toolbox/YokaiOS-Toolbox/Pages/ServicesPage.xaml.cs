using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using System.Collections.ObjectModel;
namespace YokaiOS_Toolbox.Pages {
    public class ServiceItem { public string Name { get; set; } = ""; public string Description { get; set; } = ""; public string Status { get; set; } = ""; }
    public sealed partial class ServicesPage : Page {
        public ObservableCollection<ServiceItem> Services { get; } = new();
        public ServicesPage() { this.InitializeComponent(); LoadServices(); }
        private void LoadServices() {
            Services.Add(new() { Name = "DiagTrack", Description = "Telemetria do Windows", Status = "Desabilitado" });
            Services.Add(new() { Name = "dmwappushservice", Description = "WAP Push", Status = "Desabilitado" });
            Services.Add(new() { Name = "SysMain", Description = "Superfetch", Status = "Desabilitado" });
            Services.Add(new() { Name = "WSearch", Description = "Indexador de Busca", Status = "Desabilitado" });
            Services.Add(new() { Name = "wuauserv", Description = "Windows Update", Status = "Desabilitado" });
            Services.Add(new() { Name = "DoSvc", Description = "Delivery Optimization", Status = "Desabilitado" });
            Services.Add(new() { Name = "Spooler", Description = "Impressora", Status = "Desabilitado" });
            Services.Add(new() { Name = "Fax", Description = "Fax", Status = "Desabilitado" });
            Services.Add(new() { Name = "RemoteRegistry", Description = "Registro Remoto", Status = "Desabilitado" });
            Services.Add(new() { Name = "WerSvc", Description = "Relatorio de Erros", Status = "Desabilitado" });
            Services.Add(new() { Name = "XblAuthManager", Description = "Xbox Auth", Status = "Desabilitado" });
            Services.Add(new() { Name = "lfsvc", Description = "Location Service", Status = "Desabilitado" });
            ServicesList.ItemsSource = Services;
        }
    }
}
