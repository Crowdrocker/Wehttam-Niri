```
██╗    ██╗███████╗██╗  ██╗████████╗████████╗ █████╗ ███╗   ███╗
██║    ██║██╔════╝██║  ██║╚══██╔══╝╚══██╔══╝██╔══██╗████╗ ████║
██║ █╗ ██║█████╗  ███████║   ██║      ██║   ███████║██╔████╔██║
██║███╗██║██╔══╝  ██╔══██║   ██║      ██║   ██╔══██║██║╚██╔╝██║
╚███╔███╔╝███████╗██║  ██║   ██║      ██║   ██║  ██║██║ ╚═╝ ██║
 ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝
███████╗███╗   ██╗ █████╗ ██████╗ ███████╗
██╔════╝████╗  ██║██╔══██╗██╔══██╗██╔════╝
███████╗██╔██╗ ██║███████║██████╔╝███████╗
╚════██║██║╚██╗██║██╔══██║██╔═══╝ ╚════██║
███████║██║ ╚████║██║  ██║██║     ███████║
╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚══════╝
```

# WehttamSnaps — Arch Linux Niri Workstation

> **"WehttamSnaps"** is Matthew spelled backwards.  
> Photography · Gaming · Content Creation · Streaming

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Niri](https://img.shields.io/badge/Niri-Wayland-00ffd1?style=flat)](https://github.com/YaLTeR/niri)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-Crowdrocker-181717?style=flat&logo=github)](https://github.com/Crowdrocker)
[![Twitch](https://img.shields.io/badge/Twitch-WehttamSnaps-9146FF?style=flat&logo=twitch&logoColor=white)](https://twitch.tv/WehttamSnaps)
[![YouTube](https://img.shields.io/badge/YouTube-WehttamSnaps-FF0000?style=flat&logo=youtube&logoColor=white)](https://youtube.com/@WehttamSnaps)

---

A modular, fully-branded Arch Linux desktop built around the **Niri** Wayland compositor — optimised for wedding photography, PC gaming, content creation, and live streaming on a budget build. Comes with a J.A.R.V.I.S. + iDroid adaptive sound system, a cyberpunk Rofi theme, a gaming mode toggle, MO2 Linux Helper, and a one-command installer.

---

## Hardware

| Component | Spec |
|-----------|------|
| Machine | Dell XPS 8700 |
| CPU | Intel Core i7-4790 (8 threads @ 4.0 GHz) |
| GPU | AMD Radeon RX 580 8GB (Mesa RADV) |
| RAM | 16 GB DDR3 |
| Display | 1920×1080 @ 60 Hz (DP-2) |
| System SSD | 120 GB (boot / root) |
| Work SSD | 120 GB |
| Gaming SSD | 1 TB — `/run/media/wehttamsnaps/LINUXDRIVE` |

**Gaming drive layout:**
```
/run/media/wehttamsnaps/LINUXDRIVE/
├── SteamLibrary/
├── Modlist_Packs/
└── Modlist_Downloads/
```

---

## What's Inside

### Core Stack

| Component | Choice | Notes |
|-----------|--------|-------|
| Compositor | [Niri](https://github.com/YaLTeR/niri) | Scrollable-tiling Wayland |
| Shell / Bar | Noctalia-Shell (Quickshell) | Replaces Waybar |
| Terminal | Ghostty | `Super+Enter` |
| Launcher | Rofi-Wayland | WehttamSnaps cyberpunk theme |
| Browser | Brave | + webapp launchers |
| Notifications | Dunst | Cyberpunk styled |
| Wallpaper | swww | Fade transitions |
| Lock screen | swaylock | `#07050f` void black |
| File manager | Thunar + Dolphin | Thunar primary |
| Screenshots | grim + slurp | With JARVIS sound |
| Clipboard | wl-clipboard + cliphist | `Super+V` |
| Audio | PipeWire + WirePlumber | + qpwgraph routing |

### J.A.R.V.I.S. Sound System

Adaptive dual-voice system that switches automatically based on workspace and gaming mode state.

| Voice | Pack | Trigger |
|-------|------|---------|
| **J.A.R.V.I.S.** (Paul Bettany) | 55+ sounds | Desktop, photography, streaming |
| **iDroid** (Metal Gear) | 8 sounds | Gaming workspaces, combat mode |

Every keybind action plays a contextual voice line — startup greeting, workspace switches, window close, screenshot capture, lock screen, gaming mode toggle, and more.

Sound packs sourced from [101soundboards.com](https://www.101soundboards.com):
- J.A.R.V.I.S.: [board 10155](https://www.101soundboards.com/boards/10155-jarvis-v1-paul-bettany-tts-computer-ai-voice)
- iDroid: [board 10060](https://www.101soundboards.com/boards/10060-idroid-tts-computer-ai-voice)

### Gaming Mode

`Super+G` triggers a full performance profile switch:

- CPU governor → `performance` (all 8 cores)
- Niri animations → disabled via hot-reload
- AMD RX 580 power profile → `high`
- Mesa/RADV env tuned: `ACO`, `DXVK_ASYNC`, `mailbox`, `FSR`
- GameMode daemon → started
- Sound → switches to iDroid
- `Super+G` again restores everything

### Photography Workflow

Five-step pipeline across dedicated workspaces:

1. **Import** — DigiKam (workspace 5)
2. **Process** — Darktable RAW editing
3. **Edit** — GIMP advanced editing
4. **Touch-up** — Krita digital painting
5. **Export** — `Super+Shift+E` fires the export sound

### Webapp Launchers

| Keybind | Webapp | Brave Profile |
|---------|--------|---------------|
| `Super+Ctrl+Y` | YouTube | YouTube |
| `Super+Ctrl+T` | Twitch | Twitch |
| `Super+Ctrl+S` | Spotify | Spotify |
| `Super+Ctrl+D` | Discord | Discord |

---

## File Structure

```
wehttamsnaps/
├── README.md                        ← You are here
├── install.sh                       ← One-command installer
├── logo.txt                         ← ASCII art brand mark
├── LICENSE
│
├── configs/
│   ├── niri/
│   │   └── config.kdl               ← Full Niri compositor config
│   └── rofi/
│       ├── wehttamsnaps.rasi        ← Cyberpunk Rofi theme
│       └── config.rasi              ← Global Rofi config
│
├── scripts/
│   ├── jarvis                       ← JARVIS NLP command processor
│   ├── jarvis-menu                  ← JARVIS Rofi visual menu
│   ├── sound-system                 ← Adaptive JARVIS/iDroid dispatcher
│   ├── toggle-gamemode.sh           ← Full gaming mode toggle
│   ├── voice-engine.sh              ← Context-aware voice switcher
│   ├── voice-activation.sh          ← Vosk offline wake-word listener
│   ├── jarvis-ai.sh                 ← Gemini AI shell integration
│   ├── jarvis-ai-aliases.sh         ← Terminal aliases (wtf, game-fix, etc.)
│   ├── jarvis-manager.sh            ← Sound manager utility
│   ├── wehttamsnaps-keyhints.sh     ← Rofi keybind cheatsheet
│   ├── KeyHints.sh                  ← yad keybind GUI
│   ├── power-menu.sh                ← Rofi power menu
│   └── wallpaper-browser.sh         ← Rofi wallpaper picker
│
├── apps/
│   ├── wehttamsnaps-welcome.py      ← GTK welcome screen (Wall.jpg banner)
│   └── mo2-linux-helper.html        ← MO2 Linux Helper app UI
│
├── sounds/
│   ├── jarvis/                      ← J.A.R.V.I.S. sound pack (55+ mp3s)
│   │   └── README.md                ← Required filenames + phrases
│   └── idroid/                      ← iDroid sound pack (8 mp3s)
│       └── README.md
│
├── wallpapers/
│   └── Wall.jpg                     ← WehttamSnaps cyberpunk wallpaper
│
├── themes/
│   └── gtk/                         ← adw-gtk3-dark + Papirus-Dark
│
└── docs/
    ├── INSTALL.md                   ← Detailed step-by-step install guide
    ├── QUICKSTART.md                ← First boot cheatsheet
    └── SOUNDS.md                    ← Sound pack setup guide
```

---

## Quick Install

```bash
# 1. Clone the repo
git clone https://github.com/Crowdrocker/wehttamsnaps.git
cd wehttamsnaps

# 2. Run the installer
chmod +x install.sh
./install.sh

# 3. Download sound packs → see sounds/jarvis/README.md and sounds/idroid/README.md

# 4. Reload Niri
niri msg action reload-config

# 5. Source your shell
source ~/.bashrc
```

The installer handles everything: packages via `paru`, script deployment to `/usr/local/bin`, Niri + Rofi configs, dunst, GTK theme, shell aliases, systemd voice service, and sudoers rule for gaming mode.

> **Requires:** Arch Linux · paru (auto-installed if missing) · Niri already running

---

## Workspace Map

| # | Name | Auto-launched apps | Sound mode |
|---|------|--------------------|------------|
| 1 | Browser | Brave, Firefox | J.A.R.V.I.S. |
| 2 | Dev | Ghostty, Kate | J.A.R.V.I.S. |
| 3 | Gaming | Steam, Lutris, MO2 | **iDroid** |
| 4 | Streaming | OBS Studio | J.A.R.V.I.S. |
| 5 | Photo | Darktable, GIMP, DigiKam, Krita | J.A.R.V.I.S. |
| 6 | Media | Video editing | **iDroid** |
| 7 | Comms | Discord | **iDroid** |
| 8 | Audio | Spotify, qpwgraph | J.A.R.V.I.S. |
| 9 | Files | Thunar, Dolphin | J.A.R.V.I.S. |
| 10 | Misc | Overflow | J.A.R.V.I.S. |

Switch with `Super+1–0`. Move window with `Super+Shift+1–0`.

---

## Keybind Reference

Run `Super+H` at any time to open the full interactive cheatsheet.

### Essential

| Keybind | Action |
|---------|--------|
| `Super+Space` | App launcher (Rofi drun) |
| `Super+Enter` | Ghostty terminal |
| `Super+H` | Keybind cheatsheet |
| `Super+B` | Brave browser |
| `Super+F` | Thunar file manager |
| `Super+E` | Kate editor |
| `Super+Q` | Close window + sound |
| `Super+G` | Toggle gaming mode |
| `Super+J` | JARVIS interactive terminal |
| `Super+Alt+J` | JARVIS full menu |
| `Super+X` | Power menu |

### Window Management

| Keybind | Action |
|---------|--------|
| `Super+Shift+F` | Fullscreen |
| `Super+Ctrl+V` | Toggle floating |
| `Super+F` | Maximize column |
| `Super+←/→/↑/↓` | Focus window |
| `Super+Ctrl+←/→/↑/↓` | Move window |
| `Super+−/=` | Resize width ±10% |
| `Super+Shift+−/=` | Resize height ±10% |
| `Super+R` | Cycle preset widths |
| `Super+W` | Toggle tabbed display |

### Screenshots

| Keybind | Action |
|---------|--------|
| `Print` | Full screenshot + JARVIS sound |
| `Super+Print` | Region screenshot (slurp) |
| `Alt+Print` | Window screenshot |
| `Ctrl+Print` | Niri screenshot UI |

### Audio

| Keybind | Action |
|---------|--------|
| `XF86AudioMute` | Mute/unmute + voice feedback |
| `XF86AudioRaiseVolume` | Volume up + voice |
| `XF86AudioLowerVolume` | Volume down + voice |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

---

## J.A.R.V.I.S. Terminal Commands

Source `jarvis-ai.sh` in your `.bashrc` to get these everywhere:

```bash
j "how do I fix audio in PipeWire"   # Ask JARVIS anything via Gemini AI
wtf                                    # Explain the last system error
why                                    # Full system diagnostic
game-fix                               # Debug Proton/Wine logs
game-settings "Cyberpunk 2077"        # Optimal RX 580 settings for a game
cyberpunk-help                         # Quick Cyberpunk 2077 Linux fixes
fallout-help                           # Fallout 4 MO2 + F4SE tips
photo-help                             # Photography workflow advice
dt-help "tone equalizer"              # Darktable module deep-dive
explain ~/.config/niri/config.kdl     # AI explains any file
review myscript.sh                    # AI code review
generate "backup dotfiles to GitHub"  # AI generates a bash script
resource-hog                           # Find what's eating your CPU
audio-check                            # Analyse PipeWire config
gpu-check                              # RX 580 status + tips
```

---

## Voice Activation (Optional)

Offline wake-word detection using [Vosk](https://alphacephei.com/vosk/):

```bash
# One-time setup (~40MB model download)
~/.config/wehttamsnaps/scripts/voice-activation.sh setup

# Enable as background service
systemctl --user enable --now jarvis-voice.service
```

Then say **"Hey Jarvis"** followed by any command:
> *"Hey Jarvis, open Steam"*  
> *"Hey Jarvis, gaming mode"*  
> *"Hey Jarvis, screenshot"*

---

## Gaming

### MO2 Linux Helper

A full desktop app for configuring Mod Organizer 2 under Proton/Wine:

- Auto-installs protontricks, winetricks, GE-Proton, dotnet48
- Pre-configured fixes for 18 games (Cyberpunk 2077, Fallout 4, Skyrim SE/VR, Elden Ring, BG3, and more)
- NXM link handler registration for Nexus Mods
- Non-Steam shortcut builder (writes `shortcuts.vdf`)
- Flatpak permission manager
- Portable instance detector
- Native Linux plugin (`libgame_*.so`) manager

Open from: `apps/mo2-linux-helper.html` — full Tauri desktop app version coming soon.

### Pre-configured Games

| Game | Fixes | Notes |
|------|-------|-------|
| Cyberpunk 2077 | 5 | Proton-GE + ManguHUD |
| Fallout 4 | 3 | MO2 + F4SE |
| Skyrim SE | 2 | MO2 + SKSE |
| Skyrim VR | 4 | MO2 + SKSEVR |
| Fallout 3 | 1 | Proton-GE |
| Fallout New Vegas | 2 | Proton-GE |
| Oblivion Remastered | 6 | UE5 fixes |
| Starfield | 4 | Proton-GE + MO2 |
| Elden Ring | 3 | EAC bypass |
| BG3 | — | Native Linux |
| Witcher 3 | 2 | DX12 mode |
| Dark Souls Remastered | — | EAC + Proton-GE |
| xEdit / Synthesis / BodySlide | various | Wine + dotnet |

---

## Branches

| Branch | Purpose |
|--------|---------|
| `main` | Stable releases |
| `develop` | Integration branch |
| `wehttamsnaps-theme` | Theming experiments |
| `wehttamsnaps-widgets` | Quickshell widget dev |
| `wallpapers` | Wallpaper collection |
| `jarvis-sounds` | Sound pack organisation |
| `docs` | Documentation updates |

---

## Credits & Links

| | |
|-|-|
| **Author** | Matthew — [github.com/Crowdrocker](https://github.com/Crowdrocker) |
| **Twitch** | [twitch.tv/WehttamSnaps](https://twitch.tv/WehttamSnaps) |
| **YouTube** | [youtube.com/@WehttamSnaps](https://youtube.com/@WehttamSnaps) |
| **Niri** | [github.com/YaLTeR/niri](https://github.com/YaLTeR/niri) |
| **Noctalia-Shell** | Quickshell-based bar |
| **J.A.R.V.I.S. sounds** | [101soundboards.com — board 10155](https://www.101soundboards.com/boards/10155) |
| **iDroid sounds** | [101soundboards.com — board 10060](https://www.101soundboards.com/boards/10060) |
| **Vosk STT** | [alphacephei.com/vosk](https://alphacephei.com/vosk) |

---

*Made with love by Matthew — WehttamSnaps*  
*Photography · Gaming · Content Creation*
