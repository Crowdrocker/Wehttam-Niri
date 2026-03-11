# Gaming Configuration - WehttamSnaps-SwayFx

Complete guide for gaming on your WehttamSnaps workstation with AMD RX 580 optimizations.

## Gaming Mode Overview

WehttamSnaps-SwayFx includes an integrated Gaming Mode that:

- Switches voice assistant from J.A.R.V.I.S. to iDroid
- Disables SwayFx effects (blur, shadows) for maximum performance
- Sets CPU governor to "performance"
- Enables GameMode optimizations
- Routes audio through gaming-optimized sinks

Toggle Gaming Mode: `Super + Shift + G`

## AMD RX 580 Optimizations

### Mesa Configuration

The AMD RX 580 works best with the RADV Vulkan driver. Set these environment variables:

```bash
# Add to ~/.config/sway/config.d/env or /etc/environment
export RADV_PERFTEST=gpl,nosam        # Enable GPL (good for older GPUs)
export mesa_glthread=true              # Enable OpenGL threading
export AMD_VULKAN_ICD=RADV             # Use RADV instead of AMDVLK
```

### Vulkan Drivers

```bash
# Install Vulkan drivers
sudo pacman -S vulkan-radeon lib32-vulkan-radeon

# Verify Vulkan support
vulkaninfo | head -20
```

### ROCm for Compute (Optional)

For compute workloads (some AI tools, compute shaders):

```bash
sudo pacman -S rocm-opencl-runtime opencl-mesa
```

## Gaming Tools

### Steam

```bash
sudo pacman -S steam
```

**Proton Configuration:**
1. Steam → Settings → Steam Play
2. Enable "Enable Steam Play for supported titles"
3. Enable "Enable Steam Play for all other titles"
4. Set Proton version to Proton-GE (see below)

### Proton GE (Recommended)

```bash
# Install ProtonUp-Qt
sudo pacman -S protonup-qt

# Or use protonup CLI
paru -S protonup
protonup --download 8.26  # Latest GE-Proton
```

Proton GE includes:
- Latest DXVK and VKD3D
- Better game compatibility
- Video codec support
- Fixes for specific games

### Lutris

```bash
sudo pacman -S lutris wine

# Additional Wine dependencies
sudo pacman -S --needed \
  wine-gecko wine-mono \
  winetricks \
  giflib lib32-giflib \
  libpng lib32-libpng \
  libldap lib32-libldap \
  gnutls lib32-gnutls \
  mpg123 lib32-mpg123 \
  openal lib32-openal \
  v4l-utils lib32-v4l-utils \
  libpulse lib32-libpulse \
  libgpg-error lib32-libgpg-error \
  alsa-plugins lib32-alsa-plugins \
  alsa-lib lib32-alsa-lib \
  libjpeg-turbo lib32-libjpeg-turbo \
  sqlite lib32-sqlite \
  libxcomposite lib32-libxcomposite \
  libxinerama lib32-libxinerama
```

### Heroic Games Launcher

For Epic Games Store and GOG:

```bash
paru -S heroic-games-launcher-bin
```

### Gamescope

Gamescope provides a nested compositor ideal for gaming:

```bash
sudo pacman -S gamescope
```

**Benefits:**
- Isolated gaming environment
- Better frame pacing
- VRR support
- HDR support (experimental)
- Resolution scaling

**Usage:**
```bash
# Launch game in fullscreen gamescope
gamescope -f -- %command%

# With specific resolution
gamescope -w 1920 -h 1080 -f -- %command%

# With FPS limit
gamescope -r 60 -- %command%
```

### MangoHud

Performance overlay for games:

```bash
sudo pacman -S mangohud lib32-mangohud
```

**Configuration: `~/.config/MangoHud/MangoHud.conf`**

```ini
# Performance settings
fps_limit=60
vsync=0
gl_vsync=0

# Display settings
fps
frame_timing
cpu_stats
gpu_stats
cpu_temp
gpu_temp
ram
vram

# Style
font_size=18
background_alpha=0.3
position=top-left
```

**Usage:**
```bash
# Run any game with MangoHud
mangohud ./game

# In Steam launch options
mangohud %command%
```

### GameMode

System-wide gaming optimizations:

```bash
sudo pacman -S gamemode lib32-gamemode

# Enable service
systemctl --user enable --now gamemoded

# Check status
gamemoded -s
```

**Configuration: `~/.config/gamemode.ini`**

```ini
[general]
renice = 10
ioprio = 0

[gpu]
apply_gpu_optimisations = accept-responsibility
gpu_device = 0
amd_performance_level = high

[cpu]
park_cores = no
pin_cores = no

[supervisor]
supervisor = systemd

[custom]
start = notify-send "GameMode" "Started"
end = notify-send "GameMode" "Ended"
```

**Usage:**
```bash
# Run game with GameMode
gamemoderun ./game

# In Steam launch options
gamemoderun %command%
```

## Recommended Launch Options

### Steam Games

For best performance on RX 580:

```
gamemoderun gamescope -w 1920 -h 1080 -f -r 60 -- mangohud %command%
```

**Breakdown:**
- `gamemoderun` - Enables GameMode
- `gamescope` - Isolated compositor
- `-w 1920 -h 1080` - Target resolution
- `-f` - Fullscreen
- `-r 60` - FPS limit
- `mangohud` - Performance overlay

### For Different Game Types

**Competitive/Esports (CS2, Valorant via Wine):**
```
gamescope -f -r 144 -- mangohud %command%
```

**Single-player (Cyberpunk, Witcher 3):**
```
gamescope -f -r 60 -- mangohud %command%
```

**Older games (Skyrim, Fallout):**
```
DXVK_STATE_CACHE_PATH=~/.cache/dxvk %command%
```

## Wine/Proton Tips

### DXVK

DXVK translates DirectX 9/10/11 to Vulkan:

```bash
# Install DXVK
sudo pacman -S dxvk lib32-dxvk

# Set up in Wine prefix
WINEPREFIX=~/.wine setup_dxvk install
```

### VKD3D

VKD3D translates DirectX 12 to Vulkan:

```bash
sudo pacman -S vkd3d lib32-vkd3d
```

### Wine Prefix Management

```bash
# Create 64-bit prefix
WINEARCH=win64 WINEPREFIX=~/.wine-64 winecfg

# Create 32-bit prefix (older games)
WINEARCH=win32 WINEPREFIX=~/.wine-32 winecfg
```

## Modding with MO2

### MO2 Linux Helper

Use the included MO2 Linux Helper (Tauri app) for managing Mod Organizer 2:

```bash
# Launch MO2 Helper
~/.config/sway/scripts/mo2-helper
```

Features:
- NXM link handling
- Wine prefix management
- Instance management
- Load order backup

### Manual MO2 Setup

```bash
# Install via Lutris (recommended)
# Lutris → Search "Mod Organizer 2" → Install

# Or use Proton
# Steam → Add Non-Steam Game → Select MO2 executable
# Force Proton in compatibility settings
```

### NXM Link Handler

```bash
# Register NXM protocol
xdg-mime default mo2-handler.desktop x-scheme-handler/nxm

# Test
xdg-open "nxm://skyrimspecialedition/mods/1/files/1"
```

## Game-Specific Tips

### Cyberpunk 2077

```bash
# Steam launch options
PROTON_USE_WINED3D=0 %command%

# In-game settings for RX 580
# Resolution: 1920x1080
# Preset: Medium
# FSR: Quality
# Crowd Density: Medium
```

### The Witcher 3

```bash
# Steam launch options
DXVK_HUD=fps %command%

# Enable FSR for better performance
# Mods: W3EE, HD Reworked
```

### Skyrim Special Edition

```bash
# Steam launch options
PROTON_NO_ESYNC=1 PROTON_NO_FSYNC=1 %command%

# Use MO2 for modding
# SKSE required for most mods
```

### Elden Ring

```bash
# Steam launch options
STEAM_COMPAT_DATA_PATH=~/.proton/elden_ring %command%

# Disable EasyAntiCheat for modding
# Use Seamless Co-op mod for multiplayer
```

## Streaming Games

### OBS Game Capture

```bash
# Install OBS
sudo pacman -S obs-studio

# For Wayland, use PipeWire capture
# OBS → Sources → PipeWire → Select game
```

### Audio Setup

Use the included audio-setup.sh to create virtual sinks:

```bash
~/.config/sway/scripts/audio-setup.sh
```

This creates:
- `game-audio` - Game sound sink
- `browser-audio` - Browser/music sink
- `mic-passthrough` - Microphone routing

Configure OBS to capture `game-audio` monitor.

## Troubleshooting

### Game Won't Start

```bash
# Check Proton logs
PROTON_LOG=1 %command% 2>&1 | tee game.log

# Try different Proton version
# Steam → Properties → Compatibility → Force specific Proton
```

### Poor Performance

1. **Verify GameMode running:**
   ```bash
   gamemoded -s
   ```

2. **Check GPU performance level:**
   ```bash
   cat /sys/class/drm/card0/device/power_dpm_force_performance_level
   echo high | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level
   ```

3. **Disable effects:**
   Gaming Mode disables SwayFx effects automatically, or:
   ```bash
   ~/.config/sway/scripts/toggle-gamemode.sh on
   ```

### Screen Tearing

```bash
# Add to Sway config
output * adaptive_sync on

# Or use gamescope
gamescope -- %command%
```

### Audio Issues in Games

```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse

# Check Wine audio
WINEPREFIX=~/.wine winecfg
# Audio tab → Select correct device
```

## Resources

- [ProtonDB](https://www.protondb.com/) - Game compatibility reports
- [Arch Wiki Gaming](https://wiki.archlinux.org/title/Gaming)
- [GloriousEggroll Proton](https://github.com/GloriousEggroll/proton-ge-custom)
- [AUR Gaming Packages](https://aur.archlinux.org/packages/?K=gaming)