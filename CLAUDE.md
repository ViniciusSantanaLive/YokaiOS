# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repositório

Dois artefatos distribuíveis saem da mesma árvore:

1. **O playbook AME** (`YokaiOS/`) — um `.apbx` (7z criptografado) carregado pelo [AME Wizard](https://ameliorated.io/) que aplica ~600 tweaks de registro/serviço/tarefa num Windows 11 já instalado (builds 26100/26200 apenas).
2. **A YokaiOS Toolbox** (`YokaiOS-Toolbox-Tauri/`) — app Tauri 2 (Rust + TypeScript vanilla) instalado pelo playbook. Aplica tweaks em runtime **e** constrói uma ISO customizada do Win11 (debloat offline via DISM + bypass de TPM/Secure Boot/RAM/CPU).

O diretório raiz também contém `PrivacyCore-extracted/` e `tools/` — material de referência de terceiros, gitignorado, não faz parte do produto.

**Objetivo do projeto**: competir de frente com AtlasOS e ReviOS e, quando pronto, submeter o playbook à equipe do AME (ameliorated.io) para certificação e listagem pública no site deles. Isso significa auditoria externa do código — coerência entre a UI do wizard e o que de fato é aplicado, build reproduzível e auditabilidade do binário embarcado não são polimento, são requisito de entrada. Priorize nessa direção ao avaliar trade-offs.

### Critérios de verificação do AME

Conforme a [doc oficial](https://docs.amelabs.net/developers/verification.html), verificação exige: (1) ser "a well known playbook with a good reputation" — critério subjetivo, decidido por eles; (2) a propriedade `ProductCode` no `playbook.conf`, com um código que **eles** fornecem; (3) contato com `@styris_ame` ou `@actrons` (Discord/Telegram) e submissão do playbook para revisão. A doc também pede `playbook.png` de 256px na raiz do playbook, e o campo opcional `Website` alimenta o botão de verificação.

**Qualquer alteração no playbook invalida a verificação e exige re-submissão.** Isso torna o release um evento caro — agrupe mudanças, não publique a cada commit.

Referência concreta de playbook verificado: `meetrevision/playbook` (ReviOS) carrega `<ProductCode>32</ProductCode>` e `<Website>https://revi.cc</Website>`, com `playbook.conf` + `playbook.png` na raiz e entry point em `Configuration/main.yml`.

## Comandos

```bash
# Build do playbook .apbx (roda de qualquer lugar; exige 7-Zip instalado)
powershell -ExecutionPolicy Bypass -File "YokaiOS\Executables\Build-Playbook.ps1"
```

```bash
# Toolbox: dev (hot reload em localhost:1420) e build release
cd YokaiOS-Toolbox-Tauri && bun install && bun run tauri dev
```

```bash
# Toolbox: binário release -> src-tauri/target/release/yokaios-toolbox.exe
cd YokaiOS-Toolbox-Tauri && cargo tauri build
```

O gerenciador de pacotes é **bun** (`bun.lock`, e `tauri.conf.json` chama `bun dev` / `bunx vite build`). Não há suíte de testes em lugar nenhum do repo — nem `#[test]` no Rust nem script `test` no `package.json`. A única verificação automatizada é o job `validate` do CI, que roda `yq eval "."` em cada `.yml` sob `YokaiOS/Configuration` (sintaxe YAML apenas — não valida tags do AME nem referências entre arquivos).

Não confie nesse job como rede de segurança: o `try/catch` em volta do `yq` não captura exit code de executável nativo, então o passo conclui verde mesmo com YAML quebrado. Valide localmente: `yq eval "." <arquivo>`.

Verificação/diagnóstico pós-instalação (scripts standalone, rodam como Admin): `Verify-Installation.ps1`, `System-Status.ps1`, `Benchmark.ps1`, `Scripts/Restore-Defaults.ps1`.

## Arquitetura do playbook

Cadeia de carregamento — os três níveis precisam concordar ou o tweak simplesmente não roda:

```
playbook.conf          XML: metadados + FeaturePages (a UI do wizard).
                       Cada <Name> aqui é um "option name".
  └─ Configuration/main.yml    Único entry point. Lista de `!task: {path: ...}`.
       └─ Configuration/tweaks/**/*.yml    O trabalho real.
```

**Um arquivo de tweak só executa se estiver listado em `main.yml`.** Hoje 45 dos 57 `.yml` estão referenciados; os 12 restantes são resíduos da consolidação da v2.0.0 e estão mortos:

`gaming/disable-game-bar.yml`, `gaming/gpu-driver-optimization.yml`, `network/{disable-network-throttling,dns-optimization,nagle-algorithm}.yml`, `performance/{disable-services,disable-scheduled-tasks}.yml`, `privacy/{disable-activity-feed,disable-advertising,disable-cortana,disable-tracking,disable-web-search}.yml`

Antes de editar um tweak, confirme que o arquivo está em `main.yml` — senão você está editando código morto (o conteúdo dele provavelmente vive no `*-expandido.yml` ou no consolidado correspondente).

### Gating por `option:`

Uma action só respeita a escolha do usuário no wizard se carregar `option: "<nome>"` casando com um `<Name>` do `playbook.conf`. **Apenas 7 arquivos fazem isso hoje** (`software.yml`, `toolbox.yml`, `security/defender-toggle.yml`, `performance/{disable-mitigations,hibernate-toggle,windows-update-toggle}.yml`, `qol/remove-pinned-items.yml`). Os outros ~35 options declarados no `playbook.conf` (`disable-telemetry`, `remove-edge`, `optimize-timer`, `dns-cloudflare`, …) não estão ligados a nenhuma action: **esses tweaks aplicam incondicionalmente, mesmo se o usuário desmarcar a caixa.** Ao adicionar uma opção nova, ligue os dois lados; ao mexer num tweak existente, não presuma que ele é opcional.

### Dois formatos de YAML convivem

O AME aceita ambos e o repo usa os dois — siga o formato do arquivo que você está editando:

- **Documento-tarefa único**: `title`/`description`/`privilege`/`actions:` no topo (ex.: `performance/disable-services-expandido.yml`, `toolbox.yml`). Pode aninhar sub-tarefas com `title:` dentro de `actions:` (ex.: `qol/explorer.yml`).
- **Lista de tarefas**: o documento é um array `- title: ...` (ex.: `gaming/gpu-optimization.yml`, `security/defender-toggle.yml`).

Tags em uso, por frequência: `!registryValue` (331), `!powershell` (112), `!service` (100), `!writeStatus` (68), `!cmd` (48), `!task` (45), `!run` / `!download` (4 cada, só em `software.yml`). Caminhos de registro usam barras duplas escapadas (`HKLM\\SYSTEM\\...`); caminhos de `!task` usam barra invertida simples em aspas simples.

### Build do .apbx

`Build-Playbook.ps1` faz, nesta ordem: (1) tenta `cargo tauri build` e copia o exe resultante para `YokaiOS/Executables/YokaiOS-Toolbox.exe` — se `tauri-cli` não estiver instalado, **empacota silenciosamente o exe que já estiver lá**; (2) copia `playbook.conf` + `Configuration/` + `Executables/` + `Images/` para um temp; (3) gera 7z criptografado com a senha fixa do AME (`malte`).

O argumento de senha precisa ficar entre aspas (`"-p$password"`). Sem aspas o PowerShell 5.1 mangla o parâmetro nativo e o 7-Zip produz um `.apbx` que não decripta — o AME rejeita sem erro útil. Há comentário no script marcando isso.

## Arquitetura da Toolbox

- `src-tauri/src/main.rs` (~1350 linhas) concentra tudo: 30 comandos `#[tauri::command]`, todos registrados num único `generate_handler!`. `src/lib.rs` está vazio.
- Todo processo externo passa pelos helpers `silent_ps()` / `silent_sc()` / `silent_reg()` / `silent_dism()`, que setam `CREATE_NO_WINDOW` — nunca use `Command::new` cru, senão pisca console no release.
- `src/main.ts` (~970 linhas) não usa framework nem router: funções `renderX(): string` retornam HTML, trocadas por `innerHTML` conforme `currentPage`, com `bindPageEvents()` rebindando listeners a cada troca. `src/pages/` existe mas está vazia.
- Janela sem decoração (`decorations: false`) — minimizar/maximizar/fechar são comandos Tauri chamados pela titlebar custom.
- `src-tauri/app.manifest` pede `requireAdministrator`; além disso `check_admin` / `request_elevation` reelevam via `Start-Process -Verb RunAs` quando necessário (a criação de ISO exige DISM).

### Pipeline de criação de ISO

Orquestrado pelo frontend em `startISOCreation()` (`src/main.ts`), 8 passos, cada um um comando Rust; progresso volta pelo evento `iso-progress`:

`download_windows_iso?` → `extract_iso` (Mount-DiskImage + robocopy para `C:\YokaiOS\ISO_Work`) → `mount_wim` (DISM em `C:\YokaiOS\WIM_Mount`) → `inject_playbook` → `unmount_wim {commit: true}` → `build_iso` (oscdimg; baixa o Windows ADK automaticamente se não achar) → `flash_iso_to_usb?` → `cleanup_iso_work`.

`inject_playbook` opera offline: `dism /Remove-ProvisionedAppxPackage` para o bloatware, depois `reg load` das hives `SOFTWARE`/`SYSTEM` da imagem montada sob `HKLM\YOKAISOFT` / `HKLM\YOKAISYS`, aplica os valores e dá `reg unload`. O bypass de requisitos grava `Setup\LabConfig\Bypass{TPM,SecureBoot,RAM,CPU}Check` na hive SYSTEM. Se você adicionar tweaks lá, respeite o load/unload existente — a hive é carregada uma única vez por bloco.

### A Toolbox duplica a lógica do playbook, e diverge

`apply_gaming_optimizations`, `apply_privacy_optimizations`, `apply_performance_optimizations`, `apply_network_optimizations`, `apply_debloat` e `restore_defaults` são listas hardcoded em Rust — subconjuntos bem menores do que os `.yml` equivalentes (ex.: `apply_privacy_optimizations` mexe em 2 serviços e 1 chave; `privacy/privacy-expandido.yml` mexe em dezenas). `inject_playbook` é uma **terceira** cópia, e `Install-YokaiOS.ps1` (466 linhas) uma quarta, para instalação manual sem AME. Mudar um tweak num lugar não propaga para os outros — ao alterar comportamento, decida explicitamente quais das quatro trilhas precisam acompanhar.

## Armadilhas do repositório

- **`.gitignore` tem `*.json` com exceção só para `package.json`.** Resultado: `tauri.conf.json`, `tsconfig.json` e `tsconfig.node.json` existem no disco mas **não estão versionados** — um clone limpo não compila a Toolbox. Se precisar mexer neles, force-add (`git add -f`) ou conserte o padrão; não assuma que estão no repo.
- **`YokaiOS/Executables/YokaiOS-Toolbox.exe` também é ignorado** (`*.exe`), mas `Build-Playbook.ps1` e `tweaks/toolbox.yml` dependem dele existir. Sem `tauri-cli` local e sem o exe, o build gera um `.apbx` cujo passo de instalação da Toolbox lança erro.
- **Os `.apbx` são versionados de propósito** (comentário no fim do `.gitignore`) — `YokaiOS-v{1.0.0,1.1.0,2.0.0}.apbx` são releases, não lixo de build.
- **Código morto em `Executables/`**: `YokaiOS-Toolbox.ps1` (614 linhas, GUI WinForms legada, substituída pela Tauri), `Install-Toolbox.ps1` e `Download-Toolbox.ps1` não são referenciados por nada — `toolbox.yml` inlineia o próprio PowerShell de instalação. `Setup-VM.ps1` e `Download-Win11ISO.ps1` só aparecem citados na documentação.
- **A versão está duplicada em 7 lugares** e nada a sincroniza: `playbook.conf` (`<Title>` e `<Version>`), `Configuration/main.yml` (`description`), `Build-Playbook.ps1` (nome do output), `package.json`, `Cargo.toml`, `tauri.conf.json`. Um bump precisa tocar todos.
- **Idioma misto**: textos de UI, `title`/`description` dos YAML e comentários recentes em PT-BR *sem acentos* (por causa de encoding em consoles PS 5.1); YAML mais antigo e parte do Rust em inglês. Acompanhe o arquivo em que você está mexendo.
- `tweaks/toolbox.yml` está salvo com BOM UTF-8. Preserve ao editar.

## Convenções de commit

Prefixos convencionais, mensagem em PT-BR sem acentos: `feat:`, `fix:`, `chore:`, `docs:`, `release:`.
