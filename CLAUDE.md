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

Estado atual: `YokaiOS/playbook.png` é 256×256 e o `Build-Playbook.ps1` já o coloca na raiz do pacote — esse requisito está OK. **O `playbook.conf` ainda não tem `<ProductCode>` nem `<Website>`** (só `<Git>`); ambos entram no momento da submissão.

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

O gerenciador de pacotes é **bun** (`bun.lock`, e `tauri.conf.json` chama `bun dev` / `bunx vite build`). Não há suíte de testes em lugar nenhum do repo — nem `#[test]` no Rust nem script `test` no `package.json`. O `vite build` **não faz type-check** (`tsconfig.json` tem `strict` + `noUnusedLocals`, mas `noEmit`). As checagens estáticas que existem são estas — e passavam limpas em 2026-09-17, então erro aqui é regressão sua:

```bash
cd YokaiOS-Toolbox-Tauri && bunx tsc --noEmit && bunx vite build && (cd src-tauri && cargo check)
```

A única verificação automatizada do playbook é o job `validate` do CI, que roda `yq eval "."` em cada `.yml` sob `YokaiOS/Configuration` — sintaxe YAML apenas; não valida tags, campos nem referências entre arquivos (o que o engine de fato exige está em "O que o engine do AME aceita", abaixo).

Não confie nesse job como rede de segurança: o `try/catch` em volta do `yq` não captura exit code de executável nativo, então o passo conclui verde mesmo com YAML quebrado. Instância concreta: em 2026-09-17 o CI estava verde com dois arquivos ativos (`qol/context-menu.yml`, `performance/winutil-tweaks.yml`) contendo `\S` e `\C` dentro de aspas duplas — escapes inválidos que todo parser estrito rejeita (corrigidos no mesmo dia). Sintaxe local sem instalar `yq` — o PyYAML aceita as tags custom com `BaseLoader`:

```bash
python -c "import glob,yaml;[list(yaml.compose_all(open(f,encoding='utf-8-sig'),Loader=yaml.BaseLoader)) for f in glob.glob('YokaiOS/Configuration/**/*.yml',recursive=True)];print('YAML OK')"
```

Verificação/diagnóstico pós-instalação (scripts standalone, rodam como Admin): `Verify-Installation.ps1`, `System-Status.ps1`, `Benchmark.ps1`, `Scripts/Restore-Defaults.ps1`. Instalação manual sem AME: `Install.bat` → `Install-YokaiOS.ps1` (a quarta cópia dos tweaks — ver "A Toolbox duplica a lógica do playbook").

### Checagens de invariante

As duas divergências estruturais descritas abaixo (arquivo de tweak fora do `main.yml`, option declarado que não gateia nada) não são pegas por nada automatizado. Rode antes e depois de mexer em tweaks:

```bash
cd YokaiOS/Configuration && comm -13 <(grep -oE "path: '[^']+'" main.yml | cut -d"'" -f2 | tr '\134' '/' | sort) <(find tweaks -name '*.yml' | sort)
```

```bash
comm -23 <(grep -oE '<Name>[^<]+</Name>' YokaiOS/playbook.conf | sed 's/<[^>]*>//g' | sort -u) <(grep -rhoE 'option: *"[^"]+"' YokaiOS/Configuration --include='*.yml' | cut -d'"' -f2 | sort -u)
```

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

Uma action só respeita a escolha do usuário no wizard se carregar `option: "<nome>"` casando com um `<Name>` do `playbook.conf`. **Apenas 7 arquivos fazem isso hoje** (`software.yml`, `toolbox.yml`, `security/defender-toggle.yml`, `performance/{disable-mitigations,hibernate-toggle,windows-update-toggle}.yml`, `qol/remove-pinned-items.yml`), cobrindo 15 dos 50 options. Os outros **35** options declarados no `playbook.conf` (`disable-telemetry`, `remove-edge`, `optimize-timer`, `dns-cloudflare`, …) não estão ligados a nenhuma action: **esses tweaks aplicam incondicionalmente, mesmo se o usuário desmarcar a caixa.** Ao adicionar uma opção nova, ligue os dois lados; ao mexer num tweak existente, não presuma que ele é opcional. A lista exata sai da segunda checagem de invariante acima (ignore a linha `YokaiOS`, que é o `<Name>` do playbook, não um option).

É o item #1 a corrigir antes de submeter ao AME: a auditoria deles compara o que a UI promete com o que o playbook faz.

**Semântica confirmada** contra `PrivacyCore-extracted/` (playbook oficial da Ameliorated) e os clones em `reference/`:

- Action **sem** `option:` roda incondicionalmente. O payload inteiro do PrivacyCore (~500 actions) não carrega `option:` nenhum — se ausência significasse "pular", o playbook seria um no-op.
- A escrita aceita as três formas de aspas: `option: "x"` (PrivacyCore, ReviOS), `option: 'x'` (Atlas, ReviOS) e `option: x` sem aspas (ReviOS). Ao grepar, cubra as três — foi o que me fez contar 0 gatings no Atlas na primeira passada.
- Existe **sintaxe de negação**: `option: '!nome'` roda quando a opção NÃO foi marcada. Atlas e ReviOS usam; nós não.

Quanto gateia quanto, medido nos três:

| | options declarados | gateados | órfãos |
|---|---|---|---|
| Atlas | 17 | 15 | 2 |
| ReviOS | 22 | 20 | 2 |
| **YokaiOS** | **50** | **15** | **35** |

Os 2 órfãos do Atlas (`auto-updates-default`, `mitigations-default`) são opções de rádio "manter o padrão", que legitimamente não precisam de action — não fazer nada É o comportamento. Os do ReviOS (`brave`, `firefox`) são resíduo.

Ou seja: os dois concorrentes gateiam ~90% do que declaram, e as exceções são no-ops por definição. O defeito do YokaiOS não é "faltam `option:` nos tweaks" — é **o wizard exibir 35 caixas que não fazem nada**. As duas saídas legítimas: ligar a caixa à action, ou remover a caixa e assumir o tweak como parte da identidade do playbook.

Ponta solta: o PrivacyCore usa `option: "ui"` e `DependsOn="software"`, nomes que **não** estão em nenhum `<Name>` do `playbook.conf` dele. Existe um namespace de options do próprio wizard, acima do playbook. Não sabemos quais são nem se colidem com nomes nossos — confirmar antes de inventar options novos.

### Dois formatos de YAML convivem

O AME aceita ambos e o repo usa os dois — siga o formato do arquivo que você está editando:

- **Documento-tarefa único**: `title`/`description`/`privilege`/`actions:` no topo (ex.: `performance/disable-services-expandido.yml`, `toolbox.yml`). Pode aninhar sub-tarefas com `title:` dentro de `actions:` (ex.: `qol/explorer.yml`).
- **Lista de tarefas**: o documento é um array `- title: ...` (ex.: `gaming/gpu-optimization.yml`, `security/defender-toggle.yml`).

Tags em uso, por frequência: `!registryValue` (331), `!powershell` (112), `!service` (100), `!writeStatus` (68), `!cmd` (48), `!task` (45), `!run` / `!download` (4 cada, só em `software.yml`). Caminhos de registro usam barras duplas escapadas (`HKLM\\SYSTEM\\...`); caminhos de `!task` usam barra invertida simples em aspas simples. (Ambas as formas produzem a mesma string: aspas simples são literais no YAML, aspas duplas processam o escape.)

#### Vocabulário de tags comparado aos concorrentes

Contagens de `reference/Atlas` e `reference/ReviOS` (clones `--depth 1`, gitignorados):

| Tag | YokaiOS | Atlas | ReviOS |
|---|---|---|---|
| `!registryValue` | 331 | 410 | 754 |
| `!registryKey` | **0** | 37 | 103 |
| `!powershell` / `!powerShell` | 112 (minúsculo) | 53 (`!powerShell`) | 25 (`!powerShell`) |
| `!cmd` | 48 | 22 | 7 |
| `!service` | 100 | 13 | 25 |
| `!appx` | **0** | 42 | 5 |
| `!scheduledTask` | **0** | 8 | 0 |
| `!taskKill` | **0** | 7 | 18 |
| `!writeStatus` | 68 | 36 | 32 |

Duas leituras:

1. **`!powershell` vs `!powerShell` — verificar antes de qualquer outra coisa.** Os dois playbooks que usam a tag escrevem com S maiúsculo, nas 78 ocorrências somadas. O YokaiOS escreve minúsculo nas 112 dele. Tag YAML é case-sensitive; se o AME não normalizar, é o bug mais caro do repo. Só um carregamento real no wizard resolve.
2. **Subuso de tags declarativas.** `!registryKey` (deletar chave inteira), `!appx`, `!scheduledTask` e `!taskKill` estão zeradas aqui e são usadas pelos dois concorrentes — o trabalho equivalente sai como `!powershell`/`!cmd`. O AME audita e reverte tag nativa; shell-out é caixa-preta. Note que shell-out em si é normal (Atlas tem 75, ReviOS 32) — o problema é a proporção, não a existência.

Também não usamos a **sintaxe de negação** `option: '!nome'` (roda quando a opção NÃO foi marcada), presente nos dois. Zero ocorrências aqui.

### O que o engine do AME aceita (verificado na fonte)

Lido em 2026-09-17 no repositório do engine que o AME Wizard executa, `Ameliorated-LLC/trusted-uninstaller-cli` (branch `public`; arquivos `TrustedUninstaller.Shared/Parser/PlaybookParser.cs`, `Parser/TaskActionResolver.cs`, `AmeliorationUtil.cs` → `ParseActions`/`RunPlaybook`, `Tasks/UninstallTask.cs`, `Tasks/TaskAction.cs`). Vale mais do que qualquer inferência a partir dos concorrentes.

1. **Cada `.yml` é desserializado como `UninstallTask`, um mapping.** Chaves aceitas na raiz: `title`, `description`, `privilege` (`Admin|TrustedInstaller`, default `Admin`), `actions`, `tasks` (lista de paths filhos), `option`, `options`, `builds`, `cpuArch`, `features`, `priority`, `iso`, `oobe`, `onUpgrade`, `onUpgradeVersions`, `previousOption`. `category:` não existe em nenhum nível. Raiz em lista (`- title: ...`) é `YamlException`.
2. **Todo item de `actions:` precisa de uma tag desta lista, com grafia exata e case-sensitive** (as duas formas, `!x` e `!x:`, resolvem para a mesma classe): `!task` `!file` `!service` `!registryKey` `!registryValue` `!appx` `!systemPackage` `!scheduledTask` `!run` `!powerShell` `!cmd` `!taskKill` `!software` `!download` `!writeStatus` `!status`. `!powershell` minúsculo não está em lista nenhuma; item sem tag (sub-tarefa `- title:` aninhada dentro de `actions:`) idem. Comentadas no engine, portanto indisponíveis: `!lineInFile`, `!user`, `!shortcut`, `!update`.
3. **Campo desconhecido é exceção** (o `DeserializerBuilder` não chama `IgnoreUnmatchedProperties`). `!service` → `name`, `operation` (`stop|continue|start|pause|delete|change`; **default `delete`**), `startup` (int), `deleteStop`, `deleteUsingRegistry`, `device`, `weight` — `state:` e `startup_type:` não existem. `!registryValue` → `path`, `value`, `data`, `type` (`REG_SZ|REG_MULTI_SZ|REG_EXPAND_SZ|REG_DWORD|REG_QWORD|REG_BINARY|REG_NONE`), `scope`, `operation` (default `add`), `weight`. `!cmd`/`!powerShell` → `command`, `runAs`, `timeout`, `wait`, `exeDir`, `handleExitCodes`, `weight`. `!download` → `url`, `destination`, `package`, `overwrite`; `!run` → `exe`, `args`, `path`, `runas`, `exeDir`, `baseDir`, `createWindow`, `hideWindow`, … Toda action herda `option`, `options`, `builds`, `cpuArch` (alias YAML de `Arch` — `arch:` não existe), `iso`, `oobe`, `ignoreErrors`, `status`, `errorAction`, `allowRetries`, `onUpgrade`, `onUpgradeVersions`, `previousOption`. Enums são case-insensitive (`operation: change` funciona).
4. **Falha de parse é fatal para o playbook inteiro.** `ParseActions` converte a `YamlException` de cada filho em `SerializationException` ("… in <arquivo>.yml"), acumula, e ao fim do `main.yml` lança uma única exceção listando todos os arquivos ruins. Em `RunPlaybook` essa chamada está antes de qualquer action rodar e dentro de um `try` que só tem `finally` — a exceção sai do método sem ser capturada. O wizard exibe as páginas do `playbook.conf` normalmente e aborta no Start sem rodar nenhuma action — **a UI carregar não prova nada, porque o YAML só é lido no Start.**
5. **`option:` (`IsApplicableOption`)**: ausente/vazio = roda; comparação `OrdinalIgnoreCase`; `'!nome'` nega; `'a&b'` exige ambos (não misture `&` com `!`); `options: [...]` é any-of para positivos e all-of para negativos. Gateia em três níveis, todos checados antes de recursar: no `!task` do `main.yml` (`- !task: {path: '...', option: 'x'}`, como o Atlas faz), na raiz do arquivo, e por action. `builds: ['26100', '!26200']` segue a mesma lógica de negação.

**Estado medido em 2026-09-17 contra essas regras: 43 dos 45 arquivos ativos falham** — 24 com raiz em lista, 18 com sub-tarefas sem tag, 23 com `!powershell` minúsculo, 2 com `!service` usando `state`/`startup_type` (que, se parseassem, cairiam no default `delete` e apagariam o serviço). Só `performance/disable-services-expandido.yml` e `software.yml` passam. Atlas (191 arquivos) e ReviOS (53) têm zero ocorrências de cada uma dessas quatro classes. Conclusão: o `.apbx` v2.0.0 nunca executou no AME. Modelo canônico de arquivo: `title`/`description`/`actions:` na raiz e cada item `- !registryValue:` (ou outra tag da lista) com seus campos — ex.: `reference/Atlas/src/playbook/Configuration/tweaks/debloat/config-content-delivery.yml`. Ao converter um arquivo, valide contra as cinco regras acima antes de passar ao próximo; não bumpe versão nem rebuild o `.apbx` enquanto houver arquivo ativo fora delas.

### Build do .apbx

`Build-Playbook.ps1` faz, nesta ordem: (1) tenta `cargo tauri build` e copia o exe resultante para `YokaiOS/Executables/YokaiOS-Toolbox.exe` — se `tauri-cli` não estiver instalado, **empacota silenciosamente o exe que já estiver lá**; (2) copia `playbook.conf` + `playbook.png` + `Configuration/` + `Executables/` + `Images/` para um temp; (3) gera 7z criptografado com a senha fixa do AME (`malte`).

Duas armadilhas no script:

- **O output default sobrescreve um release versionado.** `$OutputPath` cai em `<repo>/YokaiOS-v2.0.0.apbx`, que é exatamente o `.apbx` da v2.0.0 rastreado no git. Rodar o build local suja a árvore e pode substituir o artefato publicado por um build não reproduzível. Passe `-OutputPath` para um caminho fora do repo ao testar.
- **O argumento de senha precisa ficar entre aspas** (`"-p$password"`). Sem aspas o PowerShell 5.1 mangla o parâmetro nativo e o 7-Zip produz um `.apbx` que não decripta — o AME rejeita sem erro útil. Há comentário no script marcando isso.

`Executables/` é copiado inteiro para dentro do pacote, incluindo os scripts mortos listados adiante. O script aborta se faltar qualquer um de `playbook.conf`, `playbook.png`, `Configuration\main.yml` ou `Executables\Install-YokaiOS.ps1` (lista `$requiredFiles`) — o instalador manual é dependência dura do build; não remova nem renomeie sem tocar aqui.

## Arquitetura da Toolbox

- `src-tauri/src/main.rs` (~1350 linhas) concentra tudo: 31 comandos `#[tauri::command]`, todos registrados num único `generate_handler!`. `src/lib.rs` está vazio.
- Todo processo externo passa pelos helpers `silent_ps()` / `silent_sc()` / `silent_reg()` / `silent_dism()`, que setam `CREATE_NO_WINDOW` — nunca use `Command::new` cru, senão pisca console no release. Os poucos `Command::new` diretos que existem (`where`, `aria2c`, `robocopy`, `oscdimg`, `diskpart`, `attrib`) setam `.creation_flags(CREATE_NO_WINDOW)` na mão; mantenha isso ao adicionar novos.
- `src/main.ts` (~970 linhas) não usa framework nem router: funções `renderX(): string` retornam HTML, trocadas por `innerHTML` conforme `currentPage`, com `bindPageEvents()` rebindando listeners a cada troca.
- Janela sem decoração (`decorations: false`) — minimizar/maximizar/fechar são comandos Tauri chamados pela titlebar custom.
- `src-tauri/app.manifest` pede `requireAdministrator`; além disso `check_admin` / `request_elevation` reelevam via `Start-Process -Verb RunAs` quando necessário (a criação de ISO exige DISM).
- Dos 31 comandos, 3 estão registrados mas nenhum `invoke()` do frontend os chama (`check_dism`, `check_oscdimg`, `get_available_drives`); `disable_service`, `enable_service` e `set_registry` só são chamados internamente, como funções Rust comuns. Ao mapear frontend → backend, lembre que `applyAction(action)` passa o nome do comando como variável e que há `invoke<T>(...)` com genérico — um grep ingênuo por `invoke('nome')` subestima.

### Pipeline de criação de ISO

Orquestrado pelo frontend em `startISOCreation()` (`src/main.ts`), 8 passos, cada um um comando Rust; progresso volta pelo evento `iso-progress`:

`download_windows_iso?` → `extract_iso` (Mount-DiskImage + robocopy para `C:\YokaiOS\ISO_Work`) → `mount_wim` (DISM em `C:\YokaiOS\WIM_Mount`) → `inject_playbook` → `unmount_wim {commit: true}` → `build_iso` (oscdimg; baixa o Windows ADK automaticamente se não achar) → `flash_iso_to_usb?` → `cleanup_iso_work`.

`inject_playbook` opera offline: `dism /Remove-ProvisionedAppxPackage` para o bloatware, depois `reg load` das hives `SOFTWARE`/`SYSTEM` da imagem montada sob `HKLM\YOKAISOFT` / `HKLM\YOKAISYS`, aplica os valores e dá `reg unload`. O bypass de requisitos grava `Setup\LabConfig\Bypass{TPM,SecureBoot,RAM,CPU}Check` na hive SYSTEM. Se você adicionar tweaks lá, respeite o load/unload existente — a hive é carregada uma única vez por bloco.

Além dos tweaks, `inject_playbook` gera o `autounattend.xml` (`create_autounattend_xml`): conta local a partir de `username`/`password` do `isoConfig`, `AutoLogon`, e `BypassNRO` gravado por registro e por comando no passe `specialize`. O mesmo XML é escrito na raiz da ISO (como `autounattend.xml` e `unattend.xml`) e em `Windows\Panther\unattend.xml` dentro do WIM montado — se mudar o XML, os três destinos precisam acompanhar.

Diferente das páginas de tweak, os toggles da página de ISO **são** funcionais: escrevem em `isoConfig`, que vai inteiro para `inject_playbook`.

### A Toolbox duplica a lógica do playbook, e diverge

`apply_gaming_optimizations`, `apply_privacy_optimizations`, `apply_performance_optimizations`, `apply_network_optimizations`, `apply_debloat` e `restore_defaults` são listas hardcoded em Rust — subconjuntos bem menores do que os `.yml` equivalentes (ex.: `apply_privacy_optimizations` mexe em 2 serviços e 1 chave; `privacy/privacy-expandido.yml` mexe em dezenas). `inject_playbook` é uma **terceira** cópia, e `Install-YokaiOS.ps1` (466 linhas) uma quarta, para instalação manual sem AME. Mudar um tweak num lugar não propaga para os outros — ao alterar comportamento, decida explicitamente quais das quatro trilhas precisam acompanhar. A reversão também tem duas implementações independentes — `restore_defaults` (Rust: reabilita 12 serviços e volta o plano de energia Balanced) e `Scripts/Restore-Defaults.ps1` (410 linhas, 7 fases) — e nenhuma é derivada dos `.yml`. Exemplo concreto da deriva: `Install-YokaiOS.ps1` também instala a Toolbox (fase 16), mas grava o autostart em `HKCU\...\Run` com a flag `--minimized`, que o Rust nunca lê; `toolbox.yml` grava em `HKLM` sem flag.

Dois problemas do mesmo tipo do gap de `option:` — a UI promete mais do que o código entrega:

- **Os checkboxes das páginas de tweak são decorativos.** O handler de `.tweak-toggle` em `bindPageEvents()` só faz `classList.toggle('checked')`; nada lê `data-tweak` depois. `applyAction()` dispara o `apply_*` inteiro independentemente do que está marcado.
- **`apply_*` nunca falha.** Cada chamada interna termina em `.ok()` e a função retorna `Ok(...)` incondicionalmente, então o frontend exibe "Otimizações aplicadas com sucesso!" mesmo que todos os tweaks tenham falhado.

## Armadilhas do repositório

- **`YokaiOS/Executables/YokaiOS-Toolbox.exe` é gitignorado** (`*.exe`) e não existe numa árvore limpa, mas `Build-Playbook.ps1` e `tweaks/toolbox.yml` dependem dele. Sem `tauri-cli` local e sem o exe, o build gera um `.apbx` cujo passo de instalação da Toolbox lança (`throw` explícito no `toolbox.yml`).
- **O job `build` do CI está permanentemente nessa situação**: o runner não tem `tauri-cli` e o exe não está no repo, então todo `.apbx` que o CI produz — inclusive o anexado ao release em tags `v*` — instala sem Toolbox e falha nesse passo. Releases têm de ser buildados localmente até isso ser resolvido. É também o que trava a "auditabilidade do binário embarcado" na submissão ao AME: hoje o exe entra no pacote sem proveniência. Detalhe do mesmo job: o passo faz `cd YokaiOS` e chama o script sem `-OutputPath`, então o `.apbx` cai na raiz do workspace por cima do `YokaiOS-v2.0.0.apbx` rastreado, e o `upload-artifact` com `path: "*.apbx"` (e o release com `./release/*.apbx`) anexa também os `v1.0.0` e `v1.1.0` versionados.
- **Os `.apbx` são versionados de propósito** (comentário no fim do `.gitignore`) — `YokaiOS-v{1.0.0,1.1.0,2.0.0}.apbx` são releases, não lixo de build. Veja acima: o build local sobrescreve o v2.0.0.
- **`tauri.conf.json` aponta para ícones inexistentes**: o array `bundle.icon` lista `icons/128x128@2x.png` e `icons/icon.icns`, e nenhum dos dois está em `src-tauri/icons/` (lá há `32x32.png`, `128x128.png`, `256x256.png`, `icon.ico`, `icon.png`, `logo.png`). Se `cargo tauri build` reclamar de ícone, é isso.
- **Código morto em `Executables/`**: `YokaiOS-Toolbox.ps1` (614 linhas, GUI WinForms legada, substituída pela Tauri), `Install-Toolbox.ps1` e `Download-Toolbox.ps1` não são referenciados por nada — `toolbox.yml` inlineia o próprio PowerShell de instalação. `Setup-VM.ps1` só é citado na documentação e dentro de `Download-Win11ISO.ps1`, que por sua vez ninguém cita. `Install.bat` é apenas o wrapper de `Install-YokaiOS.ps1`. Todos vão dentro do `.apbx` mesmo assim.
- **A versão está duplicada em 8 arquivos (10 ocorrências)** e nada a sincroniza: `playbook.conf` (`<Title>` e `<Version>`), `Configuration/main.yml` (`description`), `Build-Playbook.ps1` (nome do output), `package.json`, `Cargo.toml`, `tauri.conf.json`, `src-tauri/app.manifest` (`assemblyIdentity version="2.0.0.0"`) e duas strings hardcoded na UI em `src/main.ts` (`sidebar-version` e o card do dashboard). Um bump precisa tocar todas; `git grep -n '2\.0\.0' -- ':!*.md' ':!*.lock'` lista o conjunto.
- **Material de referência é local-only.** `PrivacyCore.apbx`, `PrivacyCore-extracted/` e `tools/` estão no `.gitignore`; `reference/{Atlas,ReviOS}` (clones `--depth 1` de `Atlas-OS/Atlas` e `meetrevision/playbook`) está só em `.git/info/exclude`. Um clone limpo não tem nada disso — as seções deste arquivo que citam `reference/` pressupõem recriar com `git clone --depth 1 https://github.com/Atlas-OS/Atlas reference/Atlas` e `git clone --depth 1 https://github.com/meetrevision/playbook reference/ReviOS`.
- **Idioma misto**: textos de UI, `title`/`description` dos YAML e comentários recentes em PT-BR *sem acentos* (por causa de encoding em consoles PS 5.1); YAML mais antigo e parte do Rust em inglês. Acompanhe o arquivo em que você está mexendo. (Este `CLAUDE.md` é a exceção: acentuado normalmente.)
- `tweaks/toolbox.yml` é o **único** arquivo do repo salvo com BOM UTF-8. Preserve ao editar.
- `YokaiOS/README.md` e `YokaiOS/PROJECT_STATUS.md` são marketing/changelog da v2.0.0, não referência técnica — as tabelas comparativas com AtlasOS/ReviOS são estimativas, não medições, e a árvore em "Estrutura do Projeto" do README lista os 12 arquivos mortos como ativos, com contagens por pasta erradas.

## Convenções de commit

Prefixos convencionais, mensagem em PT-BR sem acentos: `feat:`, `fix:`, `chore:`, `docs:`, `release:`.
