# WehttamSnaps — Quick Start

> First boot cheatsheet. You just ran `./install.sh` — here's everything you need to know in the next 10 minutes.  
> Full details: [INSTALL.md](INSTALL.md)

---

## You're Live. Here's What to Do First.

```bash
# 1. Reload Niri to pick up the new config
niri msg action reload-config

# 2. Get your shell aliases live
source ~/.bashrc

# 3. Verify sounds are working
sound-system test
```

---

## The 10 Keybinds You Need Right Now

| Press | Does |
|-------|------|
| `Super+H` | **This cheatsheet** — full keybind reference on screen |
| `Super+Space` | App launcher |
| `Super+Enter` | Ghostty terminal |
| `Super+Q` | Close window |
| `Super+G` | Toggle gaming mode (iDroid on/off) |
| `Super+1` — `Super+0` | Switch workspaces |
| `Super+B` | Brave browser |
| `Super+F` | Thunar file manager |
| `Super+Print` | Region screenshot |
| `Super+X` | Power menu |

---

## Your 10 Workspaces

| `Super+` | Workspace | Use it for |
|----------|-----------|------------|
| `1` | Browser | Brave, Firefox |
| `2` | Dev | Ghostty, Kate |
| `3` | **Gaming** | Steam, Lutris, MO2 — iDroid sounds |
| `4` | Streaming | OBS Studio |
| `5` | **Photo** | Darktable → GIMP → Krita → Export |
| `6` | Media | Video editing |
| `7` | Comms | Discord |
| `8` | Audio | Spotify, qpwgraph |
| `9` | Files | Thunar, Dolphin |
| `0` | Misc | Overflow |

Move any window to a different workspace: `Super+Shift+[number]`

---

## Sound System

The J.A.R.V.I.S. / iDroid adaptive sound system fires automatically on every action.

```bash
sound-system test          # play all sounds in sequence
sound-system status        # check current voice mode
sound-system startup       # test the startup greeting
```

> **No sounds?** You need to download the mp3 packs.  
> J.A.R.V.I.S.: https://www.101soundboards.com/boards/10155  
> iDroid: https://www.101soundboards.com/boards/10060  
> Place files in `/usr/share/wehttamsnaps/sounds/jarvis/` and `idroid/`  
> See `README.md` in each folder for required filenames.

---

## Gaming Mode

```bash
# Super+G   — toggle on/off
# Or from terminal:
toggle-gamemode.sh            # toggle
toggle-gamemode.sh status     # see CPU/GPU state
toggle-gamemode.sh steam      # activate + launch Steam
toggle-gamemode.sh gamescope  # activate + launch gamescope
```

**What it does when ON:**
- CPU governor → `performance` (all 8 cores)
- Niri animations → disabled instantly
- RX 580 power profile → `high`
- Mesa/RADV → tuned (ACO, DXVK_ASYNC, FSR)
- Sound → switches to iDroid

**Super+G again** restores everything.

---

## JARVIS Terminal AI

```bash
j "how do I set up OBS for streaming"   # ask anything
wtf                                       # explain last system error
why                                       # full system diagnostic
game-fix                                  # debug Proton/Wine issues
game-settings "Cyberpunk 2077"           # optimal RX 580 settings
photo-help                                # photography tips
dt-help "tone equalizer"                 # Darktable module help
```

> Requires Gemini CLI configured with your API key.  
> Get a key at: https://ai.google.dev

---

## Window Management Basics

```bash
Super+←/→/↑/↓          focus window
Super+Ctrl+←/→/↑/↓     move window
Super+Shift+F           fullscreen
Super+Ctrl+V            toggle floating
Super+F                 maximize column
Super+−  /  Super+=     resize width ±10%
Super+R                 cycle preset widths (33% / 50% / 66% / 100%)
Super+W                 toggle tabbed column display
Super+Alt+C             center column
```

---

## Screenshots

```bash
Print               full screenshot + JARVIS sound
Super+Print         region select (drag to capture)
Alt+Print           focused window only
Ctrl+Print          Niri built-in screenshot UI
```

Screenshots save to `~/Pictures/Screenshots/`.

---

## Audio Controls

```bash
XF86AudioMute           mute/unmute + JARVIS voice feedback
XF86AudioRaiseVolume    volume up + voice
XF86AudioLowerVolume    volume down + voice
XF86AudioPlay           play/pause media
XF86AudioNext           next track
XF86AudioPrev           previous track
XF86MonBrightnessUp     brightness up
XF86MonBrightnessDown   brightness down
```

For audio routing (streaming setup):
```bash
qpwgraph &    # visual PipeWire patchbay
pavucontrol & # volume/device control
```

---

## App Launcher Shortcuts

Beyond `Super+Space` (Rofi drun), you have direct keybinds:

```bash
Super+Enter         Ghostty terminal
Super+B             Brave browser
Super+E             Kate editor
Super+F             Thunar files
Super+O             OBS Studio
Super+P             Spotify
Super+J             JARVIS interactive terminal
Super+Alt+J         JARVIS full Rofi menu
Super+Shift+W       Welcome screen
```

**Webapp launchers** (separate browser profiles):
```bash
Super+Ctrl+Y    YouTube
Super+Ctrl+T    Twitch
Super+Ctrl+S    Spotify web
Super+Ctrl+D    Discord web
```

---

## Photography Workflow

Switch to workspace 5 (`Super+5`) then:

| App | Role | Launch |
|-----|------|--------|
| DigiKam | Import + organise | `Super+Space` → digikam |
| Darktable | RAW processing | `Super+Space` → darktable |
| GIMP | Advanced editing | `Super+Space` → gimp |
| Krita | Touch-up / painting | `Super+Space` → krita |

Export with `Super+Shift+E` — plays the JARVIS export sound.

---

## System Aliases

```bash
update          # paru -Syu + cleanup
gaming          # toggle gaming mode
audio           # open pavucontrol
keyhints        # open full keybind GUI
welcome         # reopen welcome screen
niri-reload     # reload niri config
sound-test      # test all JARVIS/iDroid sounds
```

---

## System Commands

```bash
Super+Alt+L         lock screen (swaylock)
Super+X             power menu (shutdown / reboot / suspend)
Ctrl+Alt+Delete     quit Niri (emergency exit)
Super+Shift+\       reload Niri config + sound
Super+Shift+/       Niri built-in hotkey overlay
```

---

## Useful Terminal Commands

```bash
btop                    # system monitor
niri msg workspaces     # list active workspaces
niri msg windows        # list open windows
niri msg action ...     # send action to niri
sound-system status     # JARVIS sound mode status
toggle-gamemode.sh status   # gaming mode + CPU/GPU info
journalctl --user -xe   # system logs
paru -Syu               # update everything
```

---

## What Still Needs Doing

```
[ ] Download JARVIS sound pack  →  /usr/share/wehttamsnaps/sounds/jarvis/
[ ] Download iDroid sound pack  →  /usr/share/wehttamsnaps/sounds/idroid/
[ ] Add a wallpaper             →  ~/.config/wehttamsnaps/wallpapers/
[ ] Configure Gemini API key    →  for j / wtf / game-fix commands
[ ] Set up voice activation     →  voice-activation.sh setup  (optional)
[ ] Install Noctalia-Shell      →  when ready to replace Waybar
[ ] Add Steam library path      →  Steam → Settings → Storage
```

---

*WehttamSnaps — Photography · Gaming · Content Creation*  
*[github.com/Crowdrocker](https://github.com/Crowdrocker) · [twitch.tv/WehttamSnaps](https://twitch.tv/WehttamSnaps)*
