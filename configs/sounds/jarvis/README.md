# J.A.R.V.I.S. Sound Pack

This directory contains J.A.R.V.I.S. voice clips for the work/productivity mode of WehttamSnaps-SwayFx.

## Required Sound Files

Place the following `.wav` or `.mp3` files in this directory:

| Filename | Purpose | Context |
|----------|---------|---------|
| `startup.wav` | System boot complete | Played when SwayFx starts |
| `shutdown.wav` | System shutdown | Played on logout/shutdown |
| `workspace-switch.wav` | Workspace change | Optional subtle notification |
| `screenshot.wav` | Screenshot captured | Visual feedback |
| `recording-start.wav` | OBS recording started | Streaming/recording mode |
| `recording-stop.wav` | OBS recording stopped | End of capture |
| `gamemode-on.wav` | Gaming mode activated | Not used in J.A.R.V.I.S. mode |
| `gamemode-off.wav` | Gaming mode deactivated | Not used in J.A.R.V.I.S. mode |
| `notification.wav` | General notification | For important alerts |
| `welcome.wav` | Session greeting | Personalized welcome message |
| `error.wav` | Error occurred | Something went wrong |
| `success.wav` | Task completed | Operation successful |

## Sourcing J.A.R.V.I.S. Sounds

### Option 1: Text-to-Speech Generation (Recommended)

Use a high-quality TTS system with Paul Bettany's voice characteristics:

```bash
# Using Piper TTS (offline, free)
pip install piper-tts
piper --model en_US-lessac-medium --output_file startup.wav \
  "Good evening. All systems are online and ready for your command."

# Using ElevenLabs (paid, high quality)
# Upload to their platform and generate with a similar voice

# Using Coqui TTS (open source)
pip install TTS
tts --text "Welcome back, Matthew. Systems operational." \
    --out_path welcome.wav
```

### Option 2: Extract from Media

If you own Marvel media, you can extract audio clips for personal use:

```bash
# Using ffmpeg to extract audio clips
ffmpeg -i "source.mp4" -ss 00:05:23 -t 5 -vn -acodec pcm_s16ar startup.wav
```

**Note:** Only use audio you have legal rights to for personal use.

### Option 3: Community Sound Packs

Search for "JARVIS sound pack" on community sites like:
- Reddit r/unixporn
- DeviantArt
- SoundCloud

**Always respect copyright and use sounds you have rights to.**

## Custom Messages

Consider creating custom messages for your workflow:

```
startup.wav:     "Good evening, Matthew. WehttamSnaps systems are online."
welcome.wav:     "Welcome back. Your photography workstation is ready."
screenshot.wav:  "Image captured and saved."
error.wav:       "I'm afraid I've encountered an error, sir."
```

## Format Recommendations

- **Format:** WAV (PCM) for lowest latency
- **Sample Rate:** 44100 Hz or 48000 Hz
- **Bit Depth:** 16-bit
- **Channels:** Mono (for notifications) or Stereo (for ambiance)
- **Duration:** Keep under 3 seconds for UI sounds

## Testing Sounds

```bash
# Test a sound file
paplay startup.wav

# Or with mpv
mpv --no-video startup.wav
```

## Integration

The sounds are played by the `sound-system` script located in:
`~/.config/sway/scripts/sound-system`

Mode switching is handled by `toggle-gamemode.sh`.