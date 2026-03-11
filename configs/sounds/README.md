# Adaptive Sound System

This directory contains the voice packs for the WehttamSnaps-SwayFx adaptive sound system.

## Overview

The sound system provides context-aware audio feedback that changes based on your current activity:

| Mode | Voice | Context |
|------|-------|---------|
| **J.A.R.V.I.S.** | Paul Bettany-style AI | Work, Photography, Streaming, Media |
| **iDroid** | Tactical AI | Gaming, GameMode, Performance |

## Directory Structure

```
sounds/
├── jarvis/           # J.A.R.V.I.S. voice pack (work mode)
│   ├── startup.wav
│   ├── welcome.wav
│   ├── screenshot.wav
│   └── ...
├── idroid/           # iDroid voice pack (gaming mode)
│   ├── startup.wav
│   ├── gamemode-on.wav
│   └── ...
└── README.md         # This file
```

## Mode Switching

The system automatically switches voice packs based on:

1. **Workspace Changes** - Switching to Workspace 3 (Gaming) triggers iDroid mode
2. **GameMode Toggle** - `Super+Shift+G` toggles gaming optimizations and iDroid sounds
3. **Manual Override** - Use `jarvis-menu` to select voice mode

## Scripts

| Script | Location | Purpose |
|--------|----------|---------|
| `sound-system` | `~/.config/sway/scripts/` | Main sound playback controller |
| `jarvis` | `~/.config/sway/scripts/` | J.A.R.V.I.S. command interface |
| `jarvis-manager.sh` | `~/.config/sway/scripts/` | Voice mode management |
| `jarvis-menu` | `~/.config/sway/scripts/` | Interactive mode selection |
| `toggle-gamemode.sh` | `~/.config/sway/scripts/` | Gaming mode toggle with sound |

## Configuration

Edit the voice mode in your Sway config:

```bash
# Set default voice mode
set $voice_mode "jarvis"

# Override for specific workspaces
bindsym $mod+3 exec ~/.config/sway/scripts/jarvis-manager.sh switch idroid
```

## Adding Custom Voice Packs

1. Create a new directory: `sounds/custom/`
2. Add your `.wav` files following the naming convention
3. Register the pack:

```bash
~/.config/sway/scripts/jarvis-manager.sh register custom "Custom Voice"
```

## Quick Setup

```bash
# Download community sounds (example sources)
cd ~/.config/sway/sounds/jarvis
# Add your sound files here

cd ../idroid
# Add your gaming sounds here

# Test the system
~/.config/sway/scripts/sound-system test jarvis startup
~/.config/sway/scripts/sound-system test idroid gamemode-on
```

## Troubleshooting

### Sounds not playing?

1. Check PipeWire is running: `systemctl --user status pipewire`
2. Verify sound files exist: `ls -la ~/.config/sway/sounds/jarvis/`
3. Test manually: `paplay ~/.config/sway/sounds/jarvis/startup.wav`

### Wrong mode active?

```bash
# Check current mode
cat /tmp/jarvis-mode

# Force mode
~/.config/sway/scripts/jarvis-manager.sh switch jarvis
```

### Latency issues?

For lower latency, convert MP3 to WAV:

```bash
for f in *.mp3; do
  ffmpeg -i "$f" "${f%.mp3}.wav"
done
```

## Voice Pack Sources

See individual README files for detailed sourcing instructions:
- [J.A.R.V.I.S. Sounds](./jarvis/README.md)
- [iDroid Sounds](./idroid/README.md)