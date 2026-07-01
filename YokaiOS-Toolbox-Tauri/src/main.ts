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
  disk: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="3"/><line x1="12" y1="2" x2="12" y2="6"/><line x1="12" y1="18" x2="12" y2="22"/><line x1="2" y1="12" x2="6" y2="12"/><line x1="18" y1="12" x2="22" y2="12"/></svg>`,
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
let isApplying = false;
let isoConfig = {
  iso_source: 'download',
  iso_path: '',
  remove_edge: true,
  remove_onedrive: true,
  remove_copilot: true,
  remove_bloatware: true,
  remove_widgets: true,
  remove_xbox: false,
  disable_defender: true,
  disable_updates: true,
  apply_gaming: true,
  apply_privacy: true,
  bypass_requirements: true,
  username: 'User',
  password: '',
  output_path: 'C:\\YokaiOS\\ISOs\\YokaiOS-v2.0.iso',
  flash_to_usb: false,
  usb_drive: '',
};

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
    { id: 'createiso', icon: Icons.disk, label: 'Create ISO' },
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
    createiso: renderCreateISO,
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
          <div class="stat-change">${s ? (s.ram_used / s.ram_total * 100).toFixed(0) + '%' : '...'} uso</div>
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
          <div class="stat-value">${s?.disabled_services ?? '...'}</div>
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
          <button class="btn btn-secondary" id="btn-go-createiso">${Icons.disk} Criar ISO</button>
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

function renderCreateISO(): string {
  return `
    <div class="fade-in">
      <div class="page-header">
        <h1 class="page-title">Create ISO</h1>
        <p class="page-subtitle">Crie uma ISO do Windows 11 ja otimizada com YokaiOS</p>
        <div class="page-divider"></div>
      </div>

      <div class="card">
        <div class="card-header">
          <div>
            <div class="card-title">Passo 1: ISO do Windows</div>
            <div class="card-subtitle">Selecione a origem da ISO do Windows 11</div>
          </div>
          <span class="toggle-badge badge-info">1/4</span>
        </div>
        <div class="iso-source-group">
          <label class="iso-radio-item ${isoConfig.iso_source === 'download' ? 'active' : ''}">
            <input type="radio" name="iso_source" value="download" ${isoConfig.iso_source === 'download' ? 'checked' : ''}>
            <div class="iso-radio-content">
              <div class="iso-radio-title">Baixar ISO automaticamente</div>
              <div class="iso-radio-desc">Baixa a ISO oficial do Windows 11 da Microsoft</div>
            </div>
          </label>
          <label class="iso-radio-item ${isoConfig.iso_source === 'local' ? 'active' : ''}">
            <input type="radio" name="iso_source" value="local" ${isoConfig.iso_source === 'local' ? 'checked' : ''}>
            <div class="iso-radio-content">
              <div class="iso-radio-title">Usar ISO existente</div>
              <div class="iso-radio-desc">Selecione uma ISO ja baixada no seu computador</div>
            </div>
          </label>
        </div>
        <div id="iso-path-section" style="display:${isoConfig.iso_source === 'local' ? 'block' : 'none'}; margin-top: 12px;">
          <div class="iso-file-picker">
            <input type="text" class="iso-input" id="iso-path" placeholder="C:\\Users\\...\\Win11.iso" value="${isoConfig.iso_path}" readonly>
            <button class="btn btn-secondary" id="btn-browse-iso">Selecionar</button>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-header">
          <div>
            <div class="card-title">Passo 2: Configuracoes</div>
            <div class="card-subtitle">Escolha o que remover e aplicar na ISO</div>
          </div>
          <span class="toggle-badge badge-info">2/4</span>
        </div>
        <div class="iso-options-grid">
          ${[
            { key: 'remove_edge', title: 'Remover Microsoft Edge', desc: 'Remove o navegador Edge da imagem' },
            { key: 'remove_onedrive', title: 'Remover OneDrive', desc: 'Remove o cloud storage da Microsoft' },
            { key: 'remove_copilot', title: 'Remover Copilot e IA', desc: 'Remove assistente de IA e Recall' },
            { key: 'remove_bloatware', title: 'Remover Bloatware', desc: 'Remove 30+ apps pre-instalados' },
            { key: 'remove_widgets', title: 'Remover Widgets', desc: 'Remove painel de widgets' },
            { key: 'remove_xbox', title: 'Remover Xbox Apps', desc: 'Remove apps Xbox (mantem Game Bar)' },
            { key: 'disable_defender', title: 'Desabilitar Defender', desc: 'Desabilita Windows Defender na imagem' },
            { key: 'disable_updates', title: 'Desabilitar Updates', desc: 'Desabilita atualizacoes automaticas' },
            { key: 'apply_gaming', title: 'Aplicar Gaming Tweaks', desc: 'GPU, CPU, MMCS, Timer Resolution' },
            { key: 'apply_privacy', title: 'Aplicar Privacidade', desc: 'Telemetria, Tracking, Advertising' },
            { key: 'bypass_requirements', title: 'Bypass Requisitos Win11', desc: 'TPM 2.0, Secure Boot, RAM, CPU' },
          ].map(t => `
            <div class="toggle-item iso-toggle" data-config="${t.key}">
              <div class="toggle ${isoConfig[t.key as keyof typeof isoConfig] ? 'checked' : ''}">${Icons.check}</div>
              <div class="toggle-content">
                <div class="toggle-title">${t.title}</div>
                <div class="toggle-desc">${t.desc}</div>
              </div>
            </div>
          `).join('')}
        </div>
      </div>

      <div class="card">
        <div class="card-header">
          <div>
            <div class="card-title">Passo 3: Usuario</div>
            <div class="card-subtitle">Configure o usuario padrao da instalacao</div>
          </div>
          <span class="toggle-badge badge-info">3/4</span>
        </div>
        <div class="iso-user-form">
          <div class="iso-form-group">
            <label class="iso-label">Nome de Usuario</label>
            <input type="text" class="iso-input" id="iso-username" placeholder="User" value="${isoConfig.username}">
          </div>
          <div class="iso-form-group">
            <label class="iso-label">Senha (opcional)</label>
            <input type="password" class="iso-input" id="iso-password" placeholder="Deixe vazio sem senha" value="${isoConfig.password}">
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-header">
          <div>
            <div class="card-title">Passo 4: Saida</div>
            <div class="card-subtitle">Escolha onde salvar ou gravar a ISO</div>
          </div>
          <span class="toggle-badge badge-info">4/4</span>
        </div>
        <div class="iso-output-section">
          <div class="iso-form-group">
            <label class="iso-label">Caminho da ISO</label>
            <div class="iso-file-picker">
              <input type="text" class="iso-input" id="iso-output" value="${isoConfig.output_path}" readonly>
              <button class="btn btn-secondary" id="btn-browse-output">Salvar como</button>
            </div>
          </div>
          <div class="iso-divider"></div>
          <div class="toggle-item iso-toggle-usb" data-config="flash_to_usb">
            <div class="toggle ${isoConfig.flash_to_usb ? 'checked' : ''}">${Icons.check}</div>
            <div class="toggle-content">
              <div class="toggle-title">Gravar direto em USB</div>
              <div class="toggle-desc">Apos criar a ISO, grava automaticamente em um pendrive USB</div>
            </div>
          </div>
          <div id="usb-section" style="display:${isoConfig.flash_to_usb ? 'block' : 'none'}; margin-top: 12px;">
            <div class="iso-form-group">
              <label class="iso-label">Drive USB</label>
              <select class="iso-select" id="iso-usb-drive">
                <option value="">Selecione um USB...</option>
              </select>
            </div>
            <button class="btn btn-secondary" id="btn-refresh-usb" style="margin-top:8px;">Atualizar lista de USBs</button>
          </div>
        </div>
      </div>

      <div class="card">
        <button class="btn btn-primary btn-lg" id="btn-create-iso">${Icons.rocket} Criar ISO YokaiOS</button>
      </div>

      <div class="card" id="iso-progress-card" style="display:none;">
        <div class="card-header">
          <div class="card-title">Progresso</div>
          <span class="toggle-badge badge-info" id="iso-step-badge">0/8</span>
        </div>
        <div class="iso-progress-bar-container">
          <div class="iso-progress-bar" id="iso-progress-bar" style="width: 0%"></div>
        </div>
        <div class="iso-progress-message" id="iso-progress-message">Aguardando inicio...</div>
        <div class="terminal iso-log" id="iso-log"></div>
      </div>
    </div>
  `;
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
          <div class="toggle-item tweak-toggle" data-tweak="${t.id}">
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
    { name: 'DPS', desc: 'Diagnostic Policy Service' },
    { name: 'PcaSvc', desc: 'Program Compatibility Assistant' },
    { name: 'seclogon', desc: 'Secondary Logon' },
    { name: 'SSDPSRV', desc: 'SSDP Discovery' },
    { name: 'RetailDemo', desc: 'Retail Demo Service' },
    { name: 'WalletService', desc: 'Wallet Service' },
    { name: 'MapsBroker', desc: 'Downloaded Maps Manager' },
    { name: 'iphlpsvc', desc: 'IP Helper' },
    { name: 'XblAuthManager', desc: 'Xbox Live Auth Manager' },
    { name: 'XblGameSave', desc: 'Xbox Live Game Save' },
    { name: 'XboxNetApiSvc', desc: 'Xbox Live Networking' },
    { name: 'XboxGipSvc', desc: 'Xbox Accessory Management' },
    { name: 'lfsvc', desc: 'Geolocation Service' },
    { name: 'WbioSrvc', desc: 'Windows Biometric Service' },
    { name: 'WpcMonSvc', desc: 'Parental Controls' },
    { name: 'UCPD', desc: 'UserChoice Protection Driver' },
    { name: 'wisvc', desc: 'Windows Insider Service' },
    { name: 'WdiServiceHost', desc: 'Diagnostic Service Host' },
    { name: 'WdiSystemHost', desc: 'Diagnostic System Host' },
    { name: 'Wecsvc', desc: 'Windows Event Collector' },
  ];
  return `
    <div class="fade-in">
      <div class="page-header">
        <h1 class="page-title">Servicos</h1>
        <p class="page-subtitle">${services.length}+ servicos desabilitados pelo YokaiOS</p>
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
        <p class="page-subtitle">Metricas reais do sistema em tempo real</p>
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
  // Navigation
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
  // Generic tweak toggles (gaming, performance, etc) - NOT ISO toggles
  document.querySelectorAll('.tweak-toggle').forEach(el => {
    el.addEventListener('click', () => {
      const toggle = el.querySelector('.toggle');
      toggle?.classList.toggle('checked');
    });
  });

  // ISO Config Toggles - separate handler, no double-fire
  document.querySelectorAll('.iso-toggle').forEach(el => {
    el.addEventListener('click', (e) => {
      e.stopPropagation();
      const configKey = (el as HTMLElement).dataset.config as keyof typeof isoConfig;
      if (configKey) {
        (isoConfig as any)[configKey] = !(isoConfig as any)[configKey];
        const toggle = el.querySelector('.toggle');
        toggle?.classList.toggle('checked');
      }
    });
  });

  // USB Toggle
  document.querySelectorAll('.iso-toggle-usb').forEach(el => {
    el.addEventListener('click', (e) => {
      e.stopPropagation();
      isoConfig.flash_to_usb = !isoConfig.flash_to_usb;
      const toggle = el.querySelector('.toggle');
      toggle?.classList.toggle('checked');
      const usbSection = document.getElementById('usb-section');
      if (usbSection) usbSection.style.display = isoConfig.flash_to_usb ? 'block' : 'none';
      if (isoConfig.flash_to_usb) loadUSBDrives();
    });
  });

  // ISO Source Radio
  document.querySelectorAll('input[name="iso_source"]').forEach(el => {
    el.addEventListener('change', (e) => {
      isoConfig.iso_source = (e.target as HTMLInputElement).value;
      const pathSection = document.getElementById('iso-path-section');
      if (pathSection) pathSection.style.display = isoConfig.iso_source === 'local' ? 'block' : 'none';
      document.querySelectorAll('.iso-radio-item').forEach(item => item.classList.remove('active'));
      (e.target as HTMLElement).closest('.iso-radio-item')?.classList.add('active');
    });
  });

  // Browse ISO button - opens file dialog via PowerShell
  document.getElementById('btn-browse-iso')?.addEventListener('click', async () => {
    try {
      const path = await invoke<string>('open_file_dialog', { filter: 'ISO Files (*.iso)|*.iso|All Files (*.*)|*.*' });
      if (path) {
        isoConfig.iso_path = path;
        const input = document.getElementById('iso-path') as HTMLInputElement;
        if (input) input.value = path;
      }
    } catch (e) {
      // Fallback: prompt
      const path = prompt('Caminho da ISO do Windows 11:', isoConfig.iso_path);
      if (path) {
        isoConfig.iso_path = path;
        const input = document.getElementById('iso-path') as HTMLInputElement;
        if (input) input.value = path;
      }
    }
  });

  // Browse Output button
  document.getElementById('btn-browse-output')?.addEventListener('click', async () => {
    try {
      const path = await invoke<string>('save_file_dialog', { filter: 'ISO Files (*.iso)|*.iso', default_name: 'YokaiOS-v2.0.iso' });
      if (path) {
        isoConfig.output_path = path.endsWith('.iso') ? path : path + '.iso';
        const input = document.getElementById('iso-output') as HTMLInputElement;
        if (input) input.value = isoConfig.output_path;
      }
    } catch (e) {
      const path = prompt('Caminho para salvar a ISO:', isoConfig.output_path);
      if (path) {
        isoConfig.output_path = path.endsWith('.iso') ? path : path + '.iso';
        const input = document.getElementById('iso-output') as HTMLInputElement;
        if (input) input.value = isoConfig.output_path;
      }
    }
  });

  // Refresh USB drives
  document.getElementById('btn-refresh-usb')?.addEventListener('click', loadUSBDrives);

  // Create ISO button
  document.getElementById('btn-create-iso')?.addEventListener('click', startISOCreation);

  // Action buttons
  document.getElementById('btn-apply-all')?.addEventListener('click', () => applyAction('apply_all'));
  document.getElementById('btn-apply-gaming')?.addEventListener('click', () => applyAction('apply_gaming_optimizations'));
  document.getElementById('btn-apply-performance')?.addEventListener('click', () => applyAction('apply_performance_optimizations'));
  document.getElementById('btn-apply-privacy')?.addEventListener('click', () => applyAction('apply_privacy_optimizations'));
  document.getElementById('btn-apply-debloat')?.addEventListener('click', () => applyAction('apply_debloat'));
  document.getElementById('btn-apply-network')?.addEventListener('click', () => applyAction('apply_network_optimizations'));
  document.getElementById('btn-restore')?.addEventListener('click', () => applyAction('restore_defaults'));
  document.getElementById('btn-go-bench')?.addEventListener('click', () => { currentPage = 'benchmark'; renderApp(); });
  document.getElementById('btn-go-createiso')?.addEventListener('click', () => { currentPage = 'createiso'; renderApp(); });
  document.getElementById('btn-run-bench')?.addEventListener('click', runBenchmark);
}

// ==================== API ====================
async function loadSystemInfo() {
  try { systemInfo = await invoke('get_system_info'); } catch (e) { console.error(e); }
}

async function loadSystemStats() {
  try {
    systemStats = await invoke('get_system_stats');
    // Only update stat values, don't re-render entire page (avoids flicker)
    if (currentPage === 'dashboard') {
      const statValues = document.querySelectorAll('.stat-value');
      if (statValues.length >= 4 && systemStats) {
        statValues[0].textContent = String(systemStats.process_count);
        statValues[1].textContent = systemStats.ram_used.toFixed(1) + ' GB';
        statValues[2].textContent = systemStats.cpu_usage.toFixed(0) + '%';
        statValues[3].textContent = String(systemStats.disabled_services);
      }
      const statChanges = document.querySelectorAll('.stat-change');
      if (statChanges.length >= 2 && systemStats) {
        statChanges[1].textContent = (systemStats.ram_used / systemStats.ram_total * 100).toFixed(0) + '% uso';
      }
    }
  } catch (e) { console.error(e); }
}

async function loadUSBDrives() {
  try {
    const drivesJson = await invoke<string>('get_usb_drives');
    const select = document.getElementById('iso-usb-drive') as HTMLSelectElement;
    if (!select) return;
    select.innerHTML = '<option value="">Selecione um USB...</option>';
    try {
      const drives = JSON.parse(drivesJson[0] || '[]');
      const driveList = Array.isArray(drives) ? drives : [drives];
      for (const d of driveList) {
        if (d && d.Number !== undefined) {
          const opt = document.createElement('option');
          opt.value = String(d.Number);
          opt.textContent = `Disco ${d.Number} - ${d.FriendlyName || 'USB'} (${d.SizeGB || '?'} GB)`;
          select.appendChild(opt);
        }
      }
    } catch { /* no USB found */ }
  } catch (e) { console.error('Erro ao listar USBs:', e); }
}

async function applyAction(action: string) {
  if (isApplying) return;
  if (!confirm('Aplicar otimizacoes?')) return;

  isApplying = true;
  const btn = document.querySelector(`[id^="btn-apply"], [id="btn-restore"]`) as HTMLButtonElement;
  if (btn) { btn.disabled = true; btn.textContent = 'Aplicando...'; }

  try {
    if (action === 'apply_all') {
      await invoke('apply_gaming_optimizations');
      await invoke('apply_performance_optimizations');
      await invoke('apply_privacy_optimizations');
      await invoke('apply_network_optimizations');
    } else {
      await invoke(action);
    }
    alert('Otimizacoes aplicadas com sucesso! Reinicie o computador.');
  } catch (e) { alert('Erro: ' + e); }
  finally {
    isApplying = false;
    if (btn) { btn.disabled = false; btn.textContent = 'Aplicar'; }
  }
}

async function runBenchmark() {
  const output = document.getElementById('bench-output');
  const btn = document.getElementById('btn-run-bench') as HTMLButtonElement;
  if (!output) return;

  if (btn) { btn.disabled = true; btn.textContent = 'Executando...'; }
  output.innerHTML = '<span class="terminal-accent">=== YOKAIOS BENCHMARK ===</span>\n\nColetando metricas...\n';

  try {
    // Collect multiple samples for CPU accuracy
    const samples: Array<{cpu: number, ram: number, proc: number}> = [];
    for (let i = 0; i < 3; i++) {
      const s = await invoke<SystemStats>('get_system_stats');
      samples.push({ cpu: s.cpu_usage, ram: s.ram_used, proc: s.process_count });
      if (i < 2) await new Promise(r => setTimeout(r, 1000));
    }

    const avgCpu = samples.reduce((a, b) => a + b.cpu, 0) / samples.length;
    const avgRam = samples[1].ram; // Use middle sample
    const procCount = samples[2].proc;

    output.innerHTML += `<span class="terminal-success">[CPU]</span> Uso: ${avgCpu.toFixed(1)}% (media de 3 amostras)`;
    output.innerHTML += `\n<span class="terminal-success">[RAM]</span> Uso: ${avgRam.toFixed(2)} GB`;

    // Get network latency
    try {
      const latency = await invoke<string>('run_powershell', { command: `(Test-Connection -ComputerName 1.1.1.1 -Count 4 | Measure-Object -Property Latency -Average).Average` });
      const lat = parseFloat(latency.trim());
      if (!isNaN(lat)) {
        output.innerHTML += `\n<span class="terminal-success">[PING]</span> Latencia: ${lat.toFixed(0)}ms (Cloudflare)`;
      }
    } catch { output.innerHTML += `\n<span class="terminal-success">[PING]</span> N/A`; }

    // Disk free space
    try {
      const diskJson = await invoke<string>('run_powershell', { command: `Get-PSDrive C | Select-Object @{N='FreeGB';E={[math]::Round($_.Free/1GB,1)}}, @{N='UsedGB';E={[math]::Round($_.Used/1GB,1)}} | ConvertTo-Json` });
      const disk = JSON.parse(diskJson.trim());
      output.innerHTML += `\n<span class="terminal-success">[DISK]</span> C: ${disk.FreeGB} GB livre / ${disk.UsedGB} GB usado`;
    } catch { output.innerHTML += `\n<span class="terminal-success">[DISK]</span> N/A`; }

    // Services count
    try {
      const svcCount = await invoke<string>('run_powershell', { command: `(Get-Service | Where-Object {$_.StartType -eq 'Disabled'}).Count` });
      output.innerHTML += `\n<span class="terminal-success">[SVC]</span> ${svcCount.trim()} servicos desabilitados`;
    } catch { /* skip */ }

    // Process count
    output.innerHTML += `\n<span class="terminal-success">[PROC]</span> ${procCount} processos ativos`;

    // Uptime
    try {
      const uptime = await invoke<string>('run_powershell', { command: `(Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToString('yyyy-MM-dd HH:mm:ss')` });
      output.innerHTML += `\n<span class="terminal-success">[UPTIME]</span> Ultimo boot: ${uptime.trim()}`;
    } catch { /* skip */ }

    output.innerHTML += `\n\n<span class="terminal-accent">=== CONCLUIDO ===</span>`;
  } catch (e) {
    output.innerHTML += `\n<span style="color:var(--danger)">Erro: ${e}</span>`;
  } finally {
    if (btn) { btn.disabled = false; btn.textContent = `${Icons.zap} Executar Benchmark`; }
  }
}

async function startISOCreation() {
  if (isApplying) return;

  // Verifica admin
  try {
    const isAdmin = await invoke<boolean>('check_admin');
    if (!isAdmin) {
      if (confirm('Criar ISO precisa de privilegios de Administrador.\n\nDeseja reabrir como Administrador?')) {
        await invoke('request_elevation');
        alert('A Toolbox sera reaberta como Administrador.\nFeche esta janela e use a nova.');
      }
      return;
    }
  } catch (e) { console.error(e); }

  // Collect config from form
  const usernameEl = document.getElementById('iso-username') as HTMLInputElement;
  const passwordEl = document.getElementById('iso-password') as HTMLInputElement;
  const outputEl = document.getElementById('iso-output') as HTMLInputElement;
  const isoPathEl = document.getElementById('iso-path') as HTMLInputElement;
  const usbDriveEl = document.getElementById('iso-usb-drive') as HTMLSelectElement;

  if (usernameEl) isoConfig.username = usernameEl.value;
  if (passwordEl) isoConfig.password = passwordEl.value;
  if (outputEl) isoConfig.output_path = outputEl.value;
  if (isoPathEl) isoConfig.iso_path = isoPathEl.value;
  if (usbDriveEl) isoConfig.usb_drive = usbDriveEl.value;

  if (isoConfig.iso_source === 'local' && !isoConfig.iso_path) {
    alert('Selecione uma ISO do Windows 11');
    return;
  }

  if (!confirm('Criar ISO YokaiOS? Isso pode levar varios minutos.')) return;

  isApplying = true;
  const createBtn = document.getElementById('btn-create-iso') as HTMLButtonElement;
  if (createBtn) { createBtn.disabled = true; createBtn.textContent = 'Criando...'; }

  const progressCard = document.getElementById('iso-progress-card');
  if (progressCard) progressCard.style.display = 'block';
  const progressBar = document.getElementById('iso-progress-bar');
  const progressMsg = document.getElementById('iso-progress-message');
  const progressLog = document.getElementById('iso-log');
  const stepBadge = document.getElementById('iso-step-badge');

  function updateProgress(step: number, total: number, msg: string, pct: number, status: string) {
    if (progressBar) progressBar.style.width = `${pct}%`;
    if (progressMsg) progressMsg.textContent = msg;
    if (stepBadge) stepBadge.textContent = `${step}/${total}`;
    if (progressLog) {
      const color = status === 'completed' ? 'var(--success)' : status === 'error' ? 'var(--danger)' : 'var(--accent)';
      progressLog.innerHTML += `\n<span style="color:${color}">[${step}/${total}] ${msg}</span>`;
      progressLog.scrollTop = progressLog.scrollHeight;
    }
  }

  const workDir = 'C:\\YokaiOS\\ISO_Work';
  const wimMountDir = 'C:\\YokaiOS\\WIM_Mount';

  // Limpa residuos de execucoes anteriores
  try { await invoke('cleanup_iso_work'); } catch {}

  try {
    let isoPath = isoConfig.iso_path;
    if (isoConfig.iso_source === 'download') {
      updateProgress(1, 8, 'Baixando ISO do Windows 11 (pode levar 10-30 min)...', 5, 'downloading');
      isoPath = await invoke<string>('download_windows_iso', { outputPath: 'C:\\YokaiOS\\ISOs\\Win11-source.iso' });
      updateProgress(1, 8, 'Download concluido!', 15, 'downloaded');
    }

    updateProgress(2, 8, 'Extraindo conteúdo da ISO...', 18, 'extracting');
    await invoke('extract_iso', { isoPath, workDir });
    updateProgress(2, 8, 'ISO extraída com sucesso!', 25, 'extracted');

    updateProgress(3, 8, 'Montando imagem Windows (install.wim)...', 28, 'mounting');
    await invoke('mount_wim', { isoWorkDir: workDir, wimMountDir });
    updateProgress(3, 8, 'Imagem montada!', 32, 'mounted');

    updateProgress(4, 8, 'Injetando YokaiOS Playbook...', 35, 'injecting');
    const injectResult = await invoke<string>('inject_playbook', { wimMountDir, isoWorkDir: workDir, config: isoConfig });
    updateProgress(7, 8, injectResult, 70, 'injected');

    updateProgress(7, 8, 'Salvando alterações na imagem...', 72, 'committing');
    await invoke('unmount_wim', { wimMountDir, commit: true });
    updateProgress(7, 8, 'Alterações salvas!', 75, 'committed');

    updateProgress(8, 8, 'Criando ISO bootável com oscdimg...', 80, 'building');
    const outputPath = await invoke<string>('build_iso', { isoWorkDir: workDir, outputPath: isoConfig.output_path });
    updateProgress(8, 8, `ISO criada: ${outputPath}`, 95, 'built');

    if (isoConfig.flash_to_usb && isoConfig.usb_drive) {
      updateProgress(8, 8, `Gravando no USB ${isoConfig.usb_drive}...`, 97, 'flashing');
      await invoke('flash_iso_to_usb', { isoPath: outputPath, usbDrive: isoConfig.usb_drive });
      updateProgress(8, 8, 'USB gravado com sucesso!', 100, 'completed');
    }

    // Cleanup final
    try { await invoke('cleanup_iso_work'); } catch {}

    updateProgress(8, 8, `ISO YokaiOS criada com sucesso! ${outputPath}`, 100, 'completed');
    alert(`ISO YokaiOS criada com sucesso!\n${outputPath}`);

  } catch (e) {
    // Cleanup completo em caso de erro
    try { await invoke('cleanup_iso_work'); } catch {}
    updateProgress(0, 8, `Erro: ${e}`, 0, 'error');
    alert(`Erro ao criar ISO: ${e}`);
  } finally {
    isApplying = false;
    if (createBtn) { createBtn.disabled = false; createBtn.textContent = `${Icons.rocket} Criar ISO YokaiOS`; }
  }
}

// ==================== START ====================
init();
