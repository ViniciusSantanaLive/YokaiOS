# YokaiOS Toolbox v2.0

Toolbox oficial do YokaiOS feita em **C# + WinUI 3** (mesma stack do AtlasOS).

## Stack

- **C# .NET 8.0**
- **WinUI 3** (Windows App SDK)
- **WinUI 3 Gallery** (componentes)
- **Mica Backdrop** (efeito de vidro do Windows 11)

## Requisitos para Build

- [Visual Studio 2022](https://visualstudio.microsoft.com/) com workload "Windows App SDK"
- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- Windows 10 21H1+ ou Windows 11

## Compilar

### Via Visual Studio
1. Abra `YokaiOS-Toolbox.sln`
2. Selecione `Release` e `x64`
3. Build > Build Solution (Ctrl+Shift+B)

### Via PowerShell
```powershell
.\Build.ps1
```

### Via CLI
```powershell
dotnet publish YokaiOS-Toolbox\YokaiOS-Toolbox.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -o publish
```

## Estrutura

```
YokaiOS-Toolbox/
├── YokaiOS-Toolbox.sln
├── Build.ps1
└── YokaiOS-Toolbox/
    ├── YokaiOS-Toolbox.csproj
    ├── App.xaml / App.xaml.cs
    ├── MainWindow.xaml / MainWindow.xaml.cs
    ├── Pages/
    │   ├── DashboardPage.xaml
    │   ├── GamingPage.xaml
    │   ├── PerformancePage.xaml
    │   ├── PrivacyPage.xaml
    │   ├── DebloatPage.xaml
    │   ├── NetworkPage.xaml
    │   ├── ServicesPage.xaml
    │   ├── BenchmarkPage.xaml
    │   └── RestorePage.xaml
    ├── Controls/
    ├── Helpers/
    ├── Styles/
    └── Assets/
```

## Identidade Visual

- **Tema:** Escuro com Mica Backdrop
- **Cores:** Roxo (#8B5CF6) / Rosa (#EC4899) neon sobre fundo escuro
- **Fonte:** Segoe UI
- **Bordas:** Arredondadas (12px)
- **Cards:** Fundo escuro com borda sutil
