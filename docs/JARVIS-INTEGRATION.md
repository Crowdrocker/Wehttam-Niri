# WehttamSnaps JARVIS Integration Guide

A comprehensive guide to setting up and using the JARVIS AI assistant integration with the WehttamSnaps Niri setup.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Voice System](#voice-system)
- [Commands & Aliases](#commands--aliases)
- [Sound Packs](#sound-packs)
- [Menu System](#menu-system)
- [Advanced Usage](#advanced-usage)
- [Troubleshooting](#troubleshooting)

## Overview

The JARVIS integration brings Iron Man-inspired AI assistant functionality to your WehttamSnaps setup. Inspired by Tony Stark's AI butler, this system provides voice feedback, natural language commands, and an interactive menu system for controlling your workstation.

### What is JARVIS?

JARVIS (Just A Rather Very Intelligent System) is a voice-activated AI assistant that:

- Responds to voice commands with audio feedback
- Integrates with Gemini AI for intelligent responses
- Controls system functions through natural language
- Adapts its personality based on your current mode (work/gaming)
- Provides a visual menu interface for quick actions

### Dual Voice System

The WehttamSnaps setup includes two voice personalities:

| Profile | Voice | Mode | Purpose |
|---------|-------|------|---------|
| JARVIS | Professional, British-style | Work | Photography, productivity, professional tasks |
| iDroid | Casual, gaming-focused | Gaming | Gaming sessions, entertainment, casual use |

## Features

### Core Features

- **Voice Activation:** Speak commands naturally
- **Sound Feedback:** Audio responses for system events
- **AI Integration:** Connects to Google Gemini for intelligent responses
- **Visual Menu:** Rofi/Wofi-based graphical menu
- **Keyboard Shortcuts:** Quick access to JARVIS functions
- **Context Awareness:** Knows if you're gaming or working
- **Customizable:** Add your own commands and responses

### Sound Events

The system provides audio feedback for:

| Event | Sound |
|-------|-------|
| Startup | "Good morning/afternoon/evening, sir" |
| GameMode On | iDroid activation sound |
| GameMode Off | JARVIS reactivation sound |
| Screenshot | Camera shutter sound |
| Volume Change | Interface tick sound |
| Notification | Alert sound |
| Error | Error beep |
| Shutdown | Goodbye message |

## Installation

### Prerequisites

```bash
# Required packages
sudo pacman -S \
    python \
    python-pip \
    python-gobject \
    pipewire \
    rofi-wayland \
    wofi

# Python packages
pip install --user google-generativeai python-dotenv
```

### JARVIS Files

The JARVIS system consists of several components:

```
~/.config/wehttamsnaps/scripts/
├── jarvis/
│   ├── jarvis              # Main voice assistant
│   ├── jarvis-ai.sh        # AI integration script
│   ├── jarvis-manager.sh   # Management utility
│   ├── jarvis-menu         # Visual menu launcher
│   ├── voice-activation.sh # Voice activation
│   ├── voice-engine.sh     # TTS engine
│   └── jarvis-sounds.sh    # Sound playback
├── sound-system            # Adaptive sound switching
└── toggle-gamemode.sh      # GameMode with voice switch
```

### Installing JARVIS

```bash
# Navigate to the setup directory
cd ~/.config/wehttamsnaps/scripts

# Make scripts executable
chmod +x jarvis/*
chmod +x sound-system

# Initialize JARVIS
./jarvis/jarvis-manager.sh init
```

### Gemini API Setup (Optional)

For AI-powered responses:

1. Get a Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)

2. Create the environment file:
   ```bash
   echo "GEMINI_API_KEY=your_api_key_here" > ~/.config/wehttamsnaps/.env
   ```

3. Test the integration:
   ```bash
   ~/.config/wehttamsnaps/scripts/jarvis/jarvis-ai.sh "What time is it?"
   ```

## Configuration

### Main Configuration

Edit `~/.config/wehttamsnaps/jarvis.conf`:

```bash
# JARVIS Configuration
# ====================

# Voice Settings
VOICE_PROFILE="jarvis"           # jarvis or idroid
VOICE_SPEED="1.0"                # Speech speed (0.5-2.0)
VOICE_PITCH="0"                  # Pitch adjustment (-10 to 10)

# Behavior
STARTUP_GREETING="true"          # Greet on login
CONTEXT_AWARE="true"             # Switch voice with GameMode
SOUND_EFFECTS="true"             # Play sound effects

# AI Settings
AI_ENABLED="true"                # Enable Gemini AI
AI_MODEL="gemini-pro"            # Gemini model to use
MAX_TOKENS="256"                 # Max response length

# Activation
ACTIVATION_KEY="Super+J"         # Keyboard shortcut
ACTIVATION_WORD="jarvis"         # Wake word for voice activation
ACTIVATION_TIMEOUT="5"           # Seconds to listen after wake word
```

### Environment Variables

Set in `~/.config/wehttamsnaps/.env`:

```bash
# Gemini API
GEMINI_API_KEY=your_api_key

# Custom paths
JARVIS_SOUNDS_DIR=~/.config/wehttamsnaps/sounds
JARVIS_CACHE_DIR=~/.cache/jarvis

# Debugging
JARVIS_DEBUG=false
```

## Voice System

### Text-to-Speech Options

JARVIS supports multiple TTS engines:

#### 1. espeak-ng (Default, Lightweight)

```bash
sudo pacman -S espeak-ng
```

#### 2. festival (Higher Quality)

```bash
sudo pacman -S festival festival-english
```

#### 3. Piper (Neural TTS)

```bash
yay -S piper-tts-bin
```

#### 4. Online TTS (Google/AWS)

Requires internet connection, but highest quality.

### Switching Voice Profiles

```bash
# Switch to JARVIS voice
~/.config/wehttamsnaps/scripts/sound-system default

# Switch to iDroid voice
~/.config/wehttamsnaps/scripts/sound-system gaming

# Toggle between voices
~/.config/wehttamsnaps/scripts/sound-system toggle
```

### Testing Voice

```bash
# Test JARVIS voice
echo "Systems operational, sir" | ~/.config/wehttamsnaps/scripts/jarvis/voice-engine.sh

# Test with specific profile
VOICE_PROFILE=idroid echo "Ready for gaming" | ~/.config/wehttamsnaps/scripts/jarvis/voice-engine.sh
```

## Commands & Aliases

### Natural Language Commands

JARVIS understands various natural language commands:

| Command | Action |
|---------|--------|
| "Open [app]" | Launch application |
| "Switch to [workspace]" | Change workspace |
| "Volume [up/down/mute]" | Control audio |
| "Take screenshot" | Capture screen |
| "What time is it?" | Speak current time |
| "What's the weather?" | Weather information |
| "Enable gaming mode" | Toggle GameMode |
| "Show [system stats]" | Display information |

### Shell Aliases

The WehttamSnaps setup includes convenient aliases:

```bash
# System Control
alias jarvis='~/.config/wehttamsnaps/scripts/jarvis/jarvis'
alias jarvis-ai='~/.config/wehttamsnaps/scripts/jarvis/jarvis-ai.sh'
alias jarvis-menu='~/.config/wehttamsnaps/scripts/jarvis/jarvis-menu'
alias jarvis-sound='~/.config/wehttamsnaps/scripts/sound-system'

# Quick Actions
alias gm='~/.config/wehttamsnaps/scripts/toggle-gamemode.sh toggle'
alias gmon='~/.config/wehttamsnaps/scripts/toggle-gamemode.sh on'
alias gmoff='~/.config/wehttamsnaps/scripts/toggle-gamemode.sh off'
alias gmstat='~/.config/wehttamsnaps/scripts/toggle-gamemode.sh status'

# Audio
alias audio='~/.config/wehttamsnaps/scripts/audio-setup.sh'
alias volup='wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'
alias voldown='wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'
alias mute='wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'

# Screenshot
alias shot='grim -g "$(slurp)" - | wl-copy'
alias shotfull='grim - | wl-copy'
```

### Custom Commands

Add custom commands to `~/.config/wehttamsnaps/jarvis-commands.conf`:

```bash
# Custom JARVIS Commands
# Format: trigger phrase|command to execute

open browser|firefox
open photos|darktable
open game|steam
take photo|cheese
start streaming|obs
what's my ip|curl -s ifconfig.me
system status|neofetch
```

## Sound Packs

### Directory Structure

```
~/.config/wehttamsnaps/sounds/
├── jarvis/                    # JARVIS voice pack
│   ├── startup.wav
│   ├── welcome.wav
│   ├── confirm.wav
│   ├── error.wav
│   ├── notify.wav
│   ├── shutdown.wav
│   └── phrases/
│       ├── greeting-morning.wav
│       ├── greeting-afternoon.wav
│       └── greeting-evening.wav
├── idroid/                    # iDroid voice pack
│   ├── startup.wav
│   ├── game-on.wav
│   ├── game-off.wav
│   ├── victory.wav
│   └── phrases/
│       └── ...
└── system/                    # System sounds
    ├── click.wav
    ├── camera-shutter.wav
    ├── volume-change.wav
    └── notification.wav
```

### Creating Custom Sound Packs

1. Create a new pack directory:
   ```bash
   mkdir -p ~/.config/wehttamsnaps/sounds/custom
   ```

2. Add your sound files (WAV format recommended)

3. Create a pack configuration:
   ```bash
   cat > ~/.config/wehttamsnaps/sounds/custom/pack.conf << EOF
   NAME="Custom Voice Pack"
   VOICE_SPEED=1.0
   STARTUP=startup.wav
   CONFIRM=confirm.wav
   ERROR=error.wav
   EOF
   ```

4. Select the pack:
   ```bash
   ~/.config/wehttamsnaps/scripts/sound-system custom
   ```

### Sound File Requirements

| Property | Recommended |
|----------|-------------|
| Format | WAV, OGG, or FLAC |
| Sample Rate | 48000 Hz |
| Bit Depth | 16-bit |
| Channels | Mono for UI, Stereo for music |

## Menu System

### Opening the Menu

```bash
# Keyboard shortcut
Mod+J                    # Default shortcut

# Command line
jarvis-menu

# Or directly
rofi -show drun -theme ~/.config/wehttamsnaps/rofi/jarvis.rasi
```

### Menu Options

The JARVIS menu provides quick access to:

1. **Applications** - Launch your apps
2. **System Controls** - Power, volume, display
3. **Quick Actions** - Screenshot, recording, gaming
4. **JARVIS Commands** - Voice commands list
5. **Settings** - Configuration options

### Customizing the Menu

Edit `~/.config/wehttamsnaps/rofi/jarvis.rasi`:

```css
/* JARVIS Menu Theme */
* {
    background: #1e1e2e;
    foreground: #cdd6f4;
    accent: #89b4fa;
    accent-alt: #cba6f7;
    
    /* Gradient border */
    border-gradient: linear-gradient(135deg, #89b4fa, #cba6f7);
}

window {
    border: 2px solid;
    border-color: @accent;
    border-radius: 12px;
}

listview {
    lines: 8;
    columns: 1;
}

element selected {
    background: linear-gradient(90deg, #89b4fa33, #cba6f733);
}
```

## Advanced Usage

### Voice Activation (Wake Word)

Enable always-on voice activation:

```bash
# Install voice activation dependencies
pip install --user pvporcupine speechrecognition

# Start voice activation daemon
~/.config/wehttamsnaps/scripts/jarvis/voice-activation.sh start

# Stop the daemon
~/.config/wehttamsnaps/scripts/jarvis/voice-activation.sh stop
```

### AI Integration

Using Gemini AI for intelligent responses:

```bash
# Ask a question
jarvis-ai "What's the best photo editing software for Linux?"

# Get code help
jarvis-ai "Write a bash script to backup my photos"

# System query
jarvis-ai "How much disk space do I have left?"
```

### Automation

Create automated JARVIS announcements:

```bash
# Schedule announcement (cron)
0 9 * * * ~/.config/wehttamsnaps/scripts/jarvis/jarvis "Good morning! Time to start the day."

# System event triggers
echo 'System update complete' | ~/.config/wehttamsnaps/scripts/jarvis/voice-engine.sh
```

### Integration with Other Apps

**With OBS:**
```bash
# Start streaming with JARVIS announcement
jarvis "Starting stream in 5 seconds" && sleep 5 && obs
```

**With Darktable:**
```bash
# Photo import announcement
jarvis "Importing photos from SD card" && darktable --import /media/sdcard
```

## Troubleshooting

### No Sound Output

1. Check sound files exist:
   ```bash
   ls ~/.config/wehttamsnaps/sounds/jarvis/
   ```

2. Test PipeWire:
   ```bash
   pw-play ~/.config/wehttamsnaps/sounds/jarvis/startup.wav
   ```

3. Check volume:
   ```bash
   wpctl get-volume @DEFAULT_AUDIO_SINK@
   ```

### JARVIS Not Responding

1. Check script permissions:
   ```bash
   ls -la ~/.config/wehttamsnaps/scripts/jarvis/
   ```

2. Run manually with debug:
   ```bash
   JARVIS_DEBUG=true ~/.config/wehttamsnaps/scripts/jarvis/jarvis
   ```

### Gemini AI Not Working

1. Check API key:
   ```bash
   cat ~/.config/wehttamsnaps/.env | grep GEMINI
   ```

2. Test connection:
   ```bash
   curl -s "https://generativelanguage.googleapis.com/v1/models?key=YOUR_KEY"
   ```

3. Check Python packages:
   ```bash
   pip list | grep google
   ```

### Menu Not Showing

1. Check Rofi is installed:
   ```bash
   which rofi
   ```

2. Test Rofi directly:
   ```bash
   rofi -show drun
   ```

3. Check theme file:
   ```bash
   ls ~/.config/wehttamsnaps/rofi/
   ```

### Voice Activation Issues

1. Check microphone:
   ```bash
   arecord -l
   ```

2. Test recording:
   ```bash
   arecord -d 3 test.wav && aplay test.wav
   ```

3. Check Python dependencies:
   ```bash
   pip list | grep -E "porcupine|speech"
   ```

## Additional Resources

- [Google Gemini API](https://ai.google.dev/)
- [Rofi Documentation](https://github.com/davatorium/rofi)
- [PipeWire Audio](https://pipewire.org/)
- [espeak-ng](https://github.com/espeak-ng/espeak-ng)
- [Piper TTS](https://github.com/rhasspy/piper)

---

**Created with ❤️ for the WehttamSnaps Photography & Gaming Setup**