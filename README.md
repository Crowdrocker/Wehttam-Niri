<div align="center">

# 🎮 WehttamSnaps SwayFx Setup

### Arch Linux Workstation for Photography, Gaming & Content Creation

[![GitHub](https://img.shields.io/badge/GitHub-Crowdrocker-181717?logo=github)](https://github.com/Crowdrocker)
[![Twitch](https://img.shields.io/badge/Twitch-WehttamSnaps-9146FF?logo=twitch)](https://twitch.tv/WehttamSnaps)
[![YouTube](https://img.shields.io/badge/YouTube-@WehttamSnaps-FF0000?logo=youtube)](https://youtube.com/@WehttamSnaps)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

<img src="assets/wehttamsnaps-banner.png" alt="WehttamSnaps Banner" width="100%">

*"WehttamSnaps" = Matthew's name spelled backwards 🔄*

</div>

---

## 📋 Overview

This repository contains a complete, modular SwayFx configuration optimized for:
- **📸 Photography Workflow** - Darktable, GIMP, DigiKam, Krita
- **🎮 Gaming** - Steam, Proton, GameMode optimizations for AMD RX 580
- **📹 Content Creation** - OBS Studio, streaming, audio routing
- **🤖 J.A.R.V.I.S. Integration** - Voice feedback system with adaptive modes

Built on **Arch Linux** with **SwayFx** (Sway with effects) and **Noctalia Shell** for a cyberpunk-inspired aesthetic.

---

## ✨ Features

### 🤖 J.A.R.V.I.S. Sound System
Adaptive voice feedback that switches between:
- **J.A.R.V.I.S. (Paul Bettany)** - Professional mode for photography & work
- **iDroid Voice** - Tactical gaming mode with combat sounds

### 🎨 Cyberpunk Theme
Inspired by Night City aesthetics:
- Neon cyan (`#00ffd1`) & magenta (`#ff5af1`) accents
- Window blur, shadows, and rounded corners
- Dark industrial UI with scanline effects

### 🖥️ 10 Organized Workspaces
| # | Name | Purpose |
|---|------|---------|
| 1 | Browser | Firefox, Brave |
| 2 | Terminal | Development, Ghostty |
| 3 | Gaming | Steam, Games |
| 4 | Streaming | OBS Studio |
| 5 | Photography | GIMP, Darktable |
| 6 | Media | Video editing |
| 7 | Communication | Discord, Social |
| 8 | Music | Spotify, Audio |
| 9 | Files | Thunar, File Management |
| 10 | Misc | Overflow |

### ⚡ Performance Optimizations
- **GameMode** integration for CPU performance boost
- **Mesa tweaks** for AMD RX 580 (RADV_PERFTEST, mesa_glthread)
- **Gamescope** support for gaming
- **zram** configuration for memory optimization

### 📦 MO2 Linux Helper (Planned)
Tauri-based app for Mod Organizer 2 configuration:
- Automatic dependency installation
- NXM link handling
- Game-specific fixes (Cyberpunk 2077, Fallout 4, etc.)
- Flatpak & AUR packaging

---

## 🖥️ Hardware Profile

This setup is optimized for:

| Component | Specification |
|-----------|---------------|
| CPU | Intel Core i7-4790 (8) @ 4.00 GHz |
| GPU | AMD Radeon RX 580 Series |
| RAM | 16 GB DDR3 |
| Storage | 1TB SSD + 2x 120GB SSD |
| Display | 1920x1080 @ 60Hz |
| Platform | Dell XPS 8700 |

---

## 📁 Repository Structure

```
WehttamSnaps-SwayFx/
├── README.md                    # This file
├── install.sh                   # Main installation script
├── logo.txt                     # ASCII art logo
├── configs/
│   ├── swayfx/                  # SwayFx configuration
│   │   ├── config               # Main config entry point
│   │   ├── config.d/            # Modular config files
│   │   │   ├── theme            # Colors & visual settings
│   │   │   ├── output           # Display configuration
│   │   │   ├── input            # Keyboard, mouse, touchpad
│   │   │   ├── keybindings      # All keybindings
│   │   │   ├── workspaces       # Workspace definitions
│   │   │   ├── autostart        # Startup applications
│   │   │   ├── window-rules     # Float, assign, rules
│   │   │   └── swayfx           # SwayFX effects config
│   │   └── scripts/             # Helper scripts
│   │       ├── jarvis           # Voice assistant
│   │       ├── jarvis-menu      # Rofi menu interface
│   │       ├── jarvis-manager.sh
│   │       ├── sound-system     # Adaptive sound system
│   │       ├── KeyHints.sh      # Keybindings cheat sheet
│   │       ├── toggle-gamemode.sh
│   │       └── audio-setup.sh
│   ├── sounds/                  # Sound files
│   │   ├── jarvis/              # J.A.R.V.I.S. voice sounds
│   │   └── idroid/              # iDroid gaming sounds
│   └── webapps/                 # Webapp launcher scripts
│       ├── youtube.webapp
│       ├── twitch.webapp
│       ├── spotify.webapp
│       └── discord.webapp
│   ├── themes/                  # GTK/Kvantum themes
│   └── wallpapers/              # Wallpaper collection
├── docs/
│   ├── INSTALL.md               # Detailed installation guide
│   ├── QUICKSTART.md            # First boot guide
│   ├── KEYBINDS.md              # Complete keybinding reference
│   ├── GAMING.md                # Gaming setup & optimizations
│   ├── AUDIO-ROUTING.md         # PipeWire audio guide
│   ├── PHOTOGRAPHY.md           # Photo workflow guide
│   └── TROUBLESHOOTING.md       # Common issues & fixes
├── assets/                      # Images, logos, banners
└── mo2-linux-helper/            # MO2 Tauri app (planned)
```

---

## 🚀 Quick Install

```bash
# Clone the repository
git clone https://github.com/Crowdrocker/WehttamSnaps-SwayFx.git
cd WehttamSnaps-SwayFx

# Run the installer
chmod +x install.sh
./install.sh
```

See [INSTALL.md](docs/INSTALL.md) for detailed instructions.

---

## ⌨️ Essential Keybindings

| Key | Action |
|-----|--------|
| `Mod + Space` | Application Launcher |
| `Mod + Enter` | Terminal (Ghostty) |
| `Mod + H` | Keybindings Help |
| `Mod + B` | Browser (Firefox) |
| `Mod + E` | File Manager (Thunar) |
| `Mod + Q` | Close Window |
| `Mod + G` | Toggle Gaming Mode |
| `Mod + 1-0` | Switch Workspaces |
| `Mod + Shift + 1-0` | Move Window to Workspace |
| `Mod + Print` | Screenshot |
| `XF86Audio*` | Volume/Media Controls |

See [KEYBINDS.md](docs/KEYBINDS.md) for complete reference.

---

## 🎮 Gaming Setup

Pre-configured optimizations for AMD RX 580:

- **16 Games Optimized**: The Division 2, Cyberpunk 2077, Fallout 4, Watch Dogs series, and more
- **Proton GE**: Latest version via ProtonUp-Qt
- **GameMode**: Automatic CPU performance boost
- **Mesa Tweaks**: RADV_PERFTEST=gpl,nosam,ccswizzle

```bash
# Toggle gaming mode
Mod + Shift + G

# Launch Steam with optimizations
Mod + Alt + S
```

See [GAMING.md](docs/GAMING.md) for detailed gaming configuration.

---

## 📸 Photography Workflow

Professional photo editing pipeline:

1. **Import** → DigiKam (Photo management)
2. **Process** → Darktable (RAW development)
3. **Edit** → GIMP (Advanced editing)
4. **Touch-up** → Krita (Digital painting)
5. **Export** → Ready for social media

All configured in Workspace 5 with J.A.R.V.I.S. voice feedback.

---

## 🔊 Audio Routing

VoiceMeeter-like audio control with PipeWire:

- Separate channels for Game, Browser, Discord, Spotify
- Visual routing with qpwgraph
- OBS integration for streaming
- Virtual sinks for professional audio management

See [AUDIO-ROUTING.md](docs/AUDIO-ROUTING.md) for setup instructions.

---

## 🌐 Web Applications

Pre-configured webapp launchers for distraction-free browsing:

| Webapp | Keybinding | Description |
|--------|------------|-------------|
| YouTube | `Mod + Shift + Y` | Standalone YouTube window |
| Twitch | `Mod + Shift + T` | Standalone Twitch viewer |
| Spotify | `Mod + Shift + S` | Spotify Web Player |
| Discord | `Mod + Shift + D` | Discord Web Client |

Launch scripts are located in `configs/webapps/` and support:
- Chromium-based browsers (app mode)
- Firefox (window mode)
- Wayland native rendering
- Separate profiles for each webapp

---

## 🤖 J.A.R.V.I.S. Commands

Natural language voice commands:

```bash
# Applications
jarvis open firefox
jarvis launch steam
jarvis start spotify

# Window Management
jarvis close window
jarvis maximize
jarvis fullscreen

# Workspaces
jarvis go to workspace 2
jarvis switch to gaming

# System
jarvis screenshot
jarvis lock screen
jarvis gaming mode
jarvis status report

# Interactive mode
jarvis interactive
```

---

## 📦 Required Packages

### Core
- `swayfx` - Sway with effects
- `waybar` - Status bar
- `rofi` or `wofi` - Application launcher
- `ghostty` or `foot` - Terminal emulator
- `thunar` - File manager

### Audio
- `pipewire` - Audio server
- `pipewire-pulse` - PulseAudio compatibility
- `wireplumber` - Session manager
- `pavucontrol` - Volume control
- `qpwgraph` - Audio routing

### Gaming
- `gamemode` - Performance optimization
- `gamescope` - Gaming compositor
- `mangohud` - FPS overlay
- `protonup-qt` - Proton version manager

### Photography
- `darktable` - RAW processing
- `gimp` - Image editing
- `krita` - Digital painting
- `digikam` - Photo management

See [INSTALL.md](docs/INSTALL.md) for complete package list.

---

## 🎨 Color Palette

WehttamSnaps Cyberpunk Theme:

| Color | Hex | Usage |
|-------|-----|-------|
| Cyan | `#00ffd1` | Primary accent |
| Blue | `#3b82ff` | Secondary accent |
| Magenta | `#ff5af1` | Highlights |
| Dark Purple | `#1a1a3a` | Background |
| Black | `#0a0a1a` | Surface |

---

## 📜 License

MIT License - See [LICENSE](LICENSE) for details.

---

## 🙏 Credits

- **Author**: Matthew ([Crowdrocker](https://github.com/Crowdrocker))
- **J.A.R.V.I.S. Sounds**: [101Soundboards](https://www.101soundboards.com/)
- **Theme Inspiration**: Cyberpunk 2077, Tokyo Night
- **SwayFx**: [WillPower3309](https://github.com/WillPower3309/swayfx)

---

## 🔗 Links

- 📺 [Twitch](https://twitch.tv/WehttamSnaps)
- 🎬 [YouTube](https://youtube.com/@WehttamSnaps)
- 💻 [GitHub](https://github.com/Crowdrocker)
- 💬 [Discord](https://discord.gg/wehttamsnaps)

---

<div align="center">

**Made with 💜 by WehttamSnaps**

*"Allow me to introduce myself..."* - J.A.R.V.I.S.

</div>