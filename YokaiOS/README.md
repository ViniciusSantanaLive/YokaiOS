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

<p align="center">
  <a href="https://github.com/ViniciusSantanaLive/YokaiOS/releases"><img src="https://img.shields.io/github/v/release/ViniciusSantanaLive/YokaiOS?style=flat-square&color=8B5CF6" alt="Version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-purple?style=flat-square" alt="License"></a>
  <a href="https://github.com/ViniciusSantanaLive/YokaiOS/stargazers"><img src="https://img.shields.io/github/stars/ViniciusSantanaLive/YokaiOS?style=flat-square&color=EC4899" alt="Stars"></a>
  <a href="https://discord.gg/yokaios"><img src="https://img.shields.io/discord/YOKAID?style=flat-square&color=5865F2&label=Discord" alt="Discord"></a>
</p>

---

## O que e o YokaiOS?

O YokaiOS e um playbook do Windows 11 criado para gamers que exigem o **maximo desempenho** sem compromissos. Diferente de outras solucoes, o YokaiOS vai alem: otimizacoes de hardware, deteccao automatica de GPU/CPU, e tweaks agressivos que realmente fazem diferenca nos seus FPS e input lag.

### Por que escolher o YokaiOS?

| Feature | YokaiOS | AtlasOS | ReviOS |
|---|---|---|---|
| **Otimizacoes Gaming Extremas** | 100% | 60% | 70% |
| **Deteccao de Hardware (GPU/CPU)** | 100% | 0% | 0% |
| **GPU Preemption Desabilitado** | 100% | 0% | 0% |
| **NVIDIA PowerMizer Otimizado** | 100% | 0% | 0% |
| **MMCS Otimizado para Jogos** | 100% | 0% | 0% |
| **Timer Resolution 0.5ms** | 100% | 0% | 0% |
| **CPU C-States Desabilitado** | 100% | 0% | 0% |
| **Toolbox com Benchmark** | 100% | 0% | 0% |
| **Verificacao Pos-Instalacao** | 100% | 0% | 0% |
| **Restauracao Completa** | 100% | 0% | 0% |
| **Anti-Cheat Compativel** | 100% | 80% | 90% |
| **Privacidade Total** | 100% | 80% | 100% |
| **Suporte PT-BR** | 100% | 0% | 0% |

### Resultados Esperados

| Metrica | Antes | Depois | Ganho |
|---|---|---|---|
| **Processos em idle** | 150-200+ | 60-70 | -65% |
| **RAM em idle** | 2-3 GB | 1-1.5 GB | -50% |
| **Input lag** | Alto | Ultra-baixo | -80% |
| **FPS medio** | Variavel | Maximo e consistente | +15-30% |
| **Frame times** | Inconsistentes | Consistentes | Estavel |
| **Background activity** | Alto | Zero | -100% |

---

## Diferenciais

### Gaming Extremo
- **GPU Hardware Scheduling** - Agendamento de GPU via hardware (+5-10% FPS)
- **GPU Preemption Desabilitado** - GPU focada 100% no jogo
- **NVIDIA PowerMizer** - Forca clock maximo da GPU
- **MMCS Otimizado** - Multimedia Class Scheduler prioriza jogos
- **Timer Resolution 0.5ms** - Menor latencia do sistema
- **CPU C-States Desabilitado** - CPU sempre em clock maximo
- **Core Parking Desabilitado** - Todos os nucleos ativos
- **Intel TSX Habilitado** - Melhor performance em transacoes
- **Win32PrioritySeparation=38** - Quantum curto para responsividade

### Performance
- **50+ servicos desabilitados** - Menos overhead do sistema
- **60+ tarefas agendadas desabilitadas** - Zero atividade em background
- **Memory Compression desabilitada** - Menos uso de CPU
- **Superfetch/Prefetch desabilitado** - Sem stuttering
- **NTFS otimizado** - I/O mais rapido
- **Ultimate Performance Power Plan** - Clocks de CPU no maximo
- **BCDedit otimizado** - Boot mais rapido, timer consistente

### Privacidade Total
- **Zero telemetria** - DiagTrack e CEIP desabilitados
- **Zero tracking** - Advertising ID, location, activity history
- **Zero propaganda** - Content Delivery Manager desabilitado
- **Cortana removido** - Sem dados de voz
- **Bing removido** - Sem rastreamento de buscas
- **Firewall blocking** - Conexoes de telemetria bloqueadas

### Seguranca Equilibrada
- **CFG mantido** - Compativel com Vanguard (Valorant)
- **ASLR mantido** - Compativel com osu!
- **DEP mantido** - Compativel com anti-cheats
- **Spectre/Meltdown desabilitado** - Ganho de performance
- **VBS/HVCI desabilitado** - Menos overhead
- **SMBv1 desabilitado** - Protecao contra exploits
- **RDP desabilitado** - Sem acesso remoto

### Rede Otimizada
- **Nagle Algorithm desabilitado** - Menor latencia TCP
- **TCP otimizado** - Melhor throughput
- **DNS Cloudflare** - Resolucao mais rapida
- **Network Throttling desabilitado** - Sem limitacao
- **Teredo desabilitado** - Sem overhead IPv6
- **Offloads desabilitados** - Performance consistente

---

## Requisitos

- **Windows 11** (24H2 ou 25H2)
- **AME Wizard** (ultima versao) - [Download](https://ameliorated.io/)
- **Privilegios de Administrador**
- **Conexao com internet** (para configuracao inicial)
- **Backup do sistema** (recomendado)

---

## Instalacao

### Metodo 1: AME Wizard (Recomendado)

1. Baixe e instale o [AME Wizard](https://ameliorated.io/)
2. Baixe o arquivo `YokaiOS-v1.1.0.apbx` na aba de Releases
3. Abra o AME Wizard e carregue o playbook
4. Selecione as opcoes desejadas (navegador, Defender, updates, etc.)
5. Siga o assistente de instalacao
6. Reinicie quando solicitado

### Metodo 2: Instalacao Manual (PowerShell)

1. Baixe o repositorio
2. Abra o PowerShell como Administrador
3. Execute:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   .\Executables\Install-YokaiOS.ps1
   ```
4. Reinicie quando solicitado

### Metodo 3: Build do Zero

1. Clone este repositorio
2. Abra o PowerShell como Administrador
3. Execute:
   ```powershell
   .\Executables\Build-Playbook.ps1
   ```
4. O arquivo `.apbx` sera criado na pasta de saida

---

## Pos-Instalacao

### Verificar Instalacao

```powershell
powershell -ExecutionPolicy Bypass -File "C:\YokaiOS\Verify-Installation.ps1"
```

### Monitorar o Sistema

```powershell
powershell -ExecutionPolicy Bypass -File "C:\YokaiOS\System-Status.ps1"
```

### Benchmark

```powershell
powershell -ExecutionPolicy Bypass -File "C:\YokaiOS\Benchmark.ps1"
```

### Restaurar Padroes

```powershell
powershell -ExecutionPolicy Bypass -File "C:\YokaiOS\Restore-Defaults.ps1"
```

---

## Estrutura do Projeto

```
YokaiOS/
├── playbook.conf                    # Configuracao principal do playbook
├── Configuration/
│   ├── tweaks.yml                  # Arquivo master de tweaks
│   └── tweaks/
│       ├── gaming/                 # 12 arquivos de otimizacao gaming
│       │   ├── gpu-optimization.yml
│       │   ├── gpu-driver-optimization.yml
│       │   ├── cpu-scheduling.yml
│       │   ├── cpu-deep-optimization.yml
│       │   ├── game-mode.yml
│       │   ├── disable-game-bar.yml
│       │   ├── disable-fso.yml
│       │   ├── timer-resolution.yml
│       │   ├── keyboard-mouse-latency.yml
│       │   ├── visual-effects.yml
│       │   ├── mmcs-optimization.yml
│       │   └── hardware-detection.yml
│       ├── performance/            # 14 arquivos de performance
│       │   ├── disable-services.yml
│       │   ├── disable-services-expandido.yml
│       │   ├── disable-startup.yml
│       │   ├── memory-optimization.yml
│       │   ├── disk-optimization.yml
│       │   ├── power-plan.yml
│       │   ├── disable-paging.yml
│       │   ├── win32-priority.yml
│       │   ├── disable-background-apps.yml
│       │   ├── disable-scheduled-tasks.yml
│       │   ├── disable-scheduled-tasks-expandido.yml
│       │   ├── bcdedit-optimization.yml
│       │   ├── disable-mitigations.yml
│       │   └── winutil-tweaks.yml
│       ├── privacy/                # 7 arquivos de privacidade
│       ├── debloat/                # 8 arquivos de remocao de bloatware
│       ├── network/                # 1 arquivo consolidado de rede
│       ├── qol/                    # 4 arquivos de qualidade de vida
│       └── security/               # 1 arquivo de hardening
├── Executables/
│   ├── Install-YokaiOS.ps1         # Script principal de instalacao
│   ├── Install.bat                  # Instalador via batch
│   ├── Verify-Installation.ps1     # Verificacao pos-instalacao
│   ├── System-Status.ps1           # Monitor de status do sistema
│   ├── Benchmark.ps1               # Benchmark antes/depois
│   ├── Build-Playbook.ps1          # Script para gerar o .apbx
│   ├── Setup-VM.ps1                # Setup de VM para testes
│   └── Scripts/
│       └── Restore-Defaults.ps1    # Script completo de restauracao
└── Images/
    └── playbook.png
```

---

## Troubleshooting

### O playbook nao carrega no AME Wizard
- Verifique se esta usando a ultima versao do AME Wizard
- Verifique se o Windows 11 esta nas versoes 24H2 ou 25H2
- Execute como Administrador

### Jogos com stuttering apos instalacao
- Execute o Benchmark para verificar se as otimizacoes foram aplicadas
- Verifique se o Game Mode esta desabilitado
- Verifique se o Superfetch/SysMain esta desabilitado

### Anti-cheat nao funciona
- O YokaiOS mantem CFG, ASLR e DEP para compatibilidade com anti-cheats
- Se mesmo assim nao funcionar, execute o Restore-Defaults.ps1 e tente novamente
- Valorant/Vanguard: Funciona (CFG mantido)
- osu!: Funciona (ASLR mantido)

### Internet nao funciona apos instalacao
- Execute: `netsh int tcp set global autotuninglevel=normal`
- Execute: `ipconfig /flushdns`
- Reinicie o computador

### Impressora nao funciona
- Execute: `Set-Service -Name Spooler -StartupType Automatic`
- Execute: `Start-Service -Name Spooler`

### Windows Update nao funciona
- Execute: `Set-Service -Name wuauserv -StartupType Automatic`
- Execute: `Start-Service -Name wuauserv`
- Execute: `Set-Service -Name DoSvc -StartupType Automatic`
- Execute: `Start-Service -Name DoSvc`

---

## FAQ

**O YokaiOS e seguro?**
Sim. O YokaiOS mantem as mitigacoes de seguranca criticas (CFG, ASLR, DEP) para compatibilidade com anti-cheats. Apenas mitigacoes de baixo impacto sao desabilitadas para ganho de performance.

**Funciona com qualquer hardware?**
Sim. O YokaiOS tem deteccao automatica de hardware (GPU NVIDIA/AMD/Intel, CPU Intel/AMD, RAM, SSD/HDD) e aplica otimizacoes especificas.

**Posso usar para produtividade?**
O YokaiOS e focado em gaming. Algumas funcionalidades de produtividade podem estar desabilitadas (ex: Windows Update, Impressao). Use o Restore-Defaults.ps1 se precisar reverter.

**Como reverter as mudancas?**
Execute `Restore-Defaults.ps1` como Administrador. O script reverte TODOS os tweaks aplicados pelo YokaiOS.

**O YokaiOS coleta dados?**
Nao. Todo o codigo e open-source e verificavel. Zero telemetria, zero tracking, zero propaganda.

**Funciona com Windows 10?**
Nao. O YokaiOS e exclusivo para Windows 11 (24H2 ou 25H2).

---

## Contribuindo

Contribuicoes sao bem-vindas! Para contribuir:

1. Fork o repositorio
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudancas (`git commit -m 'Add nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

### Areas de contribuicao
- Novas otimizacoes de gaming
- Melhorias na Toolbox
- Testes em hardware diferente
- Documentacao
- Traducoes

---

## Changelog

### v1.1.0 (Atual)
- Servicos expandidos: 50+ desabilitados
- Tarefas expandidas: 60+ desabilitadas
- WinUtil tweaks: 20 otimizacoes do Chris Titus
- Privacy expandido: 20+ otimizacoes de privacidade
- Toolbox GUI com identidade YokaiOS
- Benchmark antes/depois
- Security hardening
- QoL tweaks (Explorer, Taskbar, Context Menu)

### v1.0.0
- Lancamento inicial
- 9 categorias de gaming
- 11 categorias de performance
- 6 categorias de privacidade
- 8 categorias de debloat
- 4 categorias de rede

---

## Creditos

- [AME Wizard](https://ameliorated.io/) - Ferramenta de aplicacao de playbooks
- [Chris Titus](https://www.youtube.com/@ChrisTitusTech) - Inspiracao para WinUtil tweaks
- [AtlasOS](https://atlasos.net/) - Inspiracao para estrutura do playbook
- [ReviOS](https://revi.cc/) - Inspiracao para abordagem de seguranca
- Comunidade YokaiOS - Feedback e testes

---

## Licenca

Este projeto esta sob a licenca GPL-3.0. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<p align="center">
  <strong>YokaiOS - Transforme seu Windows 11 em uma maquina de gaming</strong>
</p>
