# Audio Routing Guide - WehttamSnaps-SwayFx

Complete guide for setting up VoiceMeeter-like audio routing with PipeWire.

## Overview

WehttamSnaps-SwayFx uses PipeWire to create a flexible audio routing system similar to VoiceMeeter on Windows. This allows you to:

- Separate game audio, music, browser audio, and microphone
- Route audio to different outputs (headphones, speakers, stream)
- Apply effects to specific audio streams
- Create complex mixing setups for streaming

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         PipeWire Graph                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────────┐      │
│  │  Games   │───▶│ game-audio   │───▶│                  │      │
│  └──────────┘    │ (virtual)    │    │                  │      │
│                  └──────────────┘    │                  │      │
│  ┌──────────┐    ┌──────────────┐    │  Main Output     │      │
│  │ Browser  │───▶│browser-audio │───▶│  (Headphones)    │      │
│  └──────────┘    │ (virtual)    │    │                  │      │
│                  └──────────────┘    │                  │      │
│  ┌──────────┐    ┌──────────────┐    │                  │      │
│  │  Music   │───▶│ music-audio  │───▶│                  │      │
│  └──────────┘    │ (virtual)    │    │                  │      │
│                  └──────────────┘    └──────────────────┘      │
│  ┌──────────┐    ┌──────────────┐                               │
│  │   Mic    │───▶│mic-passthru  │───▶ Applications (Discord)   │
│  └──────────┘    │ (virtual)    │───▶ OBS Recording            │
│                  └──────────────┘                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Setup

### Run the Setup Script

```bash
# Create virtual audio devices
~/.config/sway/scripts/audio-setup.sh
```

This script creates:
- `game-audio` - For game sounds
- `browser-audio` - For browser/video
- `music-audio` - For music players
- `mic-passthrough` - For microphone routing

### Verify Setup

```bash
# List all audio devices
pactl list sinks short

# Expected output includes:
# game-audio
# browser-audio
# music-audio
# mic-passthrough
```

## Visual Routing with qpwgraph

For the easiest audio management, use qpwgraph:

```bash
# Install qpwgraph
sudo pacman -S qpwgraph

# Launch
qpwgraph &
```

### Using qpwgraph

1. **Left column:** Input sources (applications, microphones)
2. **Right column:** Output devices (speakers, headphones, virtual sinks)
3. **Connect:** Click and drag from input to output
4. **Disconnect:** Click on existing connection

### Recommended Routing

| Source | Connect To | Purpose |
|--------|------------|---------|
| Game | game-audio | Isolated game sound |
| Browser | browser-audio | Video/audio from web |
| Spotify | music-audio | Background music |
| Microphone | mic-passthrough | Mic for apps |
| game-audio monitor | Headphones | You hear game |
| browser-audio monitor | Headphones | You hear browser |
| game-audio monitor | OBS | Stream hears game |
| mic-passthrough | Discord | Apps hear you |

## Command-Line Management

### List Devices

```bash
# All sinks (outputs)
pactl list sinks short

# All sources (inputs)
pactl list sources short

# All clients (applications)
pactl list clients
```

### Move Audio to Specific Sink

```bash
# Find application's input index
pactl list sink-inputs

# Move to specific sink
pactl move-sink-input <index> game-audio
```

### Set Default Output

```bash
# Set default sink
pactl set-default-sink game-audio

# Set default source
pactl set-default-source mic-passthrough
```

### Volume Control

```bash
# Set volume (0-65536, 65536 = 100%)
pactl set-sink-volume game-audio 65536

# Mute/Unmute
pactl set-sink-mute game-audio toggle

# Using wpctl (simpler)
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5  # 50%
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
```

## Virtual Sink Configuration

### Creating Custom Sinks

```bash
# Create a new virtual sink
pw-cli create-node adapter '{ 
  factory.name=support.null-audio-sink 
  node.name="custom-sink" 
  media.class=Audio/Sink 
  object.linger=true 
}'
```

### Persistent Configuration

Add to `~/.config/pipewire/pipewire.conf.d/audio-routing.conf`:

```json
{
  "context.modules": [
    {
      "name": "libpipewire-module-loopback",
      "args": {
        "node.description": "Game Audio",
        "node.name": "game-audio",
        "media.class": "Audio/Sink",
        "capture.props": {
          "media.role": "game",
          "node.name": "game-audio-capture"
        },
        "playback.props": {
          "media.role": "game",
          "node.name": "game-audio-playback"
        }
      }
    },
    {
      "name": "libpipewire-module-loopback",
      "args": {
        "node.description": "Browser Audio",
        "node.name": "browser-audio",
        "media.class": "Audio/Sink"
      }
    },
    {
      "name": "libpipewire-module-loopback",
      "args": {
        "node.description": "Music Audio",
        "node.name": "music-audio",
        "media.class": "Audio/Sink"
      }
    }
  ]
}
```

## Streaming Setup

### OBS Audio Configuration

1. **Open OBS Settings → Audio**
2. **Desktop Audio 1:** Monitor of game-audio
3. **Desktop Audio 2:** Monitor of browser-audio
4. **Mic/Auxiliary Audio:** mic-passthrough
5. **Monitoring Device:** Your headphones

### Audio Monitoring

In OBS, set up monitoring for each source:

1. Right-click audio source
2. Advanced Audio Properties
3. Audio Monitoring:
   - **Monitor Off:** Only stream hears it
   - **Monitor Only:** Only you hear it
   - **Monitor and Output:** Both hear it

### Music Ducking

Use EasyEffects for automatic ducking:

```bash
sudo pacman -S easyeffects
```

Create a preset that ducks music when microphone is active.

## Application-Specific Routing

### Route Steam Games

```bash
# Set Steam to use game-audio
PULSE_SINK=game-audio steam
```

Or configure in `~/.config/steam/steamapps/steam.cfg`:
```
"Steam"
{
  "AudioSink"  "game-audio"
}
```

### Route Discord

```bash
# Discord audio settings
# Input: mic-passthrough
# Output: browser-audio (or your headphones directly)
```

### Route Spotify

```bash
# Start Spotify with specific sink
spotify --device=music-audio

# Or use spotify-launcher
echo 'spotify --device=music-audio' > ~/.config/spotify-launcher.conf
```

### Route Firefox

```bash
# Set Firefox audio sink
# about:config → media.cubeb.output_device
# Set to the node name of your sink
```

Or use the Audio Output Selector extension.

## Audio Effects

### EasyEffects

Apply effects to audio streams:

```bash
sudo pacman -S easyeffects

# Launch
easyeffects
```

**Useful Effects:**
- **Noise Reduction:** For microphone
- **Equalizer:** For music/game audio
- **Compressor:** For streaming
- **Limiter:** Prevent clipping

### NoiseTorch

Real-time microphone noise suppression:

```bash
paru -S noisetorch
noisetorch
```

### Microphone Configuration

Create a noise-gate in EasyEffects:

1. Add Noise Suppression
2. Add Gate (voice activation)
3. Add Compressor (even levels)

## Advanced Routing

### Multiple Outputs

Send audio to multiple devices simultaneously:

```bash
# Create combined sink
pactl load-module module-combine-sink \
  sink_name=combined \
  slaves=alsa_output.pci-0000_00_1b.0.analog-stereo,bluez_sink.XX_XX_XX_XX_XX_XX.a2dp_sink
```

### Audio Delay Compensation

For sync issues (common with Bluetooth):

```bash
# Delay audio by milliseconds
pactl latency-ms=100 game-audio
```

### Per-Application Volume

Save and restore volume per application:

```bash
# Create profile
pactl list sink-inputs > ~/.config/audio-profiles/gaming.conf

# Restore
~/.config/sway/scripts/restore-audio gaming
```

## Troubleshooting

### No Audio After Setup

```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check if virtual sinks exist
pactl list sinks | grep -A5 "game-audio"
```

### Audio Crackling

```bash
# Increase buffer size
echo 'default-fragment-size-msec = 5' | sudo tee -a /etc/pipewire/pipewire.conf

# Or try larger quantum
pw-metadata -n settings 0 clock.force-quantum 1024
```

### Bluetooth Audio Issues

```bash
# Check Bluetooth codec
pactl list cards | grep codec

# Force high-quality codec
pactl set-card-profile bluez_card.XX_XX_XX_XX_XX_XX a2dp-sink
```

### Microphone Not Working

```bash
# Check source
pactl list sources

# Unmute
pactl set-source-mute @DEFAULT_SOURCE@ 0

# Check capture device
arecord -l
```

### OBS Can't Capture Audio

1. Ensure PipeWire capture source is selected
2. Check `game-audio` monitor exists: `pactl list sources | grep game-audio`
3. Restart OBS after creating virtual sinks

## Quick Reference

### Essential Commands

| Task | Command |
|------|---------|
| List sinks | `pactl list sinks short` |
| List sources | `pactl list sources short` |
| Set default sink | `pactl set-default-sink <name>` |
| Move app to sink | `pactl move-sink-input <id> <sink>` |
| Set volume | `wpctl set-volume <sink> 0.5` |
| Mute | `wpctl set-mute <sink> toggle` |
| Restart PipeWire | `systemctl --user restart pipewire` |

### Tools

| Tool | Purpose |
|------|---------|
| `qpwgraph` | Visual audio routing |
| `helvum` | Patchbay for PipeWire |
| `pavucontrol` | Volume control GUI |
| `easyeffects` | Audio effects |
| `wpctl` | WirePlumber CLI |

## Resources

- [PipeWire Documentation](https://docs.pipewire.org/)
- [Arch Wiki PipeWire](https://wiki.archlinux.org/title/PipeWire)
- [WirePlumber Documentation](https://pipewire.pages.freedesktop.org/wireplumber/)
- [EasyEffects Wiki](https://github.com/wwmm/easyeffects/wiki)