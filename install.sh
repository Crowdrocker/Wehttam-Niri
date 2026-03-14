#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║   WehttamSnaps — Arch Linux Niri Setup Installer               ║
# ║   Author  : Matthew (GitHub: Crowdrocker)                       ║
# ║   Twitch / YouTube : WehttamSnaps                               ║
# ║   Hardware: Dell XPS 8700 · i7-4790 · AMD RX 580 · 16GB        ║
# ╚══════════════════════════════════════════════════════════════════╝
#
# Usage:
#   chmod +x install.sh
#   ./install.sh            — full install
#   ./install.sh --help     — show options
#   ./install.sh packages   — only install packages
#   ./install.sh configs    — only copy configs
#   ./install.sh scripts    — only install scripts
#   ./install.sh sounds     — only scaffold sound dirs
#   ./install.sh services   — only enable systemd services

set -euo pipefail

# ══════════════════════════════════════════════════════════════════
# COLOURS
# ══════════════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ══════════════════════════════════════════════════════════════════
# PATHS
# ══════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"
USERNAME="$(whoami)"

CONFIG_DIR="$USER_HOME/.config/wehttamsnaps"
NIRI_DIR="$USER_HOME/.config/niri"
ROFI_DIR="$USER_HOME/.config/rofi"
SYSTEMD_DIR="$USER_HOME/.config/systemd/user"
SCRIPTS_DIR="$CONFIG_DIR/scripts"
SOUNDS_DIR="/usr/share/wehttamsnaps/sounds"
CACHE_DIR="$USER_HOME/.cache/wehttamsnaps"
DOCS_DIR="$CONFIG_DIR/docs"
WALLPAPER_DIR="$CONFIG_DIR/wallpapers"
SCREENSHOTS_DIR="$USER_HOME/Pictures/Screenshots"

VERSION="2.0.0"

# ══════════════════════════════════════════════════════════════════
# LOGGING
# ══════════════════════════════════════════════════════════════════

LOG_FILE="/tmp/wehttamsnaps-install.log"

log()  { echo -e "${CYAN}[INFO]${NC}  $*" | tee -a "$LOG_FILE"; }
ok()   { echo -e "${GREEN}[ OK ]${NC}  $*" | tee -a "$LOG_FILE"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $*" | tee -a "$LOG_FILE"; }
err()  { echo -e "${RED}[ERR ]${NC}  $*" | tee -a "$LOG_FILE"; }
step() { echo -e "\n${BOLD}${BLUE}══ $* ${NC}" | tee -a "$LOG_FILE"; }

# ══════════════════════════════════════════════════════════════════
# BANNER
# ══════════════════════════════════════════════════════════════════

print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
 ██╗    ██╗███████╗██╗  ██╗████████╗████████╗ █████╗ ███╗   ███╗
 ██║    ██║██╔════╝██║  ██║╚══██╔══╝╚══██╔══╝██╔══██╗████╗ ████║
 ██║ █╗ ██║█████╗  ███████║   ██║      ██║   ███████║██╔████╔██║
 ██║███╗██║██╔══╝  ██╔══██║   ██║      ██║   ██╔══██║██║╚██╔╝██║
 ╚███╔███╔╝███████╗██║  ██║   ██║      ██║   ██║  ██║██║ ╚═╝ ██║
  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝
  ███████╗███╗   ██╗ █████╗ ██████╗ ███████╗
  ██╔════╝████╗  ██║██╔══██╗██╔══██╗██╔════╝
  ███████╗██╔██╗ ██║███████║██████╔╝███████╗
  ╚════██║██║╚██╗██║██╔══██║██╔═══╝ ╚════██║
  ███████║██║ ╚████║██║  ██║██║     ███████║
  ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚══════╝
EOF
    echo -e "${NC}"
    echo -e "  ${BOLD}WehttamSnaps Niri Setup Installer v${VERSION}${NC}"
    echo -e "  ${CYAN}GitHub: github.com/Crowdrocker${NC}"
    echo -e "  ${CYAN}Twitch/YouTube: WehttamSnaps${NC}"
    echo -e "  ${CYAN}Hardware: Dell XPS 8700 · i7-4790 · AMD RX 580 · 16GB${NC}"
    echo ""
}

# ══════════════════════════════════════════════════════════════════
# PREFLIGHT CHECKS
# ══════════════════════════════════════════════════════════════════

preflight() {
    step "Preflight checks"

    # Must be Arch Linux
    if [[ ! -f /etc/arch-release ]]; then
        err "This installer is for Arch Linux only."
        exit 1
    fi
    ok "Arch Linux detected"

    # Must NOT run as root
    if [[ "$EUID" -eq 0 ]]; then
        err "Do not run as root. Run as your normal user."
        exit 1
    fi
    ok "Running as user: $USERNAME"

    # paru must be available (AUR helper)
    if ! command -v paru &>/dev/null; then
        warn "paru not found — installing paru AUR helper..."
        install_paru
    else
        ok "paru found: $(paru --version | head -1)"
    fi

    # Niri should be running (warn only — configs can be installed without it)
    if ! command -v niri &>/dev/null; then
        warn "niri not found in PATH — install niri first, then run this script"
        warn "  paru -S niri"
    else
        ok "niri found: $(niri --version)"
    fi

    # Create log file
    : > "$LOG_FILE"
    ok "Log file: $LOG_FILE"
}

install_paru() {
    log "Installing paru from AUR..."
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org/paru.git /tmp/paru-install
    cd /tmp/paru-install
    makepkg -si --noconfirm
    cd "$SCRIPT_DIR"
    ok "paru installed"
}

# ══════════════════════════════════════════════════════════════════
# PACKAGES
# ══════════════════════════════════════════════════════════════════

install_packages() {
    step "Installing packages"

    # ── Core compositor & shell ──────────────────────────────────
    PACMAN_PKGS=(
        # Niri + Wayland essentials
        niri
        xdg-desktop-portal-gnome
        xdg-desktop-portal
        dbus
        polkit
        polkit-gnome

        # Terminal
        ghostty

        # Bars & shell
        waybar
        # quickshell  ← install separately when Noctalia-Shell is ready

        # Notifications
        dunst
        libnotify

        # App launcher
        rofi-wayland

        # Wallpaper
        swww

        # Screenshot
        grim
        slurp

        # Screen lock
        swaylock

        # Clipboard
        wl-clipboard
        cliphist

        # File managers
        thunar
        dolphin
        gvfs
        gvfs-mtp
        tumbler          # Thunar thumbnails

        # Browsers
        brave-bin        # via AUR
        firefox

        # Terminal multiplexer / tools
        btop
        bat
        eza
        fd
        ripgrep
        fzf
        glow             # markdown viewer
        jq

        # Fonts — WehttamSnaps HUD theme
        ttf-share-tech-mono
        ttf-rajdhani
        ttf-fira-code
        noto-fonts
        noto-fonts-emoji
        ttf-font-awesome

        # Cursor
        bibata-cursor-theme

        # GTK theming
        adw-gtk3
        kvantum
        qt5ct
        qt6ct

        # Icon theme
        papirus-icon-theme

        # Audio — PipeWire stack
        pipewire
        pipewire-audio
        pipewire-pulse
        pipewire-jack
        wireplumber
        pavucontrol
        qpwgraph
        playerctl
        pamixer

        # Media playback
        mpv
        ffmpeg

        # Display brightness
        brightnessctl

        # System sensors
        lm_sensors

        # Python + GTK bindings (welcome screen)
        python
        python-gobject
        gtk3

        # Gaming
        steam
        lutris
        gamemode
        lib32-gamemode
        gamescope
        mangohud
        lib32-mangohud
        wine-staging
        winetricks
        protontricks
        vkbasalt
        lib32-vkbasalt

        # Photography
        darktable
        gimp
        krita
        digikam
        exiftool

        # Content creation
        obs-studio

        # Git
        git
        github-cli

        # Misc utils
        wget
        curl
        unzip
        p7zip
        htop
        neofetch
        inotify-tools    # used by watch-proton
        xorg-xwayland    # XWayland for non-Wayland apps
    )

    # ── AUR-only packages ────────────────────────────────────────
    AUR_PKGS=(
        brave-bin
        protonup-qt
        ttf-share-tech-mono
        ttf-rajdhani
        bibata-cursor-theme
        adw-gtk3
    )

    log "Installing pacman packages (this may take a while)..."
    # Filter out AUR-only from pacman list to avoid errors
    PACMAN_ONLY=()
    for pkg in "${PACMAN_PKGS[@]}"; do
        skip=0
        for aur in "${AUR_PKGS[@]}"; do
            [[ "$pkg" == "$aur" ]] && skip=1 && break
        done
        [[ $skip -eq 0 ]] && PACMAN_ONLY+=("$pkg")
    done

    sudo pacman -S --needed --noconfirm "${PACMAN_ONLY[@]}" 2>&1 | tee -a "$LOG_FILE" || \
        warn "Some pacman packages may have failed — check $LOG_FILE"

    log "Installing AUR packages via paru..."
    paru -S --needed --noconfirm "${AUR_PKGS[@]}" 2>&1 | tee -a "$LOG_FILE" || \
        warn "Some AUR packages may have failed — check $LOG_FILE"

    # ── Vosk (offline voice recognition for voice-activation.sh) ─
    log "Installing Python vosk + sounddevice for voice activation..."
    pip install --user vosk sounddevice 2>&1 | tee -a "$LOG_FILE" || \
        warn "vosk install failed — run: pip install --user vosk sounddevice"

    ok "Package installation complete"
}

# ══════════════════════════════════════════════════════════════════
# DIRECTORY SCAFFOLD
# ══════════════════════════════════════════════════════════════════

create_directories() {
    step "Creating directory structure"

    local dirs=(
        "$CONFIG_DIR"
        "$CONFIG_DIR/scripts"
        "$CONFIG_DIR/docs"
        "$CONFIG_DIR/wallpapers"
        "$CONFIG_DIR/themes"
        "$CONFIG_DIR/widgets"
        "$CONFIG_DIR/webapps"
        "$NIRI_DIR"
        "$ROFI_DIR/themes"
        "$SYSTEMD_DIR"
        "$CACHE_DIR"
        "$SCREENSHOTS_DIR"
        "$USER_HOME/Pictures"
        "$USER_HOME/.local/share/wehttamsnaps"
    )

    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        ok "Created: $dir"
    done

    # Sound dirs require sudo (under /usr/share)
    sudo mkdir -p "$SOUNDS_DIR/jarvis"
    sudo mkdir -p "$SOUNDS_DIR/idroid"
    sudo chown -R "$USERNAME:$USERNAME" "$SOUNDS_DIR" 2>/dev/null || true
    ok "Created: $SOUNDS_DIR/{jarvis,idroid}"

    # Version file
    echo "$VERSION" > "$CONFIG_DIR/VERSION"
    ok "Version file written: $CONFIG_DIR/VERSION"
}

# ══════════════════════════════════════════════════════════════════
# COPY SCRIPTS
# ══════════════════════════════════════════════════════════════════

install_scripts() {
    step "Installing scripts"

    # Scripts that live in $CONFIG_DIR/scripts/
    local config_scripts=(
        "jarvis-ai.sh"
        "jarvis-ai-aliases.sh"
        "jarvis-manager.sh"
        "jarvis-wild-examples.sh"
        "voice-engine.sh"
        "voice-activation.sh"
        "wehttamsnaps-keyhints.sh"
        "KeyHints.sh"
        "wehttamsnaps-welcome.py"
    )

    for script in "${config_scripts[@]}"; do
        local src="$SCRIPT_DIR/$script"
        local dst="$SCRIPTS_DIR/$script"
        if [[ -f "$src" ]]; then
            cp "$src" "$dst"
            chmod +x "$dst"
            ok "Installed script: $dst"
        else
            warn "Source not found (skipping): $src"
        fi
    done

    # Scripts that go into /usr/local/bin/ (system-wide, callable from keybinds)
    local bin_scripts=(
        "jarvis"
        "jarvis-menu"
        "sound-system"
    )

    for script in "${bin_scripts[@]}"; do
        local src="$SCRIPT_DIR/$script"
        if [[ -f "$src" ]]; then
            sudo cp "$src" "/usr/local/bin/$script"
            sudo chmod +x "/usr/local/bin/$script"
            ok "Installed to /usr/local/bin/$script"
        else
            warn "Source not found (skipping): $src"
        fi
    done

    # Create toggle-gamemode.sh (generated — not a source file)
    create_gamemode_script

    # Create power-menu.sh
    create_power_menu_script

    # Create wallpaper-browser.sh
    create_wallpaper_browser_script

    ok "All scripts installed"
}

# ══════════════════════════════════════════════════════════════════
# GENERATED SCRIPTS
# ══════════════════════════════════════════════════════════════════

create_gamemode_script() {
    local dst="$SCRIPTS_DIR/toggle-gamemode.sh"
    cat > "$dst" << 'GAMEMODE'
#!/bin/bash
# WehttamSnaps — Gaming Mode Toggle
# Disables Niri animations, sets CPU governor to performance
# Called by: sound-system gaming-toggle  (via Super+G keybind)

FLAG="$HOME/.cache/wehttamsnaps/gaming-mode.active"
NIRI_CFG="$HOME/.config/niri/config.kdl"

if [[ -f "$FLAG" ]]; then
    # ── DEACTIVATE ───────────────────────────────────────────────
    rm -f "$FLAG"

    # Restore CPU governor to schedutil (balanced)
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "schedutil" | sudo tee "$cpu" > /dev/null 2>&1 || true
    done

    # Re-enable GameMode daemon
    gamemoded -r 2>/dev/null || true

    # Play J.A.R.V.I.S. deactivation sound
    /usr/local/bin/sound-system mode jarvis

    notify-send "J.A.R.V.I.S." "Gaming mode deactivated. Normal operations resumed." \
        -i utilities-system-monitor -t 3000

    echo "Gaming mode OFF"
else
    # ── ACTIVATE ─────────────────────────────────────────────────
    touch "$FLAG"

    # Set CPU governor to performance
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "performance" | sudo tee "$cpu" > /dev/null 2>&1 || true
    done

    # Start GameMode daemon
    gamemoded 2>/dev/null || true

    # Play iDroid activation sound
    /usr/local/bin/sound-system mode idroid

    notify-send "iDROID ONLINE" "Combat systems active. Performance mode engaged." \
        -i input-gaming -t 3000

    echo "Gaming mode ON"
fi
GAMEMODE
    chmod +x "$dst"
    ok "Created: $dst"
}

create_power_menu_script() {
    local dst="$SCRIPTS_DIR/power-menu.sh"
    cat > "$dst" << 'POWER'
#!/bin/bash
# WehttamSnaps — Power Menu via Rofi

CHOICE=$(printf "⏻  Shutdown\n  Reboot\n  Suspend\n🔒  Lock\n⬚  Log Out" | \
    rofi -dmenu \
         -p "Power ❯" \
         -theme ~/.config/rofi/themes/wehttamsnaps.rasi \
         -lines 5 \
         -width 300)

case "$CHOICE" in
    *Shutdown*)
        /usr/local/bin/sound-system shutdown
        sleep 2
        systemctl poweroff
        ;;
    *Reboot*)
        /usr/local/bin/sound-system shutdown
        sleep 2
        systemctl reboot
        ;;
    *Suspend*)
        /usr/local/bin/sound-system lock
        systemctl suspend
        ;;
    *Lock*)
        /usr/local/bin/sound-system notification
        swaylock -f -c 07050f
        ;;
    *Log\ Out*)
        /usr/local/bin/sound-system shutdown
        sleep 1
        niri msg action quit
        ;;
esac
POWER
    chmod +x "$dst"
    ok "Created: $dst"
}

create_wallpaper_browser_script() {
    local dst="$SCRIPTS_DIR/wallpaper-browser.sh"
    cat > "$dst" << 'WALL'
#!/bin/bash
# WehttamSnaps — Wallpaper Browser via Rofi

WALLPAPER_DIR="$HOME/.config/wehttamsnaps/wallpapers"

if [[ ! -d "$WALLPAPER_DIR" ]] || [[ -z "$(ls "$WALLPAPER_DIR" 2>/dev/null)" ]]; then
    notify-send "WehttamSnaps" "No wallpapers found in $WALLPAPER_DIR" -t 3000
    exit 0
fi

CHOICE=$(ls "$WALLPAPER_DIR" | \
    rofi -dmenu \
         -p "Wallpaper ❯" \
         -theme ~/.config/rofi/themes/wehttamsnaps.rasi)

if [[ -n "$CHOICE" ]]; then
    swww img "$WALLPAPER_DIR/$CHOICE" \
        --transition-type fade \
        --transition-duration 1
    ln -sf "$WALLPAPER_DIR/$CHOICE" "$WALLPAPER_DIR/current.jpg"
    notify-send "WehttamSnaps" "Wallpaper set: $CHOICE" -t 2000
fi
WALL
    chmod +x "$dst"
    ok "Created: $dst"
}

# ══════════════════════════════════════════════════════════════════
# COPY CONFIGS
# ══════════════════════════════════════════════════════════════════

install_configs() {
    step "Installing configuration files"

    # ── Niri config ──────────────────────────────────────────────
    if [[ -f "$SCRIPT_DIR/config.kdl" ]]; then
        # Back up existing config if present
        if [[ -f "$NIRI_DIR/config.kdl" ]]; then
            cp "$NIRI_DIR/config.kdl" "$NIRI_DIR/config.kdl.bak.$(date +%Y%m%d%H%M%S)"
            warn "Existing Niri config backed up"
        fi
        cp "$SCRIPT_DIR/config.kdl" "$NIRI_DIR/config.kdl"
        ok "Installed: $NIRI_DIR/config.kdl"
    else
        warn "config.kdl not found in $SCRIPT_DIR — skipping"
    fi

    # ── Rofi theme ───────────────────────────────────────────────
    if [[ -f "$SCRIPT_DIR/wehttamsnaps.rasi" ]]; then
        cp "$SCRIPT_DIR/wehttamsnaps.rasi" "$ROFI_DIR/themes/wehttamsnaps.rasi"
        ok "Installed: $ROFI_DIR/themes/wehttamsnaps.rasi"
    else
        warn "wehttamsnaps.rasi not found — skipping"
    fi

    # ── Rofi global config ───────────────────────────────────────
    if [[ -f "$SCRIPT_DIR/config.rasi" ]]; then
        cp "$SCRIPT_DIR/config.rasi" "$ROFI_DIR/config.rasi"
        ok "Installed: $ROFI_DIR/config.rasi"
    else
        warn "config.rasi not found — skipping"
    fi

    # ── Dunst notification config ────────────────────────────────
    create_dunst_config

    # ── GTK / icon theme settings ────────────────────────────────
    create_gtk_configs

    ok "Config installation complete"
}

create_dunst_config() {
    local dunst_dir="$USER_HOME/.config/dunst"
    mkdir -p "$dunst_dir"

    cat > "$dunst_dir/dunstrc" << 'DUNST'
[global]
    monitor = 0
    follow = mouse
    width = 380
    height = 200
    origin = top-right
    offset = 16x50
    scale = 0
    notification_limit = 5
    progress_bar = true
    progress_bar_height = 3
    progress_bar_frame_width = 1
    progress_bar_min_width = 150
    progress_bar_max_width = 300
    indicate_hidden = yes
    transparency = 10
    separator_height = 1
    padding = 10
    horizontal_padding = 12
    text_icon_padding = 8
    frame_width = 1
    frame_color = "#00ffd133"
    separator_color = frame
    sort = yes
    font = Rajdhani SemiBold 11
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    vertical_alignment = center
    show_age_threshold = 60
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    icon_position = left
    min_icon_size = 24
    max_icon_size = 32
    icon_theme = "Papirus-Dark"
    enable_recursive_icon_lookup = true
    sticky_history = yes
    history_length = 20
    browser = /usr/bin/brave
    always_run_script = true
    title = Dunst
    class = Dunst
    corner_radius = 6
    ignore_dbusclose = false
    force_xwayland = false
    force_xinerama = false
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = close_all

[experimental]
    per_monitor_dpi = false

[urgency_low]
    background = "#0d0a1a"
    foreground = "#c8f0e8"
    frame_color = "#00ffd133"
    timeout = 4
    icon = dialog-information

[urgency_normal]
    background = "#0d0a1a"
    foreground = "#c8f0e8"
    frame_color = "#00ffd155"
    timeout = 6

[urgency_critical]
    background = "#0d0a1a"
    foreground = "#ff5af1"
    frame_color = "#ff5af1"
    timeout = 0
    icon = dialog-error
DUNST
    ok "Created: $dunst_dir/dunstrc"
}

create_gtk_configs() {
    # GTK 3
    local gtk3_dir="$USER_HOME/.config/gtk-3.0"
    mkdir -p "$gtk3_dir"
    cat > "$gtk3_dir/settings.ini" << 'GTK3'
[Settings]
gtk-theme-name=adw-gtk3-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Rajdhani SemiBold 11
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_SMALL_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-application-prefer-dark-theme=1
GTK3
    ok "Created: $gtk3_dir/settings.ini"

    # GTK 4
    local gtk4_dir="$USER_HOME/.config/gtk-4.0"
    mkdir -p "$gtk4_dir"
    cat > "$gtk4_dir/settings.ini" << 'GTK4'
[Settings]
gtk-theme-name=adw-gtk3-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Rajdhani SemiBold 11
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
GTK4
    ok "Created: $gtk4_dir/settings.ini"
}

# ══════════════════════════════════════════════════════════════════
# SOUND DIRECTORIES
# ══════════════════════════════════════════════════════════════════

setup_sounds() {
    step "Setting up sound system"

    # Ensure directories exist and are owned by user
    sudo mkdir -p "$SOUNDS_DIR/jarvis" "$SOUNDS_DIR/idroid"
    sudo chown -R "$USERNAME:$USERNAME" "/usr/share/wehttamsnaps" 2>/dev/null || true

    # Write README for each sound directory
    cat > "$SOUNDS_DIR/jarvis/README.md" << 'README'
# J.A.R.V.I.S. Sound Pack (Paul Bettany voice)
# Source: https://www.101soundboards.com/boards/10155-jarvis-v1-paul-bettany-tts-computer-ai-voice
#
# Required filenames (rename downloads to match exactly):
#
# System events:
#   jarvis-startup.mp3        "Allow me to introduce myself..."
#   jarvis-shutdown.mp3       "Shutting down. Have a good day, Matthew."
#   morning.mp3               "Good morning, sir."
#   afternoon.mp3             "Good afternoon."
#   evening.mp3               "Good evening."
#   jarvis-notification.mp3   "Sir, you have a notification."
#   jarvis-warning.mp3        "Warning. Please be advised."
#   jarvis-thermal.mp3        "Sir, the system temperature is critical."
#   reloading-config.mp3      "Reloading configuration."
#   status-report.mp3         "Generating status report."
#   error.mp3                 "An error has occurred."
#
# Audio:
#   audio-mute.mp3            "Audio muted, sir."
#   audio-unmute.mp3          "Audio restored."
#   volume-up.mp3             "Volume increased."
#   volume-down.mp3           "Volume decreased."
#
# Apps:
#   opening-terminal.mp3      "Opening terminal."
#   opening-files.mp3         "Opening file manager."
#   accessing-web.mp3         "Accessing the web."
#   launching-firefox.mp3     "Launching Firefox."
#   launching-discord.mp3     "Comms online."
#   launching-spotify.mp3     "Initializing audio."
#   launching-obs.mp3         "Broadcast ready."
#   launching-gimp.mp3        "Launching GIMP."
#   launching-editor.mp3      "Opening editor."
#
# Windows:
#   closing-window.mp3        "Closing window."
#   window-float.mp3          "Window set to float."
#   window-fullscreen.mp3     "Fullscreen mode."
#   window-tile.mp3           "Window tiled."
#   window-center.mp3         "Centering window."
#
# Workspaces:
#   workspace-switch.mp3      "Workspace changed."
#   workspace-next.mp3        "Next workspace."
#   workspace-previous.mp3    "Previous workspace."
#
# Actions:
#   jarvis-screen-capture.mp3 "Screenshot captured."
#   photo-export.mp3          "Export complete, sir."
#   locking-screen.mp3        "Locking screen, sir."
#   searching-google.mp3      "Searching Google."
#   searching-youtube.mp3     "Searching YouTube."
#   searching-github.mp3      "Searching GitHub."
#   photo-mode.mp3            "Entering photography mode."
#   jarvis-gaming.mp3         "Entering gaming mode."
#   jarvis-streaming.mp3      "Streaming systems online."
#   jarvis-update.mp3         "Initiating system update."
#   you-welcome.mp3           "My pleasure, sir."
#   greeting.mp3              "Hello, sir."
#   listening.mp3             "Listening."
#   command-unknown.mp3       "I'm sorry, I don't understand."
#   app-not-found.mp3         "Application not found."
#   music-play.mp3            "Playing music."
#   music-pause.mp3           "Pausing music."
#   music-next.mp3            "Next track."
#   music-previous.mp3        "Previous track."
#   jarvis-confirm.mp3        "Confirmed."
README
    ok "Created: $SOUNDS_DIR/jarvis/README.md"

    cat > "$SOUNDS_DIR/idroid/README.md" << 'README'
# iDroid Sound Pack (Metal Gear Solid voice)
# Source: https://www.101soundboards.com/boards/10060-idroid-tts-computer-ai-voice
#
# Required filenames:
#   gamemode-on.mp3           "Combat systems online."
#   gamemode-off.mp3          "Returning to normal operations."
#   steam-launch.mp3          "Game launching."
#   alert-high.mp3            "Alert! High priority."
#   alert-medium.mp3          "Caution."
#   mission-start.mp3         "Mission start."
#   discord-notify.mp3        "Incoming transmission."
#   performance-warn.mp3      "System performance critical."
README
    ok "Created: $SOUNDS_DIR/idroid/README.md"

    echo ""
    warn "════════════════════════════════════════════════════════"
    warn " ACTION REQUIRED: Download your sound packs"
    warn "════════════════════════════════════════════════════════"
    warn " J.A.R.V.I.S.: https://www.101soundboards.com/boards/10155"
    warn " iDroid:        https://www.101soundboards.com/boards/10060"
    warn " Place .mp3 files in:"
    warn "   $SOUNDS_DIR/jarvis/"
    warn "   $SOUNDS_DIR/idroid/"
    warn " See README.md in each folder for required filenames."
    warn "════════════════════════════════════════════════════════"
}

# ══════════════════════════════════════════════════════════════════
# SYSTEMD SERVICES
# ══════════════════════════════════════════════════════════════════

install_services() {
    step "Installing systemd user services"

    # ── J.A.R.V.I.S. Voice Activation service ───────────────────
    cat > "$SYSTEMD_DIR/jarvis-voice.service" << SERVICE
[Unit]
Description=J.A.R.V.I.S. Voice Activation (Vosk offline STT)
After=pipewire.service sound.target

[Service]
Type=simple
ExecStart=$SCRIPTS_DIR/voice-activation.sh start-listener
Restart=on-failure
RestartSec=10
Environment=HOME=$USER_HOME
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
SERVICE
    ok "Created: $SYSTEMD_DIR/jarvis-voice.service"

    # ── Reload systemd user daemon ───────────────────────────────
    systemctl --user daemon-reload
    ok "systemd user daemon reloaded"

    # Don't auto-enable voice service — user must set up vosk model first
    warn "Voice service NOT auto-enabled."
    warn "Run this when ready:"
    warn "  voice-activation.sh setup"
    warn "  systemctl --user enable --now jarvis-voice.service"
}

# ══════════════════════════════════════════════════════════════════
# SHELL INTEGRATION (.bashrc / .zshrc)
# ══════════════════════════════════════════════════════════════════

setup_shell() {
    step "Setting up shell integration"

    local marker="# ── WehttamSnaps JARVIS Integration ──"
    local block="$marker
source \"\$HOME/.config/wehttamsnaps/scripts/jarvis-ai.sh\"
source \"\$HOME/.config/wehttamsnaps/scripts/jarvis-ai-aliases.sh\"

# Aliases
alias update='paru -Syu --noconfirm && paru -Sc --noconfirm && echo \"System updated, sir.\"'
alias gaming='~/.config/wehttamsnaps/scripts/toggle-gamemode.sh'
alias stream='obs &'
alias audio='pavucontrol &'
alias keyhints='~/.config/wehttamsnaps/scripts/KeyHints.sh'
alias welcome='python3 ~/.config/wehttamsnaps/scripts/wehttamsnaps-welcome.py --force'
alias niri-reload='niri msg action reload-config'
alias sound-test='/usr/local/bin/sound-system test'
"

    # bash
    if [[ -f "$USER_HOME/.bashrc" ]]; then
        if ! grep -q "WehttamSnaps JARVIS Integration" "$USER_HOME/.bashrc"; then
            echo "" >> "$USER_HOME/.bashrc"
            echo "$block" >> "$USER_HOME/.bashrc"
            ok "Added JARVIS integration to ~/.bashrc"
        else
            warn "JARVIS integration already in ~/.bashrc — skipping"
        fi
    fi

    # zsh (if present)
    if [[ -f "$USER_HOME/.zshrc" ]]; then
        if ! grep -q "WehttamSnaps JARVIS Integration" "$USER_HOME/.zshrc"; then
            echo "" >> "$USER_HOME/.zshrc"
            echo "$block" >> "$USER_HOME/.zshrc"
            ok "Added JARVIS integration to ~/.zshrc"
        else
            warn "JARVIS integration already in ~/.zshrc — skipping"
        fi
    fi
}

# ══════════════════════════════════════════════════════════════════
# STEAM LIBRARY SYMLINK
# ══════════════════════════════════════════════════════════════════

setup_steam() {
    step "Setting up Steam library"

    local linuxdrive="/run/media/$USERNAME/LINUXDRIVE"

    if [[ -d "$linuxdrive" ]]; then
        local steam_lib="$linuxdrive/steamLibrary"
        local mod_packs="$linuxdrive/Modlist_Packs"
        local mod_dl="$linuxdrive/Modlist_Downloads"

        mkdir -p "$steam_lib" "$mod_packs" "$mod_dl"
        ok "Steam library directories confirmed: $linuxdrive"

        # Add steam library to Steam's libraryfolders.vdf if Steam is installed
        if command -v steam &>/dev/null; then
            warn "Add your LINUXDRIVE Steam library manually:"
            warn "  Steam → Settings → Storage → Add Drive"
            warn "  Path: $steam_lib"
        fi
    else
        warn "LINUXDRIVE not mounted at $linuxdrive"
        warn "Mount your 1TB SSD and re-run: ./install.sh steam"
    fi
}

# ══════════════════════════════════════════════════════════════════
# ENABLE GAMEMODE SUDOERS (CPU governor without password)
# ══════════════════════════════════════════════════════════════════

setup_sudoers() {
    step "Configuring sudoers for gaming mode CPU governor"

    local sudoers_file="/etc/sudoers.d/wehttamsnaps-gamemode"

    # Allow current user to write CPU governor without password
    echo "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor" | \
        sudo tee "$sudoers_file" > /dev/null
    sudo chmod 440 "$sudoers_file"
    ok "Sudoers rule created: $sudoers_file"
}

# ══════════════════════════════════════════════════════════════════
# POST-INSTALL SUMMARY
# ══════════════════════════════════════════════════════════════════

print_summary() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          WehttamSnaps Install Complete!                      ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}✓ Packages installed${NC}"
    echo -e "${GREEN}✓ Scripts → $SCRIPTS_DIR${NC}"
    echo -e "${GREEN}✓ /usr/local/bin → jarvis · jarvis-menu · sound-system${NC}"
    echo -e "${GREEN}✓ Niri config → $NIRI_DIR/config.kdl${NC}"
    echo -e "${GREEN}✓ Rofi theme → $ROFI_DIR/themes/wehttamsnaps.rasi${NC}"
    echo -e "${GREEN}✓ Dunst config → ~/.config/dunst/dunstrc${NC}"
    echo -e "${GREEN}✓ GTK theme → adw-gtk3-dark + Papirus-Dark${NC}"
    echo -e "${GREEN}✓ Shell integration → ~/.bashrc${NC}"
    echo -e "${GREEN}✓ Systemd service → jarvis-voice.service (not yet enabled)${NC}"
    echo ""
    echo -e "${YELLOW}ACTION REQUIRED:${NC}"
    echo -e "  1. Download sound packs → $SOUNDS_DIR/jarvis/ and idroid/"
    echo -e "     See README.md in each folder for filenames."
    echo -e "  2. Add a wallpaper → $WALLPAPER_DIR/"
    echo -e "  3. Reload Niri: ${CYAN}niri msg action reload-config${NC}"
    echo -e "  4. Source shell: ${CYAN}source ~/.bashrc${NC}"
    echo -e "  5. Test sounds: ${CYAN}sound-system test${NC}"
    echo -e "  6. (Optional) Setup voice: ${CYAN}voice-activation.sh setup${NC}"
    echo ""
    echo -e "  Full log saved to: ${CYAN}$LOG_FILE${NC}"
    echo ""
    echo -e "${CYAN}First boot tips:${NC}"
    echo -e "  Super+H         → KeyHints cheatsheet"
    echo -e "  Super+G         → toggle gaming mode (iDroid)"
    echo -e "  Super+Space     → app launcher"
    echo -e "  jarvis help     → JARVIS command list"
    echo -e "  j 'hello'       → ask J.A.R.V.I.S. anything"
    echo ""
    echo -e "  ${CYAN}Twitch: twitch.tv/WehttamSnaps${NC}"
    echo -e "  ${CYAN}GitHub: github.com/Crowdrocker${NC}"
    echo ""
}

# ══════════════════════════════════════════════════════════════════
# HELP
# ══════════════════════════════════════════════════════════════════

show_help() {
    cat << EOF

${CYAN}WehttamSnaps Niri Setup Installer${NC}

${YELLOW}Usage:${NC}
  ./install.sh              Full install (recommended)
  ./install.sh packages     Packages only
  ./install.sh configs      Config files only
  ./install.sh scripts      Scripts only
  ./install.sh sounds       Sound directory scaffold only
  ./install.sh services     Systemd services only
  ./install.sh shell        Shell (.bashrc) integration only
  ./install.sh steam        Steam library setup only
  ./install.sh sudoers      Gaming mode CPU sudoers rule only
  ./install.sh --help       Show this help

${YELLOW}Files needed in same directory as install.sh:${NC}
  config.kdl                Niri compositor config
  wehttamsnaps.rasi         Rofi theme
  config.rasi               Rofi global config
  jarvis                    JARVIS NLP command script
  jarvis-menu               JARVIS Rofi menu script
  sound-system              Adaptive sound system
  jarvis-ai.sh              Gemini AI integration
  jarvis-ai-aliases.sh      Shell aliases
  jarvis-manager.sh         Sound manager
  voice-engine.sh           Voice engine
  voice-activation.sh       Vosk wake-word listener
  wehttamsnaps-keyhints.sh  Rofi keyhints launcher
  KeyHints.sh               yad keyhints GUI
  wehttamsnaps-welcome.py   GTK welcome screen

${YELLOW}Log:${NC} $LOG_FILE

EOF
}

# ══════════════════════════════════════════════════════════════════
# MAIN ENTRY POINT
# ══════════════════════════════════════════════════════════════════

main() {
    print_banner

    case "${1:-full}" in
        full|"")
            preflight
            create_directories
            install_packages
            install_scripts
            install_configs
            setup_sounds
            install_services
            setup_shell
            setup_steam
            setup_sudoers
            print_summary
            ;;
        packages|pkgs)
            preflight
            install_packages
            ;;
        configs|config)
            preflight
            create_directories
            install_configs
            ;;
        scripts|script)
            preflight
            create_directories
            install_scripts
            ;;
        sounds|sound)
            create_directories
            setup_sounds
            ;;
        services|service)
            install_services
            ;;
        shell|bashrc)
            setup_shell
            ;;
        steam)
            setup_steam
            ;;
        sudoers)
            setup_sudoers
            ;;
        --help|-h|help)
            show_help
            ;;
        *)
            err "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
