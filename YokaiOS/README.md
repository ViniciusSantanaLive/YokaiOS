# YokaiOS

<p align="center">
  <img src="Images/playbook.png" alt="YokaiOS" width="200"/>
</p>

<p align="center">
  <strong>Windows 11 Ultra-Otimizado para Gaming</strong>
</p>

<p align="center">
  <strong>Maximo Desempenho | 60-70 Processos em Idle | Zero Telemetria</strong>
</p>

---

## O que e o YokaiOS?

O YokaiOS e um playbook personalizado do Windows 11, criado para gamers que querem o maximo desempenho sem compromisso. Inspirado no AtlasOS e ReviOS, o YokaiOS leva a otimizacao para gaming a outro nivel.

### Diferenciais

- **Latencia Ultra-Baixa**: Agendamento de CPU otimizado, aceleracao do mouse desabilitada e remocao do algoritmo de Nagle
- **FPS Maximo**: Otimizacao de GPU, preempcao desabilitada e forcar tela cheia exclusiva
- **Uso Minimo de Recursos**: 60-70 processos em idle, apps e servicos em segundo plano desabilitados
- **Privacidade Total**: Toda telemetria, rastreamento e propaganda removidos
- **Zero Bloat**: Apps pre-instalados, Edge, Cortana, OneDrive e componentes de IA removidos

---

## Requisitos

- Windows 11 (24H2 ou 25H2)
- [AME Wizard](https://ameliorated.io/) (ultima versao)
- Privilegios de Administrador
- Conexao com internet (para configuracao inicial)

---

## Instalacao

### Metodo 1: AME Wizard (Recomendado)

1. Baixe e instale o [AME Wizard](https://ameliorated.io/)
2. Baixe o arquivo `YokaiOS-v1.0.0.apbx` mais recente na aba de Releases
3. Abra o AME Wizard e carregue o playbook
4. Siga o assistente de instalacao
5. Reinicie quando solicitado

### Metodo 2: Instalacao Manual (via PowerShell)

1. Baixe o repositorio
2. Abra o PowerShell como Administrador
3. Execute: `Set-ExecutionPolicy Bypass -Scope Process -Force`
4. Execute: `.\Executables\Install-YokaiOS.ps1`
5. Reinicie quando solicitado

---

## O que esta incluso

```
YokaiOS/
├── playbook.conf                    # Configuracao principal do playbook
├── Configuration/
│   ├── tweaks.yml                  # Arquivo master de tweaks
│   └── tweaks/
│       ├── gaming/                 # Otimizacoes para gaming
│       │   ├── gpu-optimization.yml
│       │   ├── cpu-scheduling.yml
│       │   ├── game-mode.yml
│       │   ├── disable-game-bar.yml
│       │   ├── disable-fso.yml
│       │   ├── timer-resolution.yml
│       │   ├── keyboard-mouse-latency.yml
│       │   ├── visual-effects.yml
│       │   └── mmcs-optimization.yml
│       ├── performance/            # Otimizacoes de performance
│       │   ├── disable-services.yml
│       │   ├── disable-startup.yml
│       │   ├── memory-optimization.yml
│       │   ├── disk-optimization.yml
│       │   ├── power-plan.yml
│       │   ├── disable-paging.yml
│       │   ├── win32-priority.yml
│       │   ├── disable-background-apps.yml
│       │   ├── disable-scheduled-tasks.yml
│       │   ├── bcdedit-optimization.yml
│       │   └── disable-mitigations.yml
│       ├── privacy/                # Configuracoes de privacidade
│       │   ├── disable-telemetry.yml
│       │   ├── disable-tracking.yml
│       │   ├── disable-activity-feed.yml
│       │   ├── disable-cortana.yml
│       │   ├── disable-web-search.yml
│       │   └── disable-advertising.yml
│       ├── debloat/                # Remocao de bloatware
│       │   ├── remove-bloatware.yml
│       │   ├── remove-edge.yml
│       │   ├── remove-onedrive.yml
│       │   ├── remove-xbox-apps.yml
│       │   ├── remove-cortana.yml
│       │   ├── disable-widgets.yml
│       │   ├── disable-copilot.yml
│       │   └── disable-ai-copilot.yml
│       └── network/                # Otimizacoes de rede
│           ├── dns-optimization.yml
│           ├── tcp-optimization.yml
│           ├── disable-network-throttling.yml
│           └── nagle-algorithm.yml
└── Executables/
    ├── Install-YokaiOS.ps1         # Script principal de instalacao
    ├── Install.bat                  # Instalador via batch
    ├── Verify-Installation.ps1     # Verificacao pos-instalacao
    ├── System-Status.ps1           # Monitor de status do sistema
    ├── Build-Playbook.ps1          # Script para gerar o .apbx
    └── Scripts/
        └── Restore-Defaults.ps1    # Script para restaurar padroes
```

---

## Otimizacoes Detalhadas

### Gaming

| Otimizacao | Descricao | Impacto |
|------------|-----------|---------|
| GPU Scheduling | Agendamento de GPU via hardware | +5-10% FPS |
| CPU Priority | Win32PrioritySeparation = 38 | Melhor desempenho em primeiro plano |
| Game Mode | Desabilitado para evitar stuttering | Frame times consistentes |
| Game Bar | Completamente removido | Menos overhead |
| FSO | Forcar tela cheia exclusiva | Menor input lag |
| Timer Resolution | Timer de sistema em 0.5ms | Menor latencia |
| Mouse | Input raw, sem aceleracao | Miras mais precisas |
| Efeitos Visuais | Todas as animacoes desabilitadas | GPU livre para jogos |
| MMCS | Multimedia Class Scheduler otimizado | Melhor priorizacao de jogos |

### Performance

| Otimizacao | Descricao | Impacto |
|------------|-----------|---------|
| Servicos | 20+ servicos desabilitados | -30% processos em idle |
| Superfetch | Desabilitado para evitar stuttering | Performance consistente |
| Memoria | Compressao desabilitada, gerenciamento otimizado | Menor uso de RAM |
| Disco | NTFS otimizado, prefetch desabilitado | I/O reduzido |
| Plano de Energia | Ultimate Performance | Clocks de CPU no maximo |
| Apps em Segundo Plano | Todos os apps UWP bloqueados | Menos interrupcoes |
| Tarefas Agendadas | Telemetria e updates desabilitados | Menos atividade em background |
| BCDedit | Otimizacoes de boot | Boot mais rapido, melhor performance |
| Mitigacoes | Mitigacoes de seguranca de CPU desabilitadas | 5-15% de ganho de performance |

### Privacidade

| Otimizacao | Descricao | Impacto |
|------------|-----------|---------|
| Telemetria | DiagTrack e CEIP desabilitados | Zero coleta de dados |
| Rastreamento | ID de propaganda, localizacao desabilitados | Uso anonimo |
| Cortana | Completamente removido | Sem dados de voz |
| Busca na Web | Bing removido do Menu Iniciar | Sem rastreamento de buscas |
| Propaganda | Todas as sugestoes desabilitadas | Experiencia limpa |

### Rede

| Otimizacao | Descricao | Impacto |
|------------|-----------|---------|
| Algoritmo de Nagle | Desabilitado para TCP | Menor latencia |
| TCP | Configuracoes otimizadas | Melhor throughput |
| Network Throttling | Indice definido como 10 | Throttling equilibrado |
| DNS | Cloudflare 1.1.1.1 | Resolucao mais rapida |

---

## Resultados Esperados

### Antes do YokaiOS
- 150-200+ processos em idle
- 2-3 GB de uso de RAM em idle
- Telemetria e updates em segundo plano
- Stuttering aleatorio em jogos
- Input lag alto

### Depois do YokaiOS
- 60-70 processos em idle
- 1-1.5 GB de uso de RAM em idle
- Zero atividade em segundo plano
- Frame times consistentes
- Input lag ultra-baixo

---

## Pos-Instalacao

### Verificar Instalacao

Execute o script de verificacao para confirmar que tudo foi aplicado:
```powershell
powershell -ExecutionPolicy Bypass -File "C:\YokaiOS\Scripts\Verify-Installation.ps1"
```

### Monitorar o Sistema

Acompanhe o uso de recursos do sistema:
```powershell
powershell -ExecutionPolicy Bypass -File "C:\YokaiOS\Scripts\System-Status.ps1"
```

### Restaurar Padroes

Se precisar reverter as mudancas:
```powershell
powershell -ExecutionPolicy Bypass -File "C:\YokaiOS\Scripts\Restore-Defaults.ps1"
```

---

## Compilar do Zero

Para gerar o arquivo .apbx do playbook:

1. Clone este repositorio
2. Abra o PowerShell como Administrador
3. Execute: `.\Executables\Build-Playbook.ps1`
4. O arquivo .apbx sera criado na pasta de saida

---

## Avisos Importantes

- **Faca backup do sistema** antes de instalar
- **Algumas funcionalidades podem parar de funcionar** apos a otimizacao (ex: Windows Update, Impressao)
- **Script de restauracao incluso** caso precise reverter as mudancas
- **Nao recomendado** para ambientes corporativos/producao
- **Foco em gaming** significa que algumas funcionalidades de produtividade sao desabilitadas

---

## Creditos

- Inspirado pelo [AtlasOS](https://atlasos.net/) e [ReviOS](https://revi.cc/)
- Feito com dedicacao para a comunidade gamer brasileira

---

<p align="center">
  <strong>Bora jogar com YokaiOS!</strong>
</p>
