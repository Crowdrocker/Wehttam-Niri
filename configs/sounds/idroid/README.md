# iDroid Sound Pack

This directory contains iDroid/Metal Gear Solid voice clips for the gaming mode of WehttamSnaps-SwayFx.

## Required Sound Files

Place the following `.wav` or `.mp3` files in this directory:

| Filename | Purpose | Context |
|----------|---------|---------|
| `startup.wav` | Gaming mode activated | Played when switching to gaming workspace |
| `gamemode-on.wav` | GameMode enabled | Performance mode engaged |
| `gamemode-off.wav` | GameMode disabled | Returning to desktop |
| `screenshot.wav` | Screenshot captured | In-game screenshot |
| `recording-start.wav` | Recording started | Gameplay capture |
| `recording-stop.wav` | Recording stopped | End of capture |
| `notification.wav` | Gaming notification | Party invite, achievement, etc. |
| `error.wav` | Error occurred | Game crash, disconnect |
| `mission-start.wav` | Game launched | Starting a game session |
| `mission-complete.wav` | Game closed | Gaming session ended |

## Sourcing iDroid Sounds

### Option 1: Text-to-Speech Generation (Recommended)

Use a TTS system with robotic/synthetic characteristics:

```bash
# Using Piper TTS with a more robotic voice
pip install piper-tts
piper --model en_US-ryan-medium --output_file startup.wav \
  "Tactical mode engaged. All systems optimized for combat effectiveness."

# Using espeak for robotic effect
espeak -v en-us -s 150 -p 50 -w startup.wav \
  "Gaming mode initialized. Ready for deployment."

# Apply robotic effects with SoX
sox startup.wav startup-robotic.wav pitch -200 reverb 50 50 50
```

### Option 2: Synthesize with Festival/eSpeak

```bash
# Festival TTS (more robotic)
echo "Gaming mode online. All systems nominal." | \
  text2wave -o gaming-mode.wav

# eSpeak with effects
espeak -v en-us -s 140 -p 60 -a 150 -w output.wav \
  "Mission parameters loaded. Good luck, Snake."
```

### Option 3: Extract from Games

If you own Metal Gear Solid V, you can extract iDroid audio:

**Note:** Only extract audio from games you legally own for personal use.

## Custom Messages

Create tactical-style messages for gaming:

```
startup.wav:        "Tactical mode engaged. Systems optimized for deployment."
gamemode-on.wav:    "Performance protocols active. Frame optimization engaged."
screenshot.wav:     "Intel captured. Data saved to archives."
recording-start.wav: "Recording initiated. All gameplay data being logged."
mission-start.wav:  "Mission parameters loaded. Good luck, operative."
```

## Format Recommendations

- **Format:** WAV (PCM) or OGG for lower file size
- **Sample Rate:** 48000 Hz
- **Bit Depth:** 16-bit
- **Channels:** Mono
- **Duration:** Keep under 2 seconds for quick feedback

## Applying Robotic Effects

Use SoX (Sound eXchange) to add robotic effects to any TTS output:

```bash
# Install SoX
sudo pacman -S sox

# Add robotic effects
sox input.wav output.wav \
  pitch -300 \
  reverb 30 75 60 \
  echo 0.5 0.5 10 0.5 \
  speed 1.1

# Add radio/static effect
sox input.wav output.wav \
  synth whitenoise create 0 0 2 \
  fade 0.01 0 0.01 \
  remix 1,2 \
  vol 0.3
```

## Testing Sounds

```bash
# Test a sound file
paplay gamemode-on.wav

# With volume adjustment
paplay --volume=50000 gamemode-on.wav
```

## Integration

The sounds are played by:
- `~/.config/sway/scripts/sound-system` - Main sound controller
- `~/.config/sway/scripts/toggle-gamemode.sh` - Mode switching

When you switch to gaming workspace (Super+3) or enable GameMode, the system automatically switches from J.A.R.V.I.S. to iDroid sounds.