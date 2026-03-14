# WehttamSnaps — Installation Guide

> Detailed step-by-step for setting up the full WehttamSnaps Arch Linux Niri workstation.  
> For the fast path see [QUICKSTART.md](QUICKSTART.md).  
> Author: Matthew — [github.com/Crowdrocker](https://github.com/Crowdrocker)

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Clone the Repo](#2-clone-the-repo)
3. [Run the Installer](#3-run-the-installer)
4. [Manual Install (step by step)](#4-manual-install-step-by-step)
   - 4.1 [Install paru (AUR helper)](#41-install-paru-aur-helper)
   - 4.2 [Install packages](#42-install-packages)
   - 4.3 [Create directories](#43-create-directories)
   - 4.4 [Deploy scripts](#44-deploy-scripts)
   - 4.5 [Install configs](#45-install-configs)
   - 4.6 [Set up sound system](#46-set-up-sound-system)
   - 4.7 [Configure shell](#47-configure-shell)
   - 4.8 [Set up systemd services](#48-set-up-systemd-services)
   - 4.9 [Gaming mode sudoers rule](#49-gaming-mode-sudoers-rule)
   - 4.10 [Steam library](#410-steam-library)
5. [Sound Pack Setup](#5-sound-pack-setup)
6. [Voice Activation Setup](#6-voice-activation-setup)
7. [First Boot Checklist](#7-first-boot-checklist)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. Prerequisites

Before running anything, make sure you have:

- **Arch Linux** installed and booting (CachyOS is also supported)
- **Niri** installed and working as your Wayland compositor
- An internet connection
- Your user account set up (do **not** run as root)
- Your 1TB gaming SSD mounted at `/run/media/wehttamsnaps/LINUXDRIVE`

Check Niri is working:
```bash
niri --version
# Should print: niri 0.x.x
```

If Niri is not yet installed:
```bash
paru -S niri xdg-desktop-portal-gnome
```

---

## 2. Clone the Repo

```bash
git clone https://github.com/Crowdrocker/wehttamsnaps.git
cd wehttamsnaps
```

If you don't have git yet:
```bash
sudo pacman -S git
```

---

## 3. Run the Installer

The one-command path — does everything automatically:

```bash
chmod +x install.sh
./install.sh
```

This runs all steps in order:
1. Preflight checks (Arch, non-root, paru)
2. Package installation via pacman + paru
3. Directory scaffold
4. Script deployment to `~/.config/wehttamsnaps/scripts/` and `/usr/local/bin/`
5. Config files (Niri, Rofi, Dunst, GTK)
6. Sound directory scaffold + README files
7. Systemd user service for voice activation
8. Shell integration (`.bashrc`)
9. Steam library verification
10. Sudoers rule for gaming mode CPU governor

You can also run individual sections:

```bash
./install.sh packages    # packages only
./install.sh configs     # configs only
./install.sh scripts     # scripts only
./install.sh sounds      # sound dirs only
./install.sh services    # systemd services only
./install.sh shell       # .bashrc integration only
./install.sh sudoers     # gaming mode sudoers rule only
```

---

## 4. Manual Install (step by step)

Follow this if you prefer full control or want to understand what each step does.

### 4.1 Install paru (AUR helper)

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git /tmp/paru-install
cd /tmp/paru-install
makepkg -si --noconfirm
cd ~
```

Verify:
```bash
paru --version
```

### 4.2 Install packages

**Core compositor and shell:**
```bash
sudo pacman -S --needed \
    niri xdg-desktop-portal-gnome xdg-desktop-portal \
    dbus polkit polkit-gnome \
    ghostty waybar dunst libnotify \
    rofi-wayland swww grim slurp swaylock \
    wl-clipboard cliphist
```

**Applications:**
```bash
sudo pacman -S --needed \
    thunar dolphin gvfs gvfs-mtp tumbler \
    firefox kate btop bat eza fd ripgrep fzf glow jq \
    mpv ffmpeg brightnessctl lm_sensors \
    python python-gobject gtk3
```

**AUR applications:**
```bash
paru -S --needed brave-bin protonup-qt
```

**Fonts:**
```bash
paru -S --needed \
    ttf-share-tech-mono ttf-rajdhani ttf-fira-code \
    noto-fonts noto-fonts-emoji ttf-font-awesome
```

**Theming:**
```bash
paru -S --needed \
    adw-gtk3 bibata-cursor-theme papirus-icon-theme \
    kvantum qt5ct qt6ct
```

**Audio:**
```bash
sudo pacman -S --needed \
    pipewire pipewire-audio pipewire-pulse pipewire-jack \
    wireplumber pavucontrol qpwgraph playerctl pamixer
```

**Gaming:**
```bash
sudo pacman -S --needed \
    steam lutris gamemode lib32-gamemode gamescope \
    mangohud lib32-mangohud wine-staging winetricks \
    protontricks vkbasalt lib32-vkbasalt
```

**Photography:**
```bash
sudo pacman -S --needed \
    darktable gimp krita digikam perl-image-exiftool
```

**Streaming:**
```bash
sudo pacman -S --needed obs-studio
```

### 4.3 Create directories

```bash
# User config dirs
mkdir -p ~/.config/wehttamsnaps/{scripts,docs,wallpapers,themes,widgets,webapps}
mkdir -p ~/.config/niri
mkdir -p ~/.config/rofi/themes
mkdir -p ~/.config/systemd/user
mkdir -p ~/.cache/wehttamsnaps
mkdir -p ~/Pictures/Screenshots

# System sound dirs (requires sudo)
sudo mkdir -p /usr/share/wehttamsnaps/sounds/{jarvis,idroid}
sudo chown -R "$USER:$USER" /usr/share/wehttamsnaps
```

### 4.4 Deploy scripts

**Scripts to `~/.config/wehttamsnaps/scripts/`:**
```bash
cp scripts/jarvis-ai.sh          ~/.config/wehttamsnaps/scripts/
cp scripts/jarvis-ai-aliases.sh  ~/.config/wehttamsnaps/scripts/
cp scripts/jarvis-manager.sh     ~/.config/wehttamsnaps/scripts/
cp scripts/voice-engine.sh       ~/.config/wehttamsnaps/scripts/
cp scripts/voice-activation.sh   ~/.config/wehttamsnaps/scripts/
cp scripts/toggle-gamemode.sh    ~/.config/wehttamsnaps/scripts/
cp scripts/power-menu.sh         ~/.config/wehttamsnaps/scripts/
cp scripts/wallpaper-browser.sh  ~/.config/wehttamsnaps/scripts/
cp scripts/wehttamsnaps-keyhints.sh ~/.config/wehttamsnaps/scripts/
cp scripts/KeyHints.sh           ~/.config/wehttamsnaps/scripts/
cp apps/wehttamsnaps-welcome.py  ~/.config/wehttamsnaps/scripts/
chmod +x ~/.config/wehttamsnaps/scripts/*
```

**Scripts to `/usr/local/bin/` (callable from Niri keybinds):**
```bash
sudo cp scripts/jarvis      /usr/local/bin/jarvis
sudo cp scripts/jarvis-menu /usr/local/bin/jarvis-menu
sudo cp scripts/sound-system /usr/local/bin/sound-system
sudo chmod +x /usr/local/bin/jarvis /usr/local/bin/jarvis-menu /usr/local/bin/sound-system
```

**Copy wallpaper:**
```bash
cp wallpapers/Wall.jpg ~/.config/wehttamsnaps/wallpapers/Wall.jpg
```

### 4.5 Install configs

**Niri compositor config:**
```bash
# Back up any existing config first
[[ -f ~/.config/niri/config.kdl ]] && \
    cp ~/.config/niri/config.kdl ~/.config/niri/config.kdl.bak

cp configs/niri/config.kdl ~/.config/niri/config.kdl
```

**Rofi theme:**
```bash
cp configs/rofi/wehttamsnaps.rasi ~/.config/rofi/themes/wehttamsnaps.rasi
cp configs/rofi/config.rasi       ~/.config/rofi/config.rasi
```

**Dunst notifications:**
```bash
mkdir -p ~/.config/dunst
# Dunst config is generated by install.sh — or copy from docs/dunstrc
```

**GTK theme:**
```bash
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=adw-gtk3-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Rajdhani SemiBold 11
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

cat > ~/.config/gtk-4.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=adw-gtk3-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Rajdhani SemiBold 11
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF
```

**Reload Niri:**
```bash
niri msg action reload-config
```

### 4.6 Set up sound system

```bash
# Verify sound dirs exist
ls /usr/share/wehttamsnaps/sounds/jarvis/
ls /usr/share/wehttamsnaps/sounds/idroid/

# Check what's expected
cat /usr/share/wehttamsnaps/sounds/jarvis/README.md
cat /usr/share/wehttamsnaps/sounds/idroid/README.md

# Test once sounds are in place
sound-system test
```

See [Section 5](#5-sound-pack-setup) for downloading the sound packs.

### 4.7 Configure shell

Add to `~/.bashrc` (or `~/.zshrc`):

```bash
# ── WehttamSnaps JARVIS Integration ──
source "$HOME/.config/wehttamsnaps/scripts/jarvis-ai.sh"
source "$HOME/.config/wehttamsnaps/scripts/jarvis-ai-aliases.sh"

# Aliases
alias update='paru -Syu --noconfirm && paru -Sc --noconfirm'
alias gaming='~/.config/wehttamsnaps/scripts/toggle-gamemode.sh'
alias stream='obs &'
alias audio='pavucontrol &'
alias keyhints='~/.config/wehttamsnaps/scripts/KeyHints.sh'
alias welcome='python3 ~/.config/wehttamsnaps/scripts/wehttamsnaps-welcome.py --force'
alias niri-reload='niri msg action reload-config'
alias sound-test='sound-system test'
```

Then reload:
```bash
source ~/.bashrc
```

### 4.8 Set up systemd services

**Voice activation service:**
```bash
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/jarvis-voice.service << EOF
[Unit]
Description=J.A.R.V.I.S. Voice Activation (Vosk offline STT)
After=pipewire.service sound.target

[Service]
Type=simple
ExecStart=$HOME/.config/wehttamsnaps/scripts/voice-activation.sh start-listener
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
```

> Do **not** enable this yet — complete voice activation setup first (Section 6).

### 4.9 Gaming mode sudoers rule

Allows the gaming mode script to change the CPU governor without a password prompt:

```bash
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor" | \
    sudo tee /etc/sudoers.d/wehttamsnaps-gamemode
sudo chmod 440 /etc/sudoers.d/wehttamsnaps-gamemode
```

Verify:
```bash
sudo visudo -c -f /etc/sudoers.d/wehttamsnaps-gamemode
# Should print: /etc/sudoers.d/wehttamsnaps-gamemode: parsed OK
```

### 4.10 Steam library

Mount your LINUXDRIVE and verify the paths:

```bash
ls /run/media/wehttamsnaps/LINUXDRIVE/
# Should show: SteamLibrary/  Modlist_Packs/  Modlist_Downloads/
```

Add the Steam library in Steam:
**Steam → Settings → Storage → Add Drive → `/run/media/wehttamsnaps/LINUXDRIVE/SteamLibrary`**

---

## 5. Sound Pack Setup

The sound system needs mp3 files placed in the right directories with the right names.

### Download

1. Go to [101soundboards.com/boards/10155](https://www.101soundboards.com/boards/10155) (J.A.R.V.I.S.)
2. Go to [101soundboards.com/boards/10060](https://www.101soundboards.com/boards/10060) (iDroid)
3. Download the clips you want

### Place files

```bash
# J.A.R.V.I.S. sounds
cp your-downloads/*.mp3 /usr/share/wehttamsnaps/sounds/jarvis/

# iDroid sounds
cp your-downloads/*.mp3 /usr/share/wehttamsnaps/sounds/idroid/
```

### Required filenames

See the README in each sound directory for the full list:
```bash
cat /usr/share/wehttamsnaps/sounds/jarvis/README.md
cat /usr/share/wehttamsnaps/sounds/idroid/README.md
```

Key files needed to start:

```
jarvis/
  jarvis-startup.mp3
  jarvis-shutdown.mp3
  morning.mp3  /  afternoon.mp3  /  evening.mp3
  jarvis-notification.mp3
  workspace-switch.mp3
  jarvis-screen-capture.mp3
  closing-window.mp3
  audio-mute.mp3  /  audio-unmute.mp3
  volume-up.mp3  /  volume-down.mp3

idroid/
  gamemode-on.mp3
  gamemode-off.mp3
  steam-launch.mp3
```

### Test

```bash
sound-system test
# Plays all sounds in sequence

sound-system startup
# Test the startup greeting
```

---

## 6. Voice Activation Setup

Optional — adds "Hey Jarvis" wake-word detection using offline Vosk STT.

```bash
# Install Python dependencies
pip install --user vosk sounddevice

# Download the Vosk model (~40MB) and create the systemd service
~/.config/wehttamsnaps/scripts/voice-activation.sh setup

# Test your microphone
~/.config/wehttamsnaps/scripts/voice-activation.sh test-mic

# Run manually first to verify it works
~/.config/wehttamsnaps/scripts/voice-activation.sh start-listener
# Say "Hey Jarvis" — you should see: ✓ Wake word detected!

# Enable as background service
systemctl --user enable --now jarvis-voice.service

# Check logs
journalctl --user -u jarvis-voice.service -f
```

Troubleshooting:
```bash
# Mic not working?
pavucontrol   # Check input levels
arecord -d 3 -f cd /tmp/test.wav && aplay /tmp/test.wav

# Service not starting?
systemctl --user status jarvis-voice.service
journalctl --user -u jarvis-voice.service -n 50
```

---

## 7. First Boot Checklist

After install, go through these in order:

```
[ ] niri msg action reload-config        reload Niri config
[ ] source ~/.bashrc                      get aliases live
[ ] sound-system test                     verify all sounds play
[ ] Super+H                               open keybind cheatsheet
[ ] Super+Space                           test app launcher
[ ] Super+G                               test gaming mode toggle
[ ] Super+G again                         deactivate gaming mode
[ ] Super+Print                           test screenshot + sound
[ ] j "hello"                            test JARVIS AI
[ ] toggle-gamemode.sh status            check system state
```

---

## 8. Troubleshooting

### Niri won't start

```bash
# Check logs
journalctl --user -u niri -n 50
# Or start manually to see errors:
niri
```

### Rofi theme not loading

```bash
# Verify theme file exists
ls ~/.config/rofi/themes/wehttamsnaps.rasi

# Test directly
rofi -show drun -theme ~/.config/rofi/themes/wehttamsnaps.rasi

# Check config
cat ~/.config/rofi/config.rasi
```

### Sounds not playing

```bash
# Check files exist
ls /usr/share/wehttamsnaps/sounds/jarvis/
ls /usr/share/wehttamsnaps/sounds/idroid/

# Check mpv is installed
which mpv

# Test manually
mpv --no-video /usr/share/wehttamsnaps/sounds/jarvis/jarvis-startup.mp3

# Check PipeWire
systemctl --user status pipewire wireplumber
```

### Gaming mode not changing CPU governor

```bash
# Verify sudoers rule
sudo cat /etc/sudoers.d/wehttamsnaps-gamemode

# Test manually
echo "performance" | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Should print: performance

# Re-run sudoers setup
./install.sh sudoers
```

### Steam not finding LINUXDRIVE games

```bash
# Check drive is mounted
lsblk
ls /run/media/wehttamsnaps/LINUXDRIVE/

# If not mounted, mount manually (replace sdX1 with your device)
sudo mount /dev/sdX1 /run/media/wehttamsnaps/LINUXDRIVE

# Add fstab entry for auto-mount on boot
sudo blkid /dev/sdX1   # get UUID
# Then add to /etc/fstab:
# UUID=xxxx /run/media/wehttamsnaps/LINUXDRIVE ext4 defaults,nofail 0 2
```

### JARVIS AI aliases not working

```bash
# Check Gemini CLI is installed
which gemini

# Re-source manually
source ~/.config/wehttamsnaps/scripts/jarvis-ai.sh
source ~/.config/wehttamsnaps/scripts/jarvis-ai-aliases.sh

# Check .bashrc has the source lines
grep -n "WehttamSnaps" ~/.bashrc
```

### Waybar showing instead of Noctalia Shell

Waybar is the fallback bar. To switch to Noctalia-Shell when ready:

```bash
# Install Quickshell
paru -S quickshell-git

# Clone Noctalia-Shell
git clone https://github.com/niceguyhere/noctalia-shell ~/.config/Noctalia-Shell

# In config.kdl, uncomment the Noctalia-Shell autostart line
# and comment out the waybar line, then reload:
niri msg action reload-config
```

---

*WehttamSnaps — Photography · Gaming · Content Creation*  
*[github.com/Crowdrocker](https://github.com/Crowdrocker) · [twitch.tv/WehttamSnaps](https://twitch.tv/WehttamSnaps)*
