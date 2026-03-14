# WehttamSnaps Troubleshooting Guide

A comprehensive troubleshooting guide for the WehttamSnaps Niri setup, covering common issues and their solutions.

## Table of Contents

- [Niri Issues](#niri-issues)
- [Display & Graphics](#display--graphics)
- [Audio Problems](#audio-problems)
- [Input Devices](#input-devices)
- [Gaming Issues](#gaming-issues)
- [Application Problems](#application-problems)
- [Performance Issues](#performance-issues)
- [System Recovery](#system-recovery)

## Niri Issues

### Niri Won't Start

**Symptoms:** Niri fails to launch from login manager or tty.

**Solutions:**

1. Check if Niri is installed:
   ```bash
   which niri
   niri --version
   ```

2. Check for configuration errors:
   ```bash
   niri validate
   ```

3. Run Niri from TTY to see errors:
   ```bash
   # Switch to TTY (Ctrl+Alt+F2)
   niri
   ```

4. Check configuration syntax:
   ```bash
   # Validate KDL syntax
   cat ~/.config/niri/config.kdl
   ```

### Niri Crashes on Startup

**Symptoms:** Niri starts but immediately crashes.

**Solutions:**

1. Check for conflicting applications:
   ```bash
   # Kill any running Wayland compositors
   pkill -9 sway
   pkill -9 hyprland
   ```

2. Check environment variables:
   ```bash
   echo $XDG_SESSION_TYPE  # Should be wayland
   echo $WAYLAND_DISPLAY   # Should be wayland-0 or similar
   ```

3. Reset configuration:
   ```bash
   mv ~/.config/niri ~/.config/niri.backup
   niri  # Will use default config
   ```

### Keybindings Not Working

**Symptoms:** Keyboard shortcuts don't respond.

**Solutions:**

1. Check Niri is receiving input:
   ```bash
   niri msg action focus-column-left
   ```

2. Verify keybinding syntax in config:
   ```bash
   grep -A5 "Mod" ~/.config/niri/config.kdl
   ```

3. Check for keyboard grab by other apps:
   ```bash
   # Some apps may grab keyboard focus
   # Close any fullscreen apps and try again
   ```

### Workspace Not Switching

**Symptoms:** Can't switch between workspaces.

**Solutions:**

1. Check workspace count:
   ```bash
   niri msg workspaces
   ```

2. Try numeric switch:
   ```bash
   niri msg action focus-workspace 1
   ```

3. Verify workspace configuration:
   ```bash
   cat ~/.config/niri/conf.d/30-workspaces.kdl
   ```

## Display & Graphics

### Screen Tearing

**Symptoms:** Horizontal lines or tearing during motion.

**Solutions:**

1. Enable VSync in Niri config:
   ```kdl
   // In 00-base.kdl
   environment {
       "WLR_RENDERER" "vulkan"
   }
   ```

2. Check monitor refresh rate:
   ```bash
   wlr-randr
   ```

3. For games, use gamescope:
   ```bash
   gamescope --vsync 1 %command%
   ```

### Wrong Resolution

**Symptoms:** Display shows incorrect resolution.

**Solutions:**

1. List available modes:
   ```bash
   wlr-randr
   ```

2. Set custom resolution in Niri config:
   ```kdl
   output "eDP-1" {
       mode "1920x1080"
       scale 1.0
   }
   ```

### Multiple Monitors Not Detected

**Symptoms:** Second monitor not showing.

**Solutions:**

1. Check physical connection
2. List outputs:
   ```bash
   wlr-randr
   ```

3. Reload Niri:
   ```bash
   niri msg action reload-config
   ```

### Wallpaper Not Displaying

**Symptoms:** swww wallpaper doesn't show.

**Solutions:**

1. Check swww is running:
   ```bash
   pgrep swww
   ```

2. Manually set wallpaper:
   ```bash
   swww img /path/to/wallpaper.png
   ```

3. Check wallpaper path:
   ```bash
   ls -la ~/Pictures/Wallpapers/
   ```

### AMD GPU Not Recognized

**Symptoms:** RX 580 not detected or using wrong driver.

**Solutions:**

1. Check kernel modules:
   ```bash
   lsmod | grep amdgpu
   ```

2. Check dmesg for errors:
   ```bash
   dmesg | grep -i amdgpu | tail -20
   ```

3. Verify Vulkan:
   ```bash
   vulkaninfo | grep deviceName
   ```

## Audio Problems

### No Sound Output

**Symptoms:** Speakers/headphones produce no sound.

**Solutions:**

1. Check PipeWire status:
   ```bash
   systemctl --user status pipewire pipewire-pulse
   ```

2. Check volumes:
   ```bash
   wpctl status
   wpctl get-volume @DEFAULT_AUDIO_SINK@
   ```

3. Restart PipeWire:
   ```bash
   systemctl --user restart pipewire pipewire-pulse wireplumber
   ```

4. Check for muted output:
   ```bash
   wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
   ```

### Microphone Not Working

**Symptoms:** Microphone not capturing audio.

**Solutions:**

1. Check input devices:
   ```bash
   arecord -l
   wpctl status
   ```

2. Set correct input:
   ```bash
   wpctl set-default <device-id>
   ```

3. Test microphone:
   ```bash
   arecord -d 5 test.wav && aplay test.wav
   ```

### Audio Latency Issues

**Symptoms:** Audio delay or out of sync.

**Solutions:**

1. Adjust quantum size:
   ```bash
   pw-metadata -n settings 0 clock.force-quantum 256
   ```

2. Check for CPU throttling:
   ```bash
   cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
   ```

### Audio Crackling

**Symptoms:** Popping or crackling sounds.

**Solutions:**

1. Increase buffer size:
   ```bash
   pw-metadata -n settings 0 clock.force-quantum 1024
   ```

2. Check for IRQ conflicts:
   ```bash
   cat /proc/interrupts | grep -i audio
   ```

## Input Devices

### Keyboard Layout Wrong

**Symptoms:** Keys type wrong characters.

**Solutions:**

1. Set keyboard layout:
   ```bash
   localectl set-x11-keymap us
   ```

2. In Niri config:
   ```kdl
   input {
       keyboard {
           xkb-layout "us"
       }
   }
   ```

### Mouse Not Working

**Symptoms:** Mouse cursor doesn't move or click.

**Solutions:**

1. Check device is detected:
   ```bash
   cat /proc/bus/input/devices | grep -i mouse
   ```

2. Check libinput:
   ```bash
   libinput list-devices
   ```

### Touchpad Gestures Not Working

**Symptoms:** Touchpad gestures don't trigger actions.

**Solutions:**

1. Check touchpad configuration:
   ```bash
   libinput list-devices | grep -A20 Touchpad
   ```

2. Enable in Niri config:
   ```kdl
   input {
       touchpad {
           tap true
           natural-scroll true
           dwt true
       }
   }
   ```

## Gaming Issues

### Game Won't Launch

**Symptoms:** Steam game exits immediately.

**Solutions:**

1. Try different Proton version
2. Check Proton logs:
   ```bash
   cat ~/.steam/steam/logs/proton_log.txt
   ```

3. Verify game files in Steam

### Low FPS in Games

**Symptoms:** Games run poorly.

**Solutions:**

1. Enable GameMode:
   ```bash
   gamemoded -a
   ```

2. Check GPU utilization:
   ```bash
   radeontop
   ```

3. Verify drivers:
   ```bash
   glxinfo | grep "OpenGL renderer"
   vulkaninfo | grep deviceName
   ```

### Steam Not Starting

**Symptoms:** Steam crashes or won't open.

**Solutions:**

1. Clear Steam cache:
   ```bash
   rm -rf ~/.steam/steam/appcache
   ```

2. Reset Steam:
   ```bash
   steam --reset
   ```

3. Check for Wayland issues:
   ```bash
   SDL_VIDEODRIVER=wayland steam
   ```

### Wine/Proton Errors

**Symptoms:** Wine applications crash.

**Solutions:**

1. Reinstall Wine:
   ```bash
   sudo pacman -S wine winetricks
   ```

2. Create fresh prefix:
   ```bash
   WINEPREFIX=~/.wine-test winecfg
   ```

## Application Problems

### Firefox Not Starting

**Solutions:**

```bash
firefox --ProfileManager
rm -rf ~/.mozilla/firefox/*.default/lock
```

### OBS Not Capturing Screen

**Solutions:**

1. Use PipeWire capture source
2. Install required portal:
   ```bash
   sudo pacman -S xdg-desktop-portal-wlr
   ```

### Fuzzel Not Showing

**Symptoms:** Launcher doesn't appear.

**Solutions:**

1. Run fuzzel manually:
   ```bash
   fuzzel &
   ```

2. Check for errors:
   ```bash
   fuzzel --log-level=debug
   ```

### Notification Not Appearing

**Symptoms:** Mako notifications not showing.

**Solutions:**

1. Check mako is running:
   ```bash
   pgrep mako
   ```

2. Start mako:
   ```bash
   mako &
   ```

3. Test notification:
   ```bash
   notify-send "Test" "Notification test"
   ```

## Performance Issues

### High CPU Usage

**Symptoms:** System sluggish, high CPU.

**Solutions:**

1. Check running processes:
   ```bash
   htop
   btop
   ```

2. Check for runaway process:
   ```bash
   ps aux --sort=-%cpu | head -10
   ```

3. Disable startup apps:
   ```bash
   ls ~/.config/autostart/
   ```

### High Memory Usage

**Symptoms:** Running out of RAM.

**Solutions:**

1. Check memory usage:
   ```bash
   free -h
   ```

2. Find memory hogs:
   ```bash
   ps aux --sort=-%mem | head -10
   ```

3. Clear caches:
   ```bash
   sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
   ```

### System Overheating

**Symptoms:** System thermal throttling.

**Solutions:**

1. Check temperatures:
   ```bash
   sensors
   ```

2. Check fan speeds:
   ```bash
   sensors | grep fan
   ```

3. Clean dust from fans/heatsink

## System Recovery

### Niri Completely Broken

**Recovery Steps:**

1. Switch to TTY (Ctrl+Alt+F2)
2. Backup config:
   ```bash
   mv ~/.config/niri ~/.config/niri.broken
   ```
3. Use default config or restore backup:
   ```bash
   cp -r ~/.config-backup-*/niri ~/.config/
   ```

### Forgot Keybindings

**Quick Reference:**

Press `Mod+?` to show keybindings cheat sheet, or:

| Action | Keybinding |
|--------|-----------|
| Open Launcher | Mod+Space |
| Terminal | Mod+Enter |
| Close Window | Mod+Q |
| Switch Workspace | Mod+1-9 |
| Toggle GameMode | Mod+G |
| Screenshot | Mod+P |
| Volume Up | Mod+Plus |
| Volume Down | Mod+Minus |

### Reset to Defaults

**Complete Reset:**

```bash
# Backup current config
mv ~/.config/niri ~/.config/niri.backup.$(date +%s)
mv ~/.config/wehttamsnaps ~/.config/wehttamsnaps.backup.$(date +%s)

# Reinstall
cd /path/to/wehttamsnaps-niri
./install.sh --config
```

### Boot to Emergency Shell

If system won't boot:

1. Hold Shift during boot (for GRUB)
2. Press 'e' to edit
3. Add `init=/bin/bash` to kernel line
4. Boot with Ctrl+X
5. Remount root:
   ```bash
   mount -o remount,rw /
   ```

## Diagnostic Commands

### System Information

```bash
# System info
neofetch
uname -a

# Hardware info
lspci
lsusb
lscpu

# Memory
free -h
cat /proc/meminfo

# Disk usage
df -h
```

### Graphics Diagnostics

```bash
# GPU info
lspci | grep -i vga
lspci -k | grep -A 2 -i "VGA"

# OpenGL
glxinfo | head -20

# Vulkan
vulkaninfo --summary

# DRM info
drminfo
```

### Audio Diagnostics

```bash
# PipeWire status
systemctl --user status pipewire

# Audio devices
wpctl status
pactl list short sinks

# Audio graph
pw-dot
```

### Process Diagnostics

```bash
# Running processes
ps aux

# System calls
strace -p <pid>

# Open files
lsof | grep <process>

# Network connections
ss -tulpn
```

## Getting Help

### Log Files

```bash
# System logs
journalctl -b

# Niri logs
journalctl -b | grep niri

# PipeWire logs
journalctl --user -u pipewire

# Xorg logs (if using XWayland)
cat /var/log/Xorg.0.log
```

### Reporting Issues

When reporting issues, include:

1. System information:
   ```bash
   neofetch
   ```

2. Niri version:
   ```bash
   niri --version
   ```

3. Relevant logs:
   ```bash
   journalctl -b | grep -i niri > niri-log.txt
   ```

4. Configuration files:
   ```bash
   tar -czf niri-config.tar.gz ~/.config/niri
   ```

### Useful Resources

- [Niri GitHub](https://github.com/YaLTeR/niri)
- [Arch Wiki - Niri](https://wiki.archlinux.org/title/Niri)
- [Arch Wiki - Wayland](https://wiki.archlinux.org/title/Wayland)
- [AMDGPU Wiki](https://wiki.archlinux.org/title/AMDGPU)
- [PipeWire Wiki](https://wiki.archlinux.org/title/PipeWire)

### Community

- **GitHub:** [Crowdrocker](https://github.com/Crowdrocker)
- **Twitch:** [WehttamSnaps](https://twitch.tv/WehttamSnaps)
- **YouTube:** [WehttamSnaps](https://youtube.com/@WehttamSnaps)