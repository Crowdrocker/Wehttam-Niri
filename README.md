# 🎮 WehttamSnaps — Arch Linux Niri Setup

<div align="center">

![WehttamSnaps](https://img.shields.io/badge/WehttamSnaps-Arch%20Linux%20Setup-89b4fa?style=for-the-badge)
![Niri](https://img.shields.io/badge/Niri-Wayland%20Compositor-cba6f7?style=for-the-badge)
![JARVIS](https://img.shields.io/badge/J.A.R.V.I.S.-Sound%20System-f9e2af?style=for-the-badge)

**Photography • Gaming • Content Creation**

*"WehttamSnaps" = Matthew spelled backwards*

</div>

---

## 📋 Overview

A modular, brandable Niri configuration optimized for **photography, content creation, streaming, and gaming** on a budget build. This setup transforms your Arch Linux desktop into a personalized workstation with J.A.R.V.I.S. voice integration, cyberpunk aesthetics, and gaming optimizations.

### 🖥️ Target Hardware
| Component | Specification |
|-----------|---------------|
| CPU | Intel Core i7-4790 (8) @ 4.00 GHz |
| GPU | AMD Radeon RX 580 Series |
| RAM | 16GB DDR3 |
| Display | 1920x1080 @ 60Hz |
| Storage | 1TB SSD + 2x 120GB SSD |

---

## ✨ Features

### 🤖 J.A.R.V.I.S. Integration
- **Adaptive Sound System**: Auto-switches between J.A.R.V.I.S. (Paul Bettany) and iDroid voices
- **Context-aware responses**: Different sounds for gaming vs. work
- **37+ voice responses**: Startup, shutdown, notifications, workspace switches
- **Natural language commands**: "open firefox", "gaming mode", "screenshot"

### 🎮 Gaming Optimizations
- Pre-configured for **16+ games** including Cyberpunk 2077, Fallout 4, Division 2
- **Mesa tweaks**: RADV_PERFTEST, mesa_glthread enabled
- **GameMode integration**: Automatic performance mode
- **Proton GE**: Latest version via ProtonUp-Qt
- **MO2 Linux Helper**: Mod Organizer 2 setup tool (Tauri app)

### 📸 Photography Workflow
- **Darktable**: RAW processing
- **GIMP**: Advanced editing
- **Krita**: Digital painting
- **DigiKam**: Photo management
- Complete export pipeline ready

### 🎨 Cyberpunk Aesthetics
- **Catppuccin Mocha** color scheme
- **Gradient borders** on windows
- **Neon accent colors**: Cyan (#00ffd1), Magenta (#f5af1), Blue (#3b82ff)
- **Scanline effects** and industrial theme elements

---

## 📁 Repository Structure

```
wehttamsnaps-niri/
├── README.md                    # This file
├── install.sh                   # Master installer
├── logo.txt                     # ASCII art logo
│
├── configs/
│   ├── niri/
│   │   ├── config.kdl           # Main config entry
│   │   └── conf.d/              # Modular configs
│   │       ├── 00-base.kdl      # Environment, input, layout
│   │       ├── 10-keybinds.kdl  # Keyboard shortcuts
│   │       ├── 20-window-rules.kdl
│   │       ├── 30-workspaces.kdl
│   │       ├── 40-startup.kdl
│   │       └── 50-animations.kdl
│   │
│   ├── noctalia-shell/          # Quickshell bar config
│   │   └── widgets/             # Custom widgets
│   │
│   ├── scripts/                 # Utility scripts
│   ├── sounds/                  # JARVIS/iDroid sounds
│   └── webapps/                 # Web app launchers
│
├── docs/
│   ├── INSTALL.md               # Detailed installation
│   ├── QUICKSTART.md            # First boot guide
│   ├── GAMING.md                # Gaming setup guide
│   ├── AUDIO-ROUTING.md         # PipeWire audio guide
│   └── TROUBLESHOOTING.md       # Common issues
│
├── wallpapers/                  # Curated wallpapers
├── themes/                      # GTK/Kvantum themes
└── packages/
    └── package.list.txt         # Required packages
```

---

## 🚀 Quick Install

```bash
# Clone the repository
git clone https://github.com/Crowdrocker/wehttamsnaps-niri.git
cd wehttamsnaps-niri

# Run the installer
chmod +x install.sh
./install.sh
```

---

## ⌨️ Essential Keybindings

| Key | Action |
|-----|--------|
| `Mod + Space` | Application Launcher |
| `Mod + Enter` | Terminal (Ghostty) |
| `Mod + B` | Browser (Firefox) |
| `Mod + E` | File Manager (Thunar) |
| `Mod + H` | KeyHints Cheat Sheet |
| `Mod + G` | Toggle Gaming Mode |
| `Mod + 1-0` | Switch Workspaces |
| `Mod + Q` | Close Window |
| `Mod + Shift + F` | Fullscreen |

---

## 🗂️ Workspace Layout

| # | Name | Purpose |
|---|------|---------|
| 1 | Browser | Firefox, web browsing |
| 2 | Terminal | Development, Ghostty |
| 3 | Gaming | Steam, games |
| 4 | Streaming | OBS Studio |
| 5 | Photography | GIMP, Darktable, Krita |
| 6 | Media | Video editing |
| 7 | Communication | Discord, social |
| 8 | Music | Spotify, audio |
| 9 | Files | Thunar, file management |
| 10 | Misc | Overflow workspace |

---

## 🔊 Sound System

### J.A.R.V.I.S. (Professional Mode)
Used for photography and desktop work:
- `startup.mp3` - "Allow me to introduce myself..."
- `shutdown.mp3` - "Shutting down. Have a good day, Matthew."
- `notification.mp3` - "Sir, you have a notification"
- `workspace-switch.mp3` - Workspace change confirmation
- `screenshot.mp3` - "Screenshot captured"

### iDroid (Gaming Mode)
Used during gaming sessions:
- `gamemode-on.mp3` - "Combat systems online"
- `steam-launch.mp3` - "Game launching"
- `alert-high.mp3` - "Alert! High priority"
- `mission-start.mp3` - "Mission start"

---

## 🔗 Links

- **GitHub**: [github.com/Crowdrocker](https://github.com/Crowdrocker)
- **Twitch**: [twitch.tv/WehttamSnaps](https://twitch.tv/WehttamSnaps)
- **YouTube**: [@WehttamSnaps](https://youtube.com/@WehttamSnaps)

---

## 📜 License

MIT License - Feel free to use and modify for your own setup!

---

<div align="center">

**Made with ❤️ by WehttamSnaps**

*"The future is now"*

</div>