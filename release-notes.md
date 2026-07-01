# YokaiOS v2.0.0 - Grande Atualizacao

### Correcoes Criticas:
- **Seguranca corrigida**: Mantido CFG (Vanguard), ASLR (osu!), DEP para compatibilidade com anti-cheats
- **Conflitos de rede resolvidos**: autotuninglevel consolidado para 'normal'
- **Overlap eliminado**: Arquivos duplicados de rede, GPU e gaming consolidados
- **Restauracao completa**: Restore-Defaults.ps1 agora reverte TODOS os tweaks (50+ servicos, 60+ tarefas, rede, privacy, CPU mitigacoes, Explorer/Taskbar)

### Novidades:
- **Rede consolidada**: 4 arquivos reduzidos para 1 (tcp-optimization.yml)
- **GPU consolidada**: 2 arquivos reduzidos para 1 (gpu-optimization.yml)
- **Gaming consolidado**: 3 arquivos reduzidos para 1 (game-mode.yml)
- **Performance consolidada**: 2 arquivos de servicos e 2 de tarefas reduzidos para 1 cada
- **Privacy consolidada**: 7 arquivos reduzidos para 2
- **CI/CD com GitHub Actions**: Validacao de YAML, build automatico, releases
- **README profissional**: Comparacao com AtlasOS/ReviOS, troubleshooting, FAQ
- **Toolbox unificada**: Apenas Tauri (Rust + TypeScript), C# WPF removida

### Como instalar:
1. Baixe YokaiOS-v2.0.0.apbx
2. Abra o AME Wizard (https://ameliorated.io/)
3. Carregue o playbook
4. Siga o assistente
5. Reinicie quando solicitado

### Ou manualmente:
Execute Install-YokaiOS.ps1 como Administrador
