import { invoke } from '@tauri-apps/api/core';
import './styles/global.css';

// ==================== SVG ICONS ====================
const Icons = {
  dashboard: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>`,
  gaming: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="6" y1="12" x2="10" y2="12"/><line x1="8" y1="10" x2="8" y2="14"/><line x1="15" y1="13" x2="15.01" y2="13"/><line x1="18" y1="11" x2="18.01" y2="11"/><path d="M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 9.828 16h4.344a2 2 0 0 1 1.414.586L17 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.545-.604-6.584-.685-7.258-.007-.05-.011-.1-.017-.151A4 4 0 0 0 17.32 5z"/></svg>`,
  performance: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>`,
  privacy: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>`,
  debloat: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>`,
  network: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.55a11 11 0 0 1 14.08 0"/><path d="M1.42 9a16 16 0 0 1 21.16 0"/><path d="M8.53 16.11a6 6 0 0 1 6.95 0"/><line x1="12" y1="20" x2="12.01" y2="20"/></svg>`,
  services: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>`,
  benchmark: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>`,
  restore: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"/></svg>`,
  check: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>`,
  rocket: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"/><path d="M12 15l-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z"/><path d="M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0"/><path d="M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5"/></svg>`,
  zap: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>`,
  shield: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>`,
  trash: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>`,
  globe: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>`,
  cpu: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2" ry="2"/><rect x="9" y="9" width="6" height="6"/><line x1="9" y1="1" x2="9" y2="4"/><line x1="15" y1="1" x2="15" y2="4"/><line x1="9" y1="20" x2="9" y2="23"/><line x1="15" y1="20" x2="15" y2="23"/><line x1="20" y1="9" x2="23" y2="9"/><line x1="20" y1="14" x2="23" y2="14"/><line x1="1" y1="9" x2="4" y2="9"/><line x1="1" y1="14" x2="4" y2="14"/></svg>`,
  ram: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="12" x2="6" y2="12.01"/><line x1="10" y1="12" x2="10" y2="12.01"/><line x1="14" y1="12" x2="14" y2="12.01"/><line x1="18" y1="12" x2="18" y2="12.01"/></svg>`,
  activity: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>`,
  settings: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>`,
  minimize: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"/></svg>`,
  maximize: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="5" width="14" height="14" rx="1"/></svg>`,
  close: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>`,
};

// ==================== TYPES ====================
interface SystemInfo {
  computer_name: string;
  windows_version: string;
  cpu_name: string;
  cpu_cores: number;
}

interface SystemStats {
  process_count: number;
  ram_used: number;
  ram_total: number;
  cpu_usage: number;
  disabled_services: number;
}

// ==================== STATE ====================
let currentPage = 'dashboard';
let systemInfo: SystemInfo | null = null;
let systemStats: SystemStats | null = null;
let isNavigating = false;

const app = document.getElementById('app')!;

// ==================== INIT ====================
async function init() {
  renderApp();
  await Promise.all([loadSystemInfo(), loadSystemStats()]);
  setInterval(loadSystemStats, 5000);
}

// ==================== RENDER ====================
function renderApp() {
  app.innerHTML = `
    <div class="app">
      ${renderSidebar()}
      <div class="main">
        ${renderTitlebar()}
        <div class="content" id="content">
          ${renderPage(currentPage)}
        </div>
      </div>
    </div>
  `;
  bindEvents();
}

function renderTitlebar(): string {
  return `
    <div class="titlebar">
      <div class="titlebar-brand">
        <img src="icons/logo.png" class="titlebar-logo" alt="YokaiOS" onerror="this.style.display='none'">
        <span class="titlebar-text">YOKAI OS TOOLBOX</span>
      </div>
      <div class="titlebar-controls">
        <button class="titlebar-btn" id="btn-min">${Icons.minimize}</button>
        <button class="titlebar-btn" id="btn-max">${Icons.maximize}</button>
        <button class="titlebar-btn close" id="btn-close">${Icons.close}</button>
      </div>
    </div>
  `;
}

function renderSidebar(): string {
  const nav = [
    { id: 'dashboard', icon: Icons.dashboard, label: 'Dashboard' },
    { id: 'gaming', icon: Icons.gaming, label: 'Gaming' },
    { id: 'performance', icon: Icons.performance, label: 'Performance' },
    { id: 'privacy', icon: Icons.privacy, label: 'Privacidade' },
    { id: 'debloat', icon: Icons.trash, label: 'Debloat' },
    { id: 'network', icon: Icons.globe, label: 'Rede' },
  ];

  const sys = [
    { id: 'services', icon: Icons.settings, label: 'Servicos' },
    { id: 'benchmark', icon: Icons.benchmark, label: 'Benchmark' },
    { id: 'restore', icon: Icons.restore, label: 'Restaurar' },
  ];

  return `
    <div class="sidebar">
      <div class="sidebar-header">
        <div class="sidebar-brand">
          <img src="icons/logo.png" class="sidebar-logo" alt="YokaiOS" onerror="this.style.display='none'">
          <div class="sidebar-info">
            <div class="sidebar-name">YOKAI OS</div>
            <div class="sidebar-version">v2.0.0</div>
          </div>
        </div>
      </div>
      <div class="sidebar-nav">
        <div class="nav-section">
          <div class="nav-label">Principal</div>
          ${nav.map(n => `
            <button class="nav-item ${currentPage === n.id ? 'active' : ''}" data-page="${n.id}">
              ${n.icon}
              <span>${n.label}</span>
            </button>
          `).join('')}
        </div>
        <div class="separator"></div>
        <div class="nav-section">
          <div class="nav-label">Sistema</div>
          ${sys.map(n => `
            <button class="nav-item ${currentPage === n.id ? 'active' : ''}" data-page="${n.id}">
              ${n.icon}
              <span>${n.label}</span>
            </button>
          `).join('')}
        </div>
      </div>
      <div class="sidebar-footer">
        <div class="sidebar-footer-text">YokaiOS Toolbox v2.0</div>
      </div>
    </div>
  `;
}

function renderPage(page: string): string {
  const pages: Record<string, () => string> = {
    dashboard: renderDashboard,
    gaming: renderGaming,
    performance: renderPerformance,
    privacy: renderPrivacy,
    debloat: renderDebloat,
    network: renderNetwork,
    services: renderServices,
    benchmark: renderBenchmark,
    restore: renderRestore,
  };
  return (pages[page] || renderDashboard)();
}

// ==================== PAGES ====================

function renderDashboard(): string {
  const s = systemStats;
  const i = systemInfo;
  return `
    <div class="fade-in">
      <div class="page-header">
        <h1 class="page-title">Dashboard</h1>
        <p class="page-subtitle">Visao geral do sistema</p>
        <div class="page-divider"></div>
      </div>
      <div class="stats-row">
        <div class="stat">
          <div class="stat-icon">${Icons.activity}</div>
          <div class="stat-label">Processos</div>
          <div class="stat-value">${s?.process_count ?? '...'}</div>
          <div class="stat-change">em execucao</div>
        </div>
        <div class="stat">
          <div class="stat-icon">${Icons.ram}</div>
          <div class="stat-label">RAM</div>
          <div class="stat-value">${s ? s.ram_used.toFixed(1) : '...'} GB</div>
          <div class="stat-change">em uso</div>
        </div>
        <div class="stat">
          <div class="stat-icon">${Icons.cpu}</div>
          <div class="stat-label">CPU</div>
          <div class="stat-value">${s ? s.cpu_usage.toFixed(0) : '...'}%</div>
          <div class="stat-change">uso medio</div>
        </div>
        <div class="stat">
          <div class="stat-icon">${Icons.settings}</div>
          <div class="stat-label">Servicos</div>
          <div class="stat-value">${s?.disabled_services ?? '50+'}</div>
          <div class="stat-change">desabilitados</div>
        </div>
      </div>
      <div class="card">
        <div class="card-header">
          <div>
            <div class="card-title">Acoes Rapidas</div>
            <div class="card-subtitle">Execute as otimizacoes com um clique</div>
          </div>
        </div>
        <div class="btn-group">
          <button class="btn btn-primary" id="btn-apply-all">${Icons.rocket} Aplicar Tudo</button>
          <button class="btn btn-secondary" id="btn-go-bench">${Icons.benchmark} Benchmark</button>
          <button class="btn btn-secondary" id="btn-verify">${Icons.check} Verificar</button>
        </div>
      </div>
      <div class="card">
        <div class="card-title mb-4">Informacoes do Sistema</div>
        <div class="info-grid">
          <div class="info-item">
            <div class="info-label">Computador</div>
            <div class="info-value">${i?.computer_name ?? '...'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Windows</div>
            <div class="info-value">${i?.windows_version ?? '...'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Processador</div>
            <div class="info-value">${i?.cpu_name ?? '...'}</div>
          </div>
          <div class="info-item">
            <div class="info-label">Yokai OS</div>
            <div class="info-value info-value-accent"><span class="info-dot"></span> v2.0.0</div>
          </div>
        </div>
      </div>
    </div>
  `;
}

function renderGaming(): string {
  const tweaks = [
    { id: 'gamemode', title: 'Desabilitar Game Mode', desc: 'Evita stuttering causado pelo Game Mode', badge: 'high' },
    { id: 'gamebar', title: 'Desabilitar Game Bar e DVR', desc: 'Remove overlay que consome recursos', badge: 'high' },
    { id: 'fso', title: 'Desabilitar Fullscreen Optimizations', desc: 'Forca tela cheia exclusiva', badge: 'medium' },
    { id: 'gpu', title: 'Otimizar GPU Scheduling', desc: 'Hardware-accelerated GPU scheduling', badge: 'low' },
    { id: 'cpu', title: 'Otimizar CPU Priority', desc: 'Win32PrioritySeparation = 38', badge: 'low' },
    { id: 'timer', title: 'Timer Resolution 0.5ms', desc: 'Reduz latencia do timer do sistema', badge: 'medium' },
    { id: 'mouse', title: 'Desabilitar Aceleracao do Mouse', desc: 'Input raw 1:1 para miras precisas', badge: 'high' },
    { id: 'visual', title: 'Desabilitar Efeitos Visuais', desc: 'Remove animacoes para liberar GPU', badge: 'medium' },
  ];
  return renderTweakPage('Gaming', 'Otimizacoes para maximo desempenho em jogos', tweaks, 'btn-apply-gaming', 'Aplicar Gaming');
}

function renderPerformance(): string {
  const tweaks = [
    { id: 'services', title: 'Desabilitar 50+ Servicos', desc: 'Remove servicos desnecessarios', badge: 'high' },
    { id: 'tasks', title: 'Desabilitar 60+ Tarefas Agendadas', desc: 'Remove tarefas de telemetria', badge: 'high' },
    { id: 'power', title: 'Plano Ultimate Performance', desc: 'Maximo desempenho do processador', badge: 'low' },
    { id: 'darkmode', title: 'Modo Escuro', desc: 'Ativa tema escuro do sistema', badge: 'info' },
    { id: 'contextmenu', title: 'Menu Contexto Classico', desc: 'Restaura menu do Windows 10', badge: 'info' },
  ];
  return renderTweakPage('Performance', '50+ servicos, 60+ tarefas, otimizacoes WinUtil', tweaks, 'btn-apply-performance', 'Aplicar Performance');
}

function renderPrivacy(): string {
  const tweaks = [
    { id: 'telemetry', title: 'Desabilitar Telemetria', desc: 'Remove DiagTrack e dmwappushservice', badge: 'high' },
    { id: 'tracking', title: 'Desabilitar Tracking e Advertising ID', desc: 'Remove ID de propaganda', badge: 'high' },
    { id: 'cortana', title: 'Desabilitar Cortana', desc: 'Remove assistente virtual da Microsoft', badge: 'medium' },
    { id: 'websearch', title: 'Desabilitar Busca Web (Bing)', desc: 'Remove Bing do Menu Iniciar', badge: 'medium' },
    { id: 'location', title: 'Desabilitar Location Tracking', desc: 'Remove servico de localizacao', badge: 'medium' },
  ];
  return renderTweakPage('Privacidade', '20+ otimizacoes para eliminar telemetria', tweaks, 'btn-apply-privacy', 'Aplicar Privacidade');
}

function renderDebloat(): string {
  const tweaks = [
    { id: 'edge', title: 'Remover Microsoft Edge', desc: 'Remove navegador Edge do sistema', badge: 'medium' },
    { id: 'onedrive', title: 'Remover OneDrive', desc: 'Remove cloud storage da Microsoft', badge: 'medium' },
    { id: 'copilot', title: 'Remover Copilot e IA', desc: 'Remove assistente de IA', badge: 'medium' },
    { id: 'widgets', title: 'Remover Widgets', desc: 'Remove painel de widgets', badge: 'low' },
    { id: 'xbox', title: 'Remover Xbox Apps', desc: 'Remove apps Xbox exceto Game Bar', badge: 'low' },
  ];
  return renderTweakPage('Debloat', 'Remocao de bloatware e componentes desnecessarios', tweaks, 'btn-apply-debloat', 'Aplicar Debloat');
}

function renderNetwork(): string {
  const tweaks = [
    { id: 'nagle', title: 'Desabilitar Algoritmo de Nagle', desc: 'Reduz latencia em conexoes TCP', badge: 'high' },
    { id: 'dns', title: 'DNS Cloudflare (1.1.1.1)', desc: 'DNS mais rapido e privado', badge: 'low' },
    { id: 'throttling', title: 'Desabilitar Network Throttling', desc: 'Remove limitacao de rede', badge: 'medium' },
    { id: 'teredo', title: 'Desabilitar Teredo', desc: 'Remove tunel IPv6 problematico', badge: 'medium' },
  ];
  return renderTweakPage('Rede', 'Otimizacoes de rede para baixa latencia', tweaks, 'btn-apply-network', 'Aplicar Rede');
}

function renderTweakPage(title: string, subtitle: string, tweaks: Array<{id: string, title: string, desc: string, badge: string}>, btnId: string, btnLabel: string): string {
  return `
    <div class="fade-in">
      <div class="page-header">
        <h1 class="page-title">${title}</h1>
        <p class="page-subtitle">${subtitle}</p>
        <div class="page-divider"></div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">${title}</div>
          <span class="toggle-badge badge-info">${tweaks.length} opcoes</span>
        </div>
        ${tweaks.map(t => `
          <div class="toggle-item" data-tweak="${t.id}">
            <div class="toggle checked">${Icons.check}</div>
            <div class="toggle-content">
              <div class="toggle-title">${t.title}</div>
              <div class="toggle-desc">${t.desc}</div>
            </div>
            <span class="toggle-badge badge-${t.badge}">${t.badge === 'high' ? 'Alto' : t.badge === 'medium' ? 'Medio' : t.badge === 'low' ? 'Baixo' : 'Info'}</span>
          </div>
        `).join('')}
      </div>
      <div class="card">
        <button class="btn btn-primary" id="${btnId}">${Icons.rocket} ${btnLabel}</button>
      </div>
    </div>
  `;
}

function renderServices(): string {
  const services = [
    { name: 'DiagTrack', desc: 'Telemetria do Windows' },
    { name: 'dmwappushservice', desc: 'WAP Push' },
    { name: 'SysMain', desc: 'Superfetch' },
    { name: 'WSearch', desc: 'Indexador de Busca' },
    { name: 'wuauserv', desc: 'Windows Update' },
    { name: 'DoSvc', desc: 'Delivery Optimization' },
    { name: 'Spooler', desc: 'Impressora' },
    { name: 'Fax', desc: 'Fax' },
    { name: 'RemoteRegistry', desc: 'Registro Remoto' },
    { name: 'WerSvc', desc: 'Relatorio de Erros' },
  ];
  return `
    <div class="fade-in">
      <div class="page-header">
        <h1 class="page-title">Servicos</h1>
        <p class="page-subtitle">50+ servicos desabilitados</p>
        <div class="page-divider"></div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">Servicos Desabilitados</div>
          <span class="toggle-badge badge-info">${services.length} servicos</span>
        </div>
        ${services.map(s => `
          <div class="service-item">
            <span class="service-name">${s.name}</span>
            <span class="service-desc">${s.desc}</span>
            <span class="service-status">Desabilitado</span>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

function renderBenchmark(): string {
  return `
    <div class="fade-in">
      <div class="page-header">
        <h1 class="page-title">Benchmark</h1>
        <p class="page-subtitle">Compare performance antes e depois</p>
        <div class="page-divider"></div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">Benchmark do Sistema</div>
        </div>
        <div class="terminal" id="bench-output">Clique em Executar para comecar...</div>
      </div>
      <div class="card">
        <button class="btn btn-primary" id="btn-run-bench">${Icons.zap} Executar Benchmark</button>
      </div>
    </div>
  `;
}

function renderRestore(): string {
  return `
    <div class="fade-in">
      <div class="page-header">
        <h1 class="page-title">Restaurar</h1>
        <p class="page-subtitle">Restaure configuracoes padrao do Windows</p>
        <div class="page-divider"></div>
      </div>
      <div class="card">
        <div class="card-header">
          <div class="card-title">Restaurar Configuracoes</div>
        </div>
        <p class="text-sm text-muted mb-4">Reverte todas as otimizacoes aplicadas pelo YokaiOS.</p>
        <button class="btn btn-danger" id="btn-restore">${Icons.restore} Restaurar Tudo</button>
      </div>
    </div>
  `;
}

// ==================== EVENTS ====================
function bindEvents() {
  // Navigation - instant, no lag
  document.querySelectorAll('.nav-item').forEach(el => {
    el.addEventListener('click', (e) => {
      const page = (e.currentTarget as HTMLElement).dataset.page;
      if (page && page !== currentPage) {
        currentPage = page;
        const content = document.getElementById('content');
        if (content) {
          content.innerHTML = renderPage(page);
          bindPageEvents();
        }
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        (e.currentTarget as HTMLElement).classList.add('active');
      }
    });
  });

  // Titlebar
  document.getElementById('btn-min')?.addEventListener('click', () => invoke('minimize_window'));
  document.getElementById('btn-max')?.addEventListener('click', () => invoke('maximize_window'));
  document.getElementById('btn-close')?.addEventListener('click', () => invoke('close_window'));

  bindPageEvents();
}

function bindPageEvents() {
  // Toggles
  document.querySelectorAll('.toggle-item').forEach(el => {
    el.addEventListener('click', () => {
      const toggle = el.querySelector('.toggle');
      toggle?.classList.toggle('checked');
    });
  });

  // Action buttons
  document.getElementById('btn-apply-all')?.addEventListener('click', () => applyAction('apply_all'));
  document.getElementById('btn-apply-gaming')?.addEventListener('click', () => applyAction('apply_gaming_optimizations'));
  document.getElementById('btn-apply-performance')?.addEventListener('click', () => applyAction('apply_performance_optimizations'));
  document.getElementById('btn-apply-privacy')?.addEventListener('click', () => applyAction('apply_privacy_optimizations'));
  document.getElementById('btn-apply-debloat')?.addEventListener('click', () => applyAction('apply_debloat'));
  document.getElementById('btn-apply-network')?.addEventListener('click', () => applyAction('apply_network_optimizations'));
  document.getElementById('btn-restore')?.addEventListener('click', () => applyAction('restore_defaults'));
  document.getElementById('btn-go-bench')?.addEventListener('click', () => { currentPage = 'benchmark'; renderApp(); });
  document.getElementById('btn-run-bench')?.addEventListener('click', runBenchmark);
}

// ==================== API ====================
async function loadSystemInfo() {
  try { systemInfo = await invoke('get_system_info'); } catch (e) { console.error(e); }
}

async function loadSystemStats() {
  try {
    systemStats = await invoke('get_system_stats');
    if (currentPage === 'dashboard') {
      const content = document.getElementById('content');
      if (content) content.innerHTML = renderDashboard();
      bindPageEvents();
    }
  } catch (e) { console.error(e); }
}

async function applyAction(action: string) {
  if (confirm('Aplicar otimizacoes?')) {
    try {
      if (action === 'apply_all') {
        await invoke('apply_gaming_optimizations');
        await invoke('apply_performance_optimizations');
        await invoke('apply_privacy_optimizations');
        await invoke('apply_network_optimizations');
      } else {
        await invoke(action);
      }
      alert('Otimizacoes aplicadas! Reinicie o computador.');
    } catch (e) { alert('Erro: ' + e); }
  }
}

async function runBenchmark() {
  const output = document.getElementById('bench-output');
  if (!output) return;
  output.innerHTML = '<span class="terminal-accent">=== YOKAIOS BENCHMARK ===</span>\n\nColetando metricas...';
  try {
    const s = await invoke<SystemStats>('get_system_stats');
    output.innerHTML += `\n<span class="terminal-success">[CPU]</span> Uso: ${s.cpu_usage.toFixed(1)}%`;
    output.innerHTML += `\n<span class="terminal-success">[RAM]</span> Uso: ${s.ram_used.toFixed(1)} GB / ${s.ram_total.toFixed(1)} GB`;
    output.innerHTML += `\n<span class="terminal-success">[PROC]</span> Processos: ${s.process_count}`;
    output.innerHTML += `\n<span class="terminal-success">[SVC]</span> Desabilitados: ${s.disabled_services}`;
    output.innerHTML += `\n\n<span class="terminal-accent">=== CONCLUIDO ===</span>`;
  } catch (e) { output.innerHTML += `\n<span style="color:var(--danger)">Erro: ${e}</span>`; }
}

// ==================== START ====================
init();