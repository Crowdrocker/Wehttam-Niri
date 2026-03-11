# Installation Guide - WehttamSnaps-SwayFx

Complete installation guide for setting up your WehttamSnaps SwayFx workstation.

## Prerequisites

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 4 cores | 8+ cores |
| RAM | 8 GB | 16+ GB |
| GPU | Vulkan 1.0 | Vulkan 1.3+ (AMD recommended) |
| Storage | 50 GB | 100+ GB SSD |

### Tested Hardware

- **CPU:** Intel Core i7-4790 @ 3.60GHz
- **GPU:** AMD Radeon RX 580 8GB
- **RAM:** 16GB DDR3
- **Display:** 1920x1080 @ 60Hz

## Base Arch Linux Installation

This guide assumes you have a working Arch Linux installation. If not, follow the [Arch Wiki Installation Guide](https://wiki.archlinux.org/title/Installation_guide).

### 1. Enable Required Repositories

```bash
# Enable multilib for 32-bit games
sudo sed -i '/\[multilib\]/,/Include/ s/^#//' /etc/pacman.conf

# Update system
sudo pacman -Syu
```

### 2. Install Base Dependencies

```bash
sudo pacman -S --needed \
  base-devel git curl wget \
  pipewire pipewire-pulse pipewire-jack wireplumber \
  swayfx waybar rofi-wayland \
  foot thunar thunar-archive-plugin thunar-volman \
  gvfs gvfs-mtp gvfs-smb \
  polkit-gnome \
  brightnessctl \
  playerctl \
  slurp grim \
  wl-clipboard cliphist \
  mako \
  xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
  ttf-jetbrains-mono ttf-font-awesome noto-fonts noto-fonts-cjk noto-fonts-emoji \
  papirus-icon-theme adwaita-dark \
  grimblast
```

### 3. Install Display Manager (Optional)

For graphical login:

```bash
sudo pacman -S greetd greetd-tuigreet
sudo systemctl enable greetd
```

Or use manual start with `startx` / `sway` from TTY.

## Install WehttamSnaps-SwayFx

### Option A: Full Installation (Recommended)

```bash
# Clone the repository
cd ~/Downloads
git clone https://github.com/WehttamSnaps/WehttamSnaps-SwayFx.git
cd WehttamSnaps-SwayFx

# Run the installer
chmod +x install.sh
./install.sh
```

### Option B: Manual Installation

```bash
# Backup existing configs
mv ~/.config/sway ~/.config/sway.backup.$(date +%Y%m%d)
mv ~/.config/waybar ~/.config/waybar.backup.$(date +%Y%m%d)

# Clone and copy configs
git clone https://github.com/WehttamSnaps/WehttamSnaps-SwayFx.git
cp -r WehttamSnaps-SwayFx/configs/swayfx ~/.config/sway
cp -r WehttamSnaps-SwayFx/configs/waybar ~/.config/waybar

# Make scripts executable
chmod +x ~/.config/sway/scripts/*

# Create symlinks for configs
ln -sf ~/.config/sway/config ~/.config/sway/config
```

## Install Additional Software

### Photography Suite

```bash
sudo pacman -S --needed \
  darktable \
  gimp \
  digikam \
  krita \
  rawtherapee \
  shotwell
```

### Gaming Tools

```bash
sudo pacman -S --needed \
  steam \
  lutris \
  wine \
  mangohud \
  lib32-mangohud \
  gamescope \
  gamemode \
  lib32-gamemode \
  heroic-games-launcher-bin \
  protonup-qt \
  goverlay
```

### Streaming & Content Creation

```bash
sudo pacman -S --needed \
  obs-studio \
  obs-studio-browser \
  pipewire-jack \
  helvum \
  qpwgraph \
  easyeffects
```

### Audio Tools

```bash
sudo pacman -S --needed \
  pavucontrol \
  pulseeffects \
  spotify-launcher \
  mpv \
  playerctl
```

### Web Applications

For webapp launchers:

```bash
# Install Electron-based webapp creators
yay -S webapp-manager

# Or use native wayland webapps
yay -S webcord gitify
```

## AMD GPU Configuration

### Mesa Drivers

```bash
sudo pacman -S --needed \
  mesa \
  lib32-mesa \
  vulkan-radeon \
  lib32-vulkan-radeon \
  libva-mesa-driver \
  lib32-libva-mesa-driver \
  mesa-vdpau \
  lib32-mesa-vdpau \
  rocm-opencl-runtime \
  opencl-mesa
```

### Environment Variables

Add to `~/.config/sway/config.d/env` or `/etc/environment`:

```bash
# AMD Performance
export RADV_PERFTEST=gpl,nosam
export mesa_glthread=true
export AMD_VULKAN_ICD=RADV

# Gaming
export DXVK_STATE_CACHE_PATH=~/.cache/dxvk
export MANGOHUD=1
export MangoHudOutputFolder=~/.local/share/mangohud

# Wayland
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland-egl
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
```

## Post-Installation

### 1. Configure Sounds

```bash
# Download or create your J.A.R.V.I.S. and iDroid sounds
cd ~/.config/sway/sounds/jarvis
# Add your .wav files

cd ../idroid
# Add your .wav files
```

See [sounds documentation](../configs/sounds/README.md) for details.

### 2. Configure Noctalia Shell

```bash
# Install Noctalia if not included
git clone https://github.com/noctalia-team/noctalia-shell.git
cd noctalia-shell
./install.sh
```

### 3. Configure GameMode

```bash
# Enable gamemode service
systemctl --user enable gamemoded
systemctl --user start gamemoded

# Configure for your games
cp /usr/share/gamemode/gamemode.ini ~/.config/gamemode.ini
```

Example `~/.config/gamemode.ini`:

```ini
[general]
renice = 10

[gpu]
apply_gpu_optimisations = accept-responsibility
gpu_device = 0
amd_performance_level = high

[cpu]
park_cores = no
pin_cores = no
```

### 4. Configure Audio Routing

Run the audio setup script:

```bash
~/.config/sway/scripts/audio-setup.sh
```

Or manually configure with qpwgraph:

```bash
qpwgraph &
```

### 5. Set Up NXM Links (Modding)

```bash
# Configure NXM protocol handler for MO2
xdg-mime default mo2.desktop x-scheme-handler/nxm
```

## Verify Installation

### Check SwayFx Effects

```bash
# Start SwayFx
sway --unsupported-gpu

# Verify blur and shadows are working
# Check ~/.config/sway/config.d/swayfx
```

### Check PipeWire

```bash
# Status
systemctl --user status pipewire pipewire-pulse wireplumber

# List audio devices
pactl list sinks short
```

### Check Gaming Stack

```bash
# Vulkan support
vulkaninfo | grep -A5 "GPU"

# GameMode
gamemoded -s

# Gamescope
gamescope --help
```

## Troubleshooting

### SwayFx won't start

```bash
# Check logs
journalctl --user -b -u sway

# Try with debug
WLR_DEBUG=1 sway 2>&1 | tee sway-debug.log
```

### No sound

```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check devices
wpctl status
```

### Games have poor performance

1. Check GameMode is running: `gamemoded -s`
2. Verify Vulkan: `vulkaninfo`
3. Check MangoHud: `MANGOHUD=1 mangohud vkcube`
4. Try Gamescope: `gamescope -w 1920 -h 1080 %command%`

### Screen tearing

```bash
# Add to sway config
output * adaptive_sync on
```

## Next Steps

- [Quick Start Guide](./QUICKSTART.md)
- [Keybindings Reference](./KEYBINDS.md)
- [Gaming Configuration](./GAMING.md)
- [Audio Routing Guide](./AUDIO-ROUTING.md)

## Getting Help

- **Arch Wiki:** [Sway](https://wiki.archlinux.org/title/Sway)
- **Arch Wiki:** [Gaming](https://wiki.archlinux.org/title/Gaming)
- **Issues:** [GitHub Issues](https://github.com/WehttamSnaps/WehttamSnaps-SwayFx/issues)