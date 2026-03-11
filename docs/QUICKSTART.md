# Quick Start Guide - WehttamSnaps-SwayFx

Get up and running quickly with your new WehttamSnaps workstation.

## First Boot Checklist

### 1. Start SwayFx

From a TTY (Ctrl+Alt+F2 through F6):

```bash
sway --unsupported-gpu
```

Or if using a display manager, select Sway from the session menu.

### 2. Verify Everything Works

| Check | Command/Action |
|-------|----------------|
| Waybar visible | Look at top/bottom bar |
| Workspaces work | Press `Super + 1-0` |
| Terminal opens | Press `Super + Return` |
| App launcher works | Press `Super + D` |
| Screenshots work | Press `Print Screen` |
| Volume control | Press `XF86AudioRaiseVolume` |

### 3. Essential First Steps

```bash
# Update system
sudo pacman -Syu

# Install AUR helper (paru recommended)
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

# Install commonly needed AUR packages
paru -S visual-studio-code-bin discord spotify
```

## Quick Navigation

### Window Management

| Action | Keybinding |
|--------|------------|
| Open terminal | `Super + Return` |
| App launcher | `Super + D` |
| Close window | `Super + Q` |
| Fullscreen | `Super + F` |
| Toggle floating | `Super + Shift + Space` |
| Toggle split | `Super + V` |
| Move focus | `Super + Arrow Keys` |
| Move window | `Super + Shift + Arrow Keys` |
| Resize mode | `Super + R` |

### Workspaces

| Workspace | Key | Purpose |
|-----------|-----|---------|
| 1: Browser | `Super + 1` | Web browsing |
| 2: Terminal | `Super + 2` | Development, terminal apps |
| 3: Gaming | `Super + 3` | Games, Steam, Lutris |
| 4: Streaming | `Super + 4` | OBS, streaming tools |
| 5: Photography | `Super + 5` | Darktable, GIMP, Krita |
| 6: Media | `Super + 6` | Video, music players |
| 7: Comms | `Super + 7` | Discord, Slack |
| 8: Music | `Super + 8` | Spotify, DAWs |
| 9: Files | `Super + 9` | File manager |
| 0: Misc | `Super + 0` | Other apps |

### Essential Launchers

| Application | Keybinding |
|------------|------------|
| Browser | `Super + B` |
| File Manager | `Super + E` |
| Screenshot (area) | `Print Screen` |
| Screenshot (window) | `Shift + Print Screen` |
| Screen recorder | `Super + Shift + R` |
| Notification center | `Super + N` |
| J.A.R.V.I.S. menu | `Super + J` |
| Gaming mode toggle | `Super + Shift + G` |

## Quick Setup Tasks

### Set Up Sounds

1. Download or create your J.A.R.V.I.S. sounds:
   ```bash
   cd ~/.config/sway/sounds/jarvis
   # Place your .wav files here
   ```

2. Download or create iDroid sounds:
   ```bash
   cd ~/.config/sway/sounds/idroid
   # Place your .wav files here
   ```

3. Test the sound system:
   ```bash
   ~/.config/sway/scripts/sound-system test jarvis startup
   ```

### Configure Audio Routing

```bash
# Run audio setup
~/.config/sway/scripts/audio-setup.sh

# Open audio router
qpwgraph &
```

### Enable GameMode

```bash
# Enable service
systemctl --user enable --now gamemoded

# Test
gamemoded -s
```

### Set Up Gaming

1. Install Steam:
   ```bash
   sudo pacman -S steam
   ```

2. Enable Proton in Steam:
   - Settings → Steam Play → Enable all titles
   - Install Proton GE with `protonup-qt`

3. Launch games with optimizations:
   ```
   gamemoderun gamescope -f %command%
   ```

## Workflows

### Photography Workflow

```bash
# Go to photography workspace
Super + 5

# Launch Darktable for RAW editing
Super + D, type "darktable"

# Launch GIMP for advanced editing
Super + D, type "gimp"

# Take reference screenshots
Print Screen (area selection)
```

### Gaming Workflow

```bash
# Switch to gaming workspace
Super + 3

# Enable gaming mode (switches to iDroid sounds)
Super + Shift + G

# Launch Steam
Super + D, type "steam"

# Or launch specific game with optimizations:
gamescope -w 1920 -h 1080 -f -- %command%
```

### Streaming Workflow

```bash
# Switch to streaming workspace
Super + 4

# Launch OBS
Super + D, type "obs"

# Configure audio routing with qpwgraph
Super + D, type "qpwgraph"

# Start recording/streaming
# OBS hotkeys work globally
```

## Common Customizations

### Change Wallpaper

```bash
# Edit output config
vim ~/.config/sway/config.d/output

# Add or modify:
output * bg /path/to/wallpaper.jpg fill
```

### Add Custom Keybindings

```bash
# Edit keybindings
vim ~/.config/sway/config.d/keybindings

# Add your bindings:
bindsym $mod+Shift+P exec your-program
```

### Change Theme Colors

```bash
# Edit theme
vim ~/.config/sway/config.d/theme

# Modify colors:
set $cyan #00ffd1
set $blue #3b82ff
set $magenta #ff5af1
```

### Add Autostart Apps

```bash
# Edit autostart
vim ~/.config/sway/config.d/autostart

# Add programs:
exec --no-startup-id your-program
```

## Quick Fixes

### Waybar Not Showing

```bash
# Restart waybar
pkill waybar && waybar &

# Check for errors
waybar 2>&1 | tee waybar-debug.log
```

### No Audio

```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Open mixer
pavucontrol
```

### Notifications Not Working

```bash
# Restart mako
pkill mako && mako &
```

### Screenshots Not Saving

```bash
# Create screenshots directory
mkdir -p ~/Pictures/Screenshots

# Check grim is installed
which grim slurp
```

## Next Steps

- Read the full [Keybindings Reference](./KEYBINDS.md)
- Configure [Gaming](./GAMING.md) optimizations
- Set up [Audio Routing](./AUDIO-ROUTING.md)
- Join the community on r/unixporn or Discord