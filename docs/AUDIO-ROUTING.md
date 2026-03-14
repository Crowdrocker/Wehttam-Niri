# WehttamSnaps Audio Routing Guide

A comprehensive guide to setting up and managing audio routing with PipeWire for streaming, gaming, and recording on the WehttamSnaps Niri setup.

## Table of Contents

- [Overview](#overview)
- [PipeWire Basics](#pipewire-basics)
- [Audio Profiles](#audio-profiles)
- [Streaming Setup](#streaming-setup)
- [Gaming Audio](#gaming-audio)
- [Recording Setup](#recording-setup)
- [JARVIS Sound System](#jarvis-sound-system)
- [Troubleshooting](#troubleshooting)

## Overview

The WehttamSnaps audio system is built on PipeWire, the modern audio server for Linux that replaces both PulseAudio and JACK. PipeWire offers:

- Ultra-low latency audio processing
- Professional audio routing capabilities
- Seamless Bluetooth device handling
- Perfect for both gaming and streaming
- JACK compatibility for professional audio work

### Hardware Considerations

For your Dell XPS 8700 setup, consider:

- Primary audio output: Speakers or headphones via 3.5mm jack
- Microphone input: Built-in or external USB microphone
- Optional: USB audio interface for professional recording

## PipeWire Basics

### Installation

PipeWire should be installed automatically with the WehttamSnaps setup:

```bash
sudo pacman -S pipewire pipewire-pulse wireplumber
```

### Starting PipeWire

```bash
# Enable PipeWire services
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Check status
systemctl --user status pipewire
```

### Basic Commands

```bash
# List audio devices
wpctl status

# Set default output
wpctl set-default <device-id>

# Set volume
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.8

# Toggle mute
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```

### WirePlumber vs pipewire-media-session

WirePlumber is the recommended session manager for PipeWire, offering:

- Better device management
- Rule-based routing
- Improved Bluetooth support
- More stable performance

## Audio Profiles

The WehttamSnaps setup includes pre-configured audio profiles for different use cases.

### Available Profiles

| Profile | Purpose | Latency | Use Case |
|---------|---------|---------|----------|
| default | Balanced | 512 samples | Normal desktop use |
| gaming | Low latency | 256 samples | Gaming with minimal delay |
| streaming | Optimized | 512 samples | OBS/streaming setup |
| recording | High quality | 1024 samples | Photography video editing |

### Using Audio Profiles

```bash
# Initialize audio configuration
~/.config/wehttamsnaps/scripts/audio-setup.sh init

# Load gaming profile
~/.config/wehttamsnaps/scripts/audio-setup.sh profile gaming

# Load streaming profile
~/.config/wehttamsnaps/scripts/audio-setup.sh profile streaming

# Load recording profile
~/.config/wehttamsnaps/scripts/audio-setup.sh profile recording

# List available profiles
~/.config/wehttamsnaps/scripts/audio-setup.sh profiles
```

### Manual Profile Creation

Create custom profiles in `~/.config/wehttamsnaps/audio/profiles/`:

```bash
# ~/.config/wehttamsnaps/audio/profiles/custom.sh
#!/bin/bash

# Set quantum (buffer size) - lower = lower latency, higher CPU
pw-metadata -n settings 0 clock.force-quantum 128

# Set sample rate
pw-metadata -n settings 0 clock.force-rate 48000

# Configure default volumes
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.75
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.5

echo "Custom audio profile loaded"
```

## Streaming Setup

### OBS Audio Configuration

For streaming with OBS Studio:

1. **Install OBS with PipeWire support:**
   ```bash
   sudo pacman -S obs-studio pipewire-zeroconf
   ```

2. **Configure Audio in OBS:**
   - Settings → Audio → Desktop Audio: Default
   - Settings → Audio → Mic/Auxiliary Audio: Your microphone

3. **Use PipeWire Audio Capture:**
   - Add Source → Audio Input Capture → PipeWire
   - Select your microphone from the list

### Streaming Audio Routing

Create a streaming audio graph:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Microphone │────▶│   Discord   │────▶│  Headphones │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │
       │                   │
       ▼                   ▼
┌─────────────┐     ┌─────────────┐
│     OBS     │     │   Stream    │
└─────────────┘     └─────────────┘
       ▲
       │
┌─────────────┐
│   Desktop   │
│    Audio    │
└─────────────┘
```

### Using qpwgraph

qpwgraph provides a visual interface for audio routing:

```bash
# Install qpwgraph
sudo pacman -S qpwgraph

# Open qpwgraph
qpwgraph
```

**Creating a streaming routing:**

1. Open qpwgraph
2. Connect your microphone to Discord
3. Connect your microphone to OBS
4. Connect Desktop Audio to OBS
5. Connect OBS to your streaming platform
6. Save the graph for future use

## Gaming Audio

### Low Latency Setup

For gaming, minimize audio latency:

```bash
# Set low latency quantum
pw-metadata -n settings 0 clock.force-quantum 256
pw-metadata -n settings 0 clock.force-rate 48000
```

### Surround Sound (If Supported)

Configure surround sound for supported games:

```bash
# Check available channels
wpctl status

# Set surround profile (for 5.1/7.1 systems)
wpctl set-profile <device-id> <surround-profile>
```

### Game-Specific Audio

Some games may need specific audio configurations:

**Steam Games:**
```bash
# Force PipeWire audio for Steam games
SDL_AUDIODRIVER=pulse %command%
```

**Wine/Proton Games:**
```bash
# Use PulseAudio compatibility
PULSE_SERVER=unix:/run/user/1000/pulse/native %command%
```

### Voice Chat Setup

For Discord, TeamSpeak, or in-game voice chat:

1. Set your microphone as default input
2. Use NoiseTorch for noise suppression:

```bash
# Install NoiseTorch
yay -S noisetorch-bin

# Run NoiseTorch
noisetorch -i

# It creates a virtual microphone with noise suppression
```

## Recording Setup

### High-Quality Recording

For photography video work and content creation:

```bash
# Set high-quality audio settings
pw-metadata -n settings 0 clock.force-quantum 1024
pw-metadata -n settings 0 clock.force-rate 48000
```

### Multi-Track Recording

Use PipeWire's JACK compatibility for multi-track recording:

```bash
# Install JACK tools
sudo pacman -S jack2

# Use Catia or Carla for JACK routing
sudo pacman -S carla
```

### Recording Microphone

For optimal voice recording:

1. **Hardware:** Use a USB audio interface
2. **Software:** Configure in PipeWire
3. **Effects:** Use EasyEffects for real-time processing

```bash
# Install EasyEffects
sudo pacman -S easyeffects

# Configure noise reduction, compression, EQ
easyeffects
```

### EasyEffects Presets

Create a voice recording preset:

```bash
# ~/.config/easyeffects/voice-recording.json
{
  "input": {
    "plugins": [
      "noise_reduction",
      "compressor",
      "equalizer"
    ],
    "noise_reduction": {
      "model-path": "/path/to/model"
    },
    "compressor": {
      "threshold": -20,
      "ratio": 4
    }
  }
}
```

## JARVIS Sound System

The WehttamSnaps setup includes a JARVIS-inspired sound system with dual voice personalities.

### Voice Profiles

| Profile | Voice | Purpose |
|---------|-------|---------|
| default | JARVIS | Professional/work mode |
| gaming | iDroid | Gaming entertainment |

### Sound System Usage

```bash
# Switch to gaming voice
~/.config/wehttamsnaps/scripts/sound-system gaming

# Switch to JARVIS voice
~/.config/wehttamsnaps/scripts/sound-system default

# Play startup sound
~/.config/wehttamsnaps/scripts/sound-system startup

# Play notification sound
~/.config/wehttamsnaps/scripts/sound-system notify
```

### Adding Custom Sounds

Place sound files in the appropriate directories:

```
~/.config/wehttamsnaps/sounds/
├── jarvis/
│   ├── startup.wav
│   ├── welcome.wav
│   ├── notify.wav
│   └── error.wav
├── idroid/
│   ├── startup.wav
│   ├── game-on.wav
│   ├── game-off.wav
│   └── victory.wav
└── system/
    ├── click.wav
    ├── volume.wav
    └── screenshot.wav
```

### Sound File Requirements

- Format: WAV, OGG, or FLAC recommended
- Sample Rate: 48000 Hz
- Bit Depth: 16-bit or 24-bit
- Channels: Mono for UI sounds, Stereo for music/ambiance

## Troubleshooting

### No Sound

1. Check PipeWire is running:
   ```bash
   systemctl --user status pipewire
   ```

2. Check device volumes:
   ```bash
   wpctl status
   ```

3. Restart PipeWire:
   ```bash
   systemctl --user restart pipewire wireplumber
   ```

### Audio Crackling/Popping

1. Increase buffer size:
   ```bash
   pw-metadata -n settings 0 clock.force-quantum 1024
   ```

2. Check for CPU overload:
   ```bash
   htop
   ```

3. Verify sample rate matches:
   ```bash
   pw-metadata -n settings 0 clock.force-rate 48000
   ```

### Microphone Not Working

1. Check microphone is detected:
   ```bash
   arecord -l
   ```

2. Set as default input:
   ```bash
   wpctl set-default <mic-id>
   ```

3. Check permissions:
   ```bash
   groups $USER  # Should include 'audio'
   ```

### Bluetooth Audio Issues

1. Install Bluetooth support:
   ```bash
   sudo pacman -S bluez bluez-utils pipewire-pulse
   ```

2. Enable Bluetooth service:
   ```bash
   sudo systemctl enable --now bluetooth
   ```

3. Connect device:
   ```bash
   bluetoothctl
   # power on
   # scan on
   # pair <mac-address>
   # connect <mac-address>
   ```

### OBS Not Capturing Audio

1. Use PipeWire audio capture
2. Check device permissions
3. Restart OBS after PipeWire changes

### Discord Audio Issues

1. Use `LD_PRELOAD` for PulseAudio compatibility:
   ```bash
   LD_PRELOAD=/usr/lib/libpulse.so discord
   ```

2. Or use Flatpak version:
   ```bash
   flatpak install flathub com.discordapp.Discord
   ```

## Useful Commands

```bash
# List all audio devices
wpctl status

# Monitor audio latency
pw-top

# Show audio graph
pw-dot | dot -Tpng -o audio-graph.png

# Dump current configuration
pw-metadata

# Reset PipeWire
systemctl --user restart pipewire wireplumber

# Test audio speaker-test
speaker-test -D default -c 2

# Record audio
pw-record test.wav

# Play audio
pw-play test.wav
```

## Additional Resources

- [PipeWire Documentation](https://docs.pipewire.org/)
- [WirePlumber Documentation](https://pipewire.pages.freedesktop.org/wireplumber/)
- [Arch Wiki - PipeWire](https://wiki.archlinux.org/title/PipeWire)
- [EasyEffects GitHub](https://github.com/wwmm/easyeffects)
- [NoiseTorch](https://github.com/noisetorch/NoiseTorch)