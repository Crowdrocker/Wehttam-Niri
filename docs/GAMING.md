# WehttamSnaps Gaming Guide

A comprehensive guide to gaming on the WehttamSnaps Niri setup, optimized for the AMD Radeon RX 580 and Arch Linux.

## Table of Contents

- [Hardware Overview](#hardware-overview)
- [Driver Setup](#driver-setup)
- [Gaming Optimizations](#gaming-optimizations)
- [Steam & Proton](#steam--proton)
- [GameMode Integration](#gamemode-integration)
- [MO2 Modding](#mo2-modding)
- [Troubleshooting](#troubleshooting)

## Hardware Overview

This setup is optimized for the following hardware configuration:

| Component | Specification |
|-----------|--------------|
| CPU | Intel Core i7-4790 (8 threads) @ 4.00 GHz |
| GPU | AMD Radeon RX 580 Series |
| RAM | 16GB DDR3 |
| Display | 1920x1080 @ 60Hz |
| Storage | 1TB SSD + 2x 120GB SSD |

The RX 580 is an excellent card for 1080p gaming on Linux, with mature AMDGPU drivers that offer excellent performance and stability.

## Driver Setup

### AMDGPU Driver

The RX 580 uses the AMDGPU driver which is built into the Linux kernel. The necessary packages are:

```bash
sudo pacman -S mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon
```

### Environment Variables

The Niri configuration automatically sets these AMD-optimized environment variables:

```bash
# AMD Performance Tuning
export RADV_PERFTEST="nocache,gt"
export mesa_glthread=true

# Vulkan Configuration
export AMD_VULKAN_ICD=RADV
export vk_icd_filenames=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json:/usr/share/vulkan/icd.d/radeon_icd.i686.json
```

### Verifying Driver Installation

Check that your GPU is properly recognized:

```bash
# Check OpenGL
glxinfo | grep "OpenGL renderer"

# Check Vulkan
vulkaninfo | grep "deviceName"
```

You should see your AMD Radeon RX 580 listed.

## Gaming Optimizations

### GameMode

GameMode optimizes your system for gaming by temporarily adjusting system settings:

```bash
# Install GameMode
sudo pacman -S gamemode lib32-gamemode

# Enable GameMode for a specific game
gamemoderun %command%

# Or use our toggle script
~/.config/wehttamsnaps/scripts/toggle-gamemode.sh on
```

### MangoHud

MangoHud provides an in-game overlay for performance monitoring:

```bash
# Install MangoHud
sudo pacman -S mangohud lib32-mangohud

# Run with MangoHud
mangohud %command%
```

Configuration file: `~/.config/MangoHud/MangoHud.conf`

```ini
# Basic MangoHud config
fps_limit=60
vsync=1
gpu_stats=1
cpu_stats=1
ram_stats=1
frame_timing=1
```

### Gamescope

Gamescope provides a nested gaming compositor ideal for games:

```bash
# Install Gamescope
sudo pacman -S gamescope

# Run with Gamescope
gamescope -w 1920 -h 1080 -f -- %command%
```

### GOverlay

GOverlay provides a GUI for configuring MangoHud and gamescope:

```bash
# Install GOverlay
sudo pacman -S goverlay
```

## Steam & Proton

### Installing Steam

```bash
sudo pacman -S steam
```

### Proton Configuration

For Windows games, Steam's Proton compatibility layer is essential:

1. Enable Proton for all titles: Steam > Settings > Steam Play > Enable Steam Play for all other titles
2. Use Proton-GE for better compatibility

### Installing Proton-GE

```bash
# Install ProtonUp-Qt (GUI for managing Proton versions)
sudo pacman -S protonup-qt

# Or install manually
yay -S proton-ge-custom-bin
```

### Recommended Proton Versions

| Game Type | Recommended Proton |
|-----------|-------------------|
| New AAA Games | Proton-GE (latest) |
| Older Games | Proton 8.x |
| Anti-Cheat Games | Proton Experimental |
| Bethesda Games | Proton-GE with MO2 |

### Steam Launch Options

For optimal performance on RX 580:

```bash
# Standard gaming
PROTON_ENABLE_NVAPI=1 %command%

# With MangoHud
mangohud PROTON_ENABLE_NVAPI=1 %command%

# With GameMode
gamemoderun mangohud PROTON_ENABLE_NVAPI=1 %command%

# Full optimization stack
DXVK_STATE_CACHE_PATH=~/.cache/dxvk-cache gamemoderun mangohud %command%
```

## GameMode Integration

### Toggle Script

The WehttamSnaps setup includes a GameMode toggle script:

```bash
# Toggle gaming mode
~/.config/wehttamsnaps/scripts/toggle-gamemode.sh toggle

# Enable gaming mode
~/.config/wehttamsnaps/scripts/toggle-gamemode.sh on

# Disable gaming mode
~/.config/wehttamsnaps/scripts/toggle-gamemode.sh off

# Check status
~/.config/wehttamsnaps/scripts/toggle-gamemode.sh status
```

### Keyboard Shortcut

Press `Mod+G` (Super+G) to toggle GameMode from within Niri.

### What GameMode Does

When enabled, GameMode:

- Sets CPU governor to `performance`
- Activates the GameMode daemon for CPU/core parking optimization
- Switches JARVIS voice to iDroid (gaming persona)
- Configures optimal AMDGPU settings
- Increases process priority for games

## MO2 Modding

### Mod Organizer 2 on Linux

MO2 is essential for modding Bethesda games (Skyrim, Fallout). The WehttamSnaps MO2 Linux Helper provides a streamlined setup.

### MO2 Installation

```bash
# Install dependencies
sudo pacman -S wine winetricks protontricks

# Clone MO2 setup (from AUR or manual)
yay -S modorganizer2

# Or use the MO2 Linux Helper
~/.config/wehttamsnaps/mo2-helper/mo2-helper
```

### MO2 Linux Helper

The MO2 Linux Helper is a Tauri-based application that:

- Manages MO2 installations
- Configures Proton prefixes
- Handles mod downloads and installations
- Provides game-specific presets

### Supported Games

| Game | Proton Version | MO2 Compatible |
|------|---------------|----------------|
| Skyrim SE | Proton-GE | ✅ |
| Skyrim AE | Proton-GE | ✅ |
| Fallout 4 | Proton-GE | ✅ |
| Fallout NV | Proton-GE | ✅ |
| Oblivion | Proton-GE | ✅ |

### MO2 Launch Options

For Steam games with MO2:

```bash
# Steam launch option
PROTON_USE_WINED3D=0 PROTON_NO_ESYNC=1 PROTON_NO_FSYNC=1 \
WINE_FULLSCREEN_FSR=1 WINE_FULLSCREEN_FSR_STRENGTH=2 \
~/.steam/steam/steamapps/common/Proton*/proton run ~/.config/mo2/skyrim/MO2/MO2.exe
```

## Troubleshooting

### Game Won't Start

1. Check Proton version in Steam
2. Try Proton-GE instead of default Proton
3. Check for missing dependencies:

```bash
# Verify 32-bit libraries
ldd ~/.steam/steam/steamapps/common/Proton*/dist/lib/wine/*/wine | grep "not found"
```

### Poor Performance

1. Enable GameMode
2. Check CPU governor:

```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

3. Verify AMDGPU is loaded:

```bash
dmesg | grep -i amdgpu
```

### Screen Tearing

1. Enable VSync in game settings
2. Use gamescope with vsync:

```bash
gamescope --vsync 1 %command%
```

### Gamescope Issues

If gamescope doesn't work:

```bash
# Check Vulkan support
vulkaninfo

# Verify gamescope is working
gamescope --help
```

### Wine/Proton Issues

1. Clear Proton prefix:

```bash
rm -rf ~/.steam/steam/steamapps/compatdata/<game-id>/pfx
```

2. Verify Wine installation:

```bash
wine --version
winetricks --version
```

### DXVK Cache Issues

```bash
# Clear DXVK cache
rm -rf ~/.cache/dxvk-cache/*

# Set cache path
export DXVK_STATE_CACHE_PATH=~/.cache/dxvk-cache
```

## Performance Tips

### RX 580 Specific Tips

1. **Enable FreeSync** if your monitor supports it
2. **Use FSR** for games that support it
3. **Set texture quality to High** - the RX 580 has 8GB VRAM
4. **Avoid MSAA** - use FXAA or TAA instead

### Recommended Settings for 1080p

| Setting | Recommendation |
|---------|---------------|
| Resolution | 1920x1080 (native) |
| VSync | Adaptive or Off (with FreeSync) |
| Anti-Aliasing | TAA or FXAA |
| Texture Quality | High/Ultra |
| Shadow Quality | Medium/High |
| Post-Processing | Medium |

## Useful Commands

```bash
# Check GPU usage
radeontop

# Check GPU temperatures
sensors

# Monitor GPU performance
watch -n 1 'cat /sys/class/drm/card*/device/gpu_busy_percent'

# List Vulkan devices
vulkaninfo --summary

# Test Vulkan
vkcube

# Check DirectX support
dxvk-info
```

## Additional Resources

- [ProtonDB](https://www.protondb.com/) - Game compatibility reports
- [GamingOnLinux](https://www.gamingonlinux.com/) - Linux gaming news
- [Steam Deck Gaming](https://steamcommunity.com/groups/steamdeck) - Steam gaming community
- [Lutris](https://lutris.net/) - Game installer scripts
- [Wine AppDB](https://appdb.winehq.org/) - Wine compatibility database