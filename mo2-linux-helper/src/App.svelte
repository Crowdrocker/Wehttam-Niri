<script>
  import { invoke } from '@tauri-apps/api/tauri';
  import { onMount } from 'svelte';

  // State
  let mo2Installed = false;
  let mo2Path = '';
  let games = [];
  let selectedGame = null;
  let loading = true;
  let error = null;
  let success = null;

  // Catppuccin Mocha Colors (for inline styles)
  const colors = {
    base: '#1e1e2e',
    mantle: '#181825',
    crust: '#11111b',
    text: '#cdd6f4',
    subtext: '#a6adc8',
    surface0: '#313244',
    surface1: '#45475a',
    blue: '#89b4fa',
    mauve: '#cba6f7',
    green: '#a6e3a1',
    red: '#f38ba8',
    yellow: '#f9e2af',
    peach: '#fab387'
  };

  // On mount, load data
  onMount(async () => {
    try {
      mo2Path = await invoke('get_mo2_path');
      mo2Installed = await invoke('is_mo2_installed');
      games = await invoke('get_supported_games');
      
      // Check which games are installed
      // TODO: Implement game detection
      
      loading = false;
    } catch (e) {
      error = e;
      loading = false;
    }
  });

  // Launch MO2 for selected game
  async function launchGame(game) {
    selectedGame = game;
    error = null;
    success = null;
    
    try {
      const result = await invoke('launch_mo2', { gameName: game.name });
      success = result;
    } catch (e) {
      error = e;
    }
  }

  // Install MO2
  async function installMO2() {
    error = null;
    success = null;
    
    try {
      const result = await invoke('install_mo2', { installPath: mo2Path });
      success = result;
      mo2Installed = await invoke('is_mo2_installed');
    } catch (e) {
      error = e;
    }
  }

  // Configure NXM handler
  async function setupNXM() {
    error = null;
    success = null;
    
    try {
      const result = await invoke('configure_nxm_handler');
      success = result;
    } catch (e) {
      error = e;
    }
  }

  // Clear notifications
  function clearNotifications() {
    error = null;
    success = null;
  }
</script>

<main style="background: {colors.base}; color: {colors.text}; min-height: 100vh; padding: 20px;">
  <!-- Header -->
  <header style="text-align: center; margin-bottom: 30px;">
    <h1 style="font-size: 2rem; margin-bottom: 5px;">
      <span style="color: {colors.blue};">MO2</span> 
      <span style="color: {colors.mauve};">Linux Helper</span>
    </h1>
    <p style="color: {colors.subtext};">Mod Organizer 2 Manager for WehttamSnaps</p>
  </header>

  <!-- Loading State -->
  {#if loading}
    <div style="text-align: center; padding: 50px;">
      <p style="color: {colors.subtext};">Loading...</p>
    </div>
  {:else}
    <!-- Notifications -->
    {#if error}
      <div style="background: {colors.surface0}; border-left: 4px solid {colors.red}; padding: 15px; margin-bottom: 20px; border-radius: 8px;">
        <p style="color: {colors.red}; margin: 0;">Error: {error}</p>
        <button on:click={clearNotifications} style="background: none; border: none; color: {colors.subtext}; cursor: pointer; margin-top: 10px;">Dismiss</button>
      </div>
    {/if}

    {#if success}
      <div style="background: {colors.surface0}; border-left: 4px solid {colors.green}; padding: 15px; margin-bottom: 20px; border-radius: 8px;">
        <p style="color: {colors.green}; margin: 0;">{success}</p>
        <button on:click={clearNotifications} style="background: none; border: none; color: {colors.subtext}; cursor: pointer; margin-top: 10px;">Dismiss</button>
      </div>
    {/if}

    <!-- MO2 Status -->
    <section style="background: {colors.mantle}; border-radius: 12px; padding: 20px; margin-bottom: 20px;">
      <h2 style="margin-top: 0; color: {colors.text};">Installation Status</h2>
      <div style="display: flex; align-items: center; gap: 15px;">
        <div style="width: 12px; height: 12px; border-radius: 50%; background: {mo2Installed ? colors.green : colors.red};"></div>
        <span style="color: {mo2Installed ? colors.green : colors.red};">
          MO2 {mo2Installed ? 'Installed' : 'Not Installed'}
        </span>
      </div>
      <p style="color: {colors.subtext}; font-size: 0.9rem;">Path: {mo2Path}</p>
      
      {#if !mo2Installed}
        <button 
          on:click={installMO2}
          style="background: linear-gradient(135deg, {colors.blue}, {colors.mauve}); border: none; color: white; padding: 12px 24px; border-radius: 8px; cursor: pointer; margin-top: 15px; font-weight: bold;"
        >
          Install MO2
        </button>
      {:else}
        <button 
          on:click={setupNXM}
          style="background: {colors.surface0}; border: 1px solid {colors.blue}; color: {colors.blue}; padding: 12px 24px; border-radius: 8px; cursor: pointer; margin-top: 15px;"
        >
          Configure NXM Handler
        </button>
      {/if}
    </section>

    <!-- Games Section -->
    <section style="background: {colors.mantle}; border-radius: 12px; padding: 20px;">
      <h2 style="margin-top: 0; color: {colors.text};">Supported Games</h2>
      <p style="color: {colors.subtext}; margin-bottom: 20px;">Select a game to launch with MO2</p>
      
      <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 15px;">
        {#each games as game}
          <div 
            style="background: {colors.surface0}; border-radius: 8px; padding: 15px; border: 1px solid {colors.surface1}; transition: border-color 0.2s;"
            on:mouseover={(e) => e.currentTarget.style.borderColor = colors.blue}
            on:mouseout={(e) => e.currentTarget.style.borderColor = colors.surface1}
          >
            <h3 style="margin: 0 0 10px 0; color: {colors.text}; font-size: 1rem;">{game.name}</h3>
            <p style="color: {colors.subtext}; font-size: 0.8rem; margin: 0 0 10px 0;">App ID: {game.app_id}</p>
            <button 
              on:click={() => launchGame(game)}
              disabled={!mo2Installed}
              style="background: {mo2Installed ? colors.blue : colors.surface1}; border: none; color: {mo2Installed ? 'white' : colors.subtext}; padding: 8px 16px; border-radius: 6px; cursor: {mo2Installed ? 'pointer' : 'not-allowed'}; width: 100%;"
            >
              {mo2Installed ? 'Launch MO2' : 'Install MO2 First'}
            </button>
          </div>
        {/each}
      </div>
    </section>

    <!-- Info Footer -->
    <footer style="margin-top: 30px; text-align: center;">
      <p style="color: {colors.subtext}; font-size: 0.8rem;">
        Part of <span style="color: {colors.mauve};">WehttamSnaps</span> Photography & Gaming Setup
      </p>
      <p style="color: {colors.surface1}; font-size: 0.7rem;">
        Requires Proton/Proton-GE and Wine for modding
      </p>
    </footer>
  {/if}
</main>

<style>
  :global(body) {
    margin: 0;
    padding: 0;
    font-family: 'JetBrains Mono', 'Fira Code', monospace;
  }
  
  :global(*) {
    box-sizing: border-box;
  }
  
  button:hover:not(:disabled) {
    opacity: 0.9;
    transform: translateY(-1px);
  }
  
  button:active:not(:disabled) {
    transform: translateY(0);
  }
</style>