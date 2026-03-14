#!/usr/bin/env bash
# =============================================================================
# WEHTTAMSNAPS NIRI SETUP - Master Installation Script
# =============================================================================
# Automated installation for the WehttamSnaps Photography & Gaming Niri setup
# Author: Matthew (WehttamSnaps)
# GitHub: Crowdrocker
# Twitch/YouTube: WehttamSnaps
# =============================================================================

# Script info
SCRIPT_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Configuration
CONFIG_DIR="$HOME/.config"
NIRI_DIR="$CONFIG_DIR/niri"
WEHTTAMSNAPS_DIR="$CONFIG_DIR/wehttamsnaps"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"

# Animation on/off
ANIMATION=true

# =============================================================================
# Logging Functions
# =============================================================================

log_header() {
    echo ""
    echo -e "${PURPLE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} ${CYAN}$1${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

log() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_step() {
    echo -e "${CYAN}[→]${NC} $1"
}

# =============================================================================
# Animation Functions
# =============================================================================

show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % ${#spinstr} ))
        printf "\r${spinstr:$i:1} "
        sleep $delay
    done
    printf "\r"
}

show_progress() {
    local current=$1
    local total=$2
    local message="$3"
    local width=40
    local percent=$(( current * 100 / total ))
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))
    
    printf "\r${CYAN}[${GREEN}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${CYAN}"
    printf "%${empty}s" | tr ' ' '░'
    printf "${NC}] ${percent}%% - ${message}"
    
    if [[ $current -eq $total ]]; then
        echo ""
    fi
}

show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║     ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗   ║
║     ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝   ║
║     ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗     ║
║     ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝     ║
║     ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗   ║
║      ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝   ║
║                                                                       ║
║     ███████╗██╗    ██╗███████╗████████╗██████╗                         ║
║     ██╔════╝██║    ██║██╔════╝╚══██╔══╝╚════██╗                        ║
║     █████╗  ██║ █╗ ██║███████╗   ██║    █████╔╝                        ║
║     ██╔══╝  ██║███╗██║╚════██║   ██║   ██╔═══╝                         ║
║     ██║     ╚███╔███╔╝███████║   ██║   ███████╗                        ║
║     ╚═╝      ╚══╝╚══╝ ╚══════╝   ╚═╝   ╚══════╝                        ║
║                                                                       ║
║                    Photography & Gaming Setup                         ║
║                        Arch Linux + Niri                              ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo -e "  ${PURPLE}Version:${NC} $SCRIPT_VERSION"
    echo -e "  ${PURPLE}Author:${NC}  Matthew (WehttamSnaps)"
    echo ""
}

# =============================================================================
# Utility Functions
# =============================================================================

check_command() {
    if command -v "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

install_package() {
    local package="$1"
    
    if check_command "$package"; then
        log "$package is already installed"
        return 0
    fi
    
    log_step "Installing $package..."
    
    if check_command "pacman"; then
        sudo pacman -S --noconfirm "$package" 2>/dev/null
    elif check_command "apt"; then
        sudo apt install -y "$package" 2>/dev/null
    elif check_command "dnf"; then
        sudo dnf install -y "$package" 2>/dev/null
    else
        log_error "Could not install $package - no supported package manager found"
        return 1
    fi
    
    if check_command "$package"; then
        log "Installed $package"
        return 0
    else
        log_error "Failed to install $package"
        return 1
    fi
}

backup_config() {
    local config_path="$1"
    
    if [[ -e "$config_path" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$config_path" "$BACKUP_DIR/"
        log_info "Backed up: $config_path"
    fi
}

create_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log "Created directory: $dir"
    fi
}

copy_file() {
    local src="$1"
    local dest="$2"
    
    # Create destination directory if needed
    create_directory "$(dirname "$dest")"
    
    # Backup existing file
    backup_config "$dest"
    
    # Copy file
    cp "$src" "$dest"
    log "Installed: $dest"
}

copy_dir() {
    local src="$1"
    local dest="$2"
    
    # Backup existing directory
    backup_config "$dest"
    
    # Remove existing directory
    if [[ -d "$dest" ]]; then
        rm -rf "$dest"
    fi
    
    # Copy directory
    cp -r "$src" "$dest"
    log "Installed directory: $dest"
}

make_executable() {
    local file="$1"
    chmod +x "$file"
    log_info "Made executable: $file"
}

# =============================================================================
# Dependency Installation
# =============================================================================

install_base_dependencies() {
    log_header "Installing Base Dependencies"
    
    local packages=(
        # Core utilities
        "git"
        "curl"
        "wget"
        "unzip"
        "rsync"
        "htop"
        "neofetch"
        
        # Audio
        "pipewire"
        "pipewire-pulse"
        "wireplumber"
        "pavucontrol"
        "qpwgraph"
        
        # Graphics
        "mesa"
        "vulkan-radeon"
        "lib32-mesa"
        "lib32-vulkan-radeon"
        "glxinfo"
        
        # Fonts
        "ttf-jetbrains-mono"
        "ttf-font-awesome"
        "noto-fonts"
        "noto-fonts-emoji"
        
        # Notifications
        "mako"
        "libnotify"
        
        # Wallpaper
        "swww"
        
        # Clipboard
        "cliphist"
        "wl-clipboard"
        
        # Screenshot
        "grim"
        "slurp"
        
        # Launcher
        "fuzzel"
        "rofi-wayland"
        
        # Terminal
        "foot"
        "alacritty"
    )
    
    local total=${#packages[@]}
    local current=0
    
    log_info "Installing ${total} packages..."
    
    for package in "${packages[@]}"; do
        current=$((current + 1))
        show_progress $current $total "$package"
        install_package "$package" 2>/dev/null
    done
    
    log "Base dependencies installed"
}

install_gaming_dependencies() {
    log_header "Installing Gaming Dependencies"
    
    local packages=(
        "steam"
        "wine"
        "winetricks"
        "protontricks"
        "gamemode"
        "lib32-gamemode"
        "gamescope"
        "mangohud"
        "lib32-mangohud"
        "goverlay"
        "lutris"
        "heroic-games-launcher-bin"
    )
    
    for package in "${packages[@]}"; do
        install_package "$package" 2>/dev/null
    done
    
    log "Gaming dependencies installed"
}

install_photography_dependencies() {
    log_header "Installing Photography Dependencies"
    
    local packages=(
        "darktable"
        "gimp"
        "krita"
        "digiKam"
        "rawtherapee"
        "inkscape"
        "blender"
    )
    
    for package in "${packages[@]}"; do
        install_package "$package" 2>/dev/null
    done
    
    log "Photography dependencies installed"
}

install_streaming_dependencies() {
    log_header "Installing Streaming Dependencies"
    
    local packages=(
        "obs-studio"
        "obs-studio-wayland"
        "pipewire-zeroconf"
        "noise-suppression-for-voice"
    )
    
    for package in "${packages[@]}"; do
        install_package "$package" 2>/dev/null
    done
    
    log "Streaming dependencies installed"
}

install_optional_dependencies() {
    log_header "Installing Optional Dependencies"
    
    local packages=(
        "quickshell"      # Noctalia-Shell
        "python-gobject"  # GTK Python bindings
        "polkit-gnome"    # Polkit agent
        "xdg-desktop-portal"
        "xdg-desktop-portal-gtk"
    )
    
    for package in "${packages[@]}"; do
        install_package "$package" 2>/dev/null
    done
    
    log "Optional dependencies installed"
}

# =============================================================================
# Configuration Installation
# =============================================================================

install_niri_config() {
    log_header "Installing Niri Configuration"
    
    # Install Niri first
    if ! check_command "niri"; then
        log_step "Installing Niri..."
        
        if check_command "pacman"; then
            sudo pacman -S --noconfirm niri 2>/dev/null
        else
            log_warn "Please install Niri manually: https://github.com/YaLTeR/niri"
        fi
    fi
    
    # Create Niri config directory
    create_directory "$NIRI_DIR"
    create_directory "$NIRI_DIR/conf.d"
    
    # Copy configuration files
    if [[ -d "$SCRIPT_DIR/configs/niri" ]]; then
        copy_dir "$SCRIPT_DIR/configs/niri" "$NIRI_DIR"
    else
        log_warn "Niri config directory not found in $SCRIPT_DIR"
    fi
    
    log "Niri configuration installed"
}

install_shell_config() {
    log_header "Installing Shell Configuration"
    
    # Create shell config directory
    create_directory "$CONFIG_DIR/shell"
    
    # Copy aliases
    if [[ -f "$SCRIPT_DIR/configs/shell/aliases" ]]; then
        copy_file "$SCRIPT_DIR/configs/shell/aliases" "$CONFIG_DIR/shell/aliases"
    fi
    
    # Add source to .bashrc
    if [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "wehttamsnaps aliases" "$HOME/.bashrc"; then
            echo "" >> "$HOME/.bashrc"
            echo "# WehttamSnaps aliases" >> "$HOME/.bashrc"
            echo "[[ -f \$HOME/.config/shell/aliases ]] && source \$HOME/.config/shell/aliases" >> "$HOME/.bashrc"
            log "Added aliases source to .bashrc"
        fi
    fi
    
    log "Shell configuration installed"
}

install_scripts() {
    log_header "Installing Scripts"
    
    # Create scripts directory
    create_directory "$WEHTTAMSNAPS_DIR/scripts"
    
    # Copy all scripts
    if [[ -d "$SCRIPT_DIR/scripts" ]]; then
        cp -r "$SCRIPT_DIR/scripts/"* "$WEHTTAMSNAPS_DIR/scripts/" 2>/dev/null
        
        # Make all scripts executable
        find "$WEHTTAMSNAPS_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
        find "$WEHTTAMSNAPS_DIR/scripts" -type f ! -name "*.sh" -exec chmod +x {} \;
        
        log "Scripts installed to $WEHTTAMSNAPS_DIR/scripts"
    fi
    
    log "Scripts installed"
}

install_sounds() {
    log_header "Setting Up Sound System"
    
    create_directory "$WEHTTAMSNAPS_DIR/sounds/jarvis"
    create_directory "$WEHTTAMSNAPS_DIR/sounds/idroid"
    create_directory "$WEHTTAMSNAPS_DIR/sounds/system"
    
    log_info "Sound directories created"
    log_info "Please add your sound files to:"
    log_info "  $WEHTTAMSNAPS_DIR/sounds/jarvis/  - JARVIS voice pack"
    log_info "  $WEHTTAMSNAPS_DIR/sounds/idroid/   - iDroid voice pack"
    log_info "  $WEHTTAMSNAPS_DIR/sounds/system/   - System sounds"
    
    log "Sound system configured"
}

install_wallpapers() {
    log_header "Setting Up Wallpapers"
    
    create_directory "$HOME/Pictures/Wallpapers"
    create_directory "$WEHTTAMSNAPS_DIR/wallpapers"
    
    # Copy any included wallpapers
    if [[ -d "$SCRIPT_DIR/wallpapers" ]]; then
        cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers/" 2>/dev/null
    fi
    
    log_info "Wallpaper directory: $HOME/Pictures/Wallpapers"
    log "Wallpaper setup complete"
}

install_assets() {
    log_header "Installing Assets"
    
    create_directory "$WEHTTAMSNAPS_DIR/assets"
    
    # Copy assets
    if [[ -d "$SCRIPT_DIR/assets" ]]; then
        cp -r "$SCRIPT_DIR/assets/"* "$WEHTTAMSNAPS_DIR/assets/" 2>/dev/null
        log "Assets installed"
    fi
    
    log "Assets installed"
}

# =============================================================================
# Post-Installation
# =============================================================================

enable_services() {
    log_header "Enabling Services"
    
    # Enable PipeWire
    systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null
    log "PipeWire enabled"
    
    # Enable gamemode
    systemctl --user enable --now gamemoded 2>/dev/null || log_info "Gamemode service not available"
    
    log "Services enabled"
}

create_desktop_entries() {
    log_header "Creating Desktop Entries"
    
    create_directory "$HOME/.local/share/applications"
    
    # WehttamSnaps Welcome
    cat > "$HOME/.local/share/applications/wehttamsnaps-welcome.desktop" << EOF
[Desktop Entry]
Name=WehttamSnaps Welcome
Comment=WehttamSnaps Photography & Gaming Setup
Exec=$WEHTTAMSNAPS_DIR/scripts/wehttamsnaps-welcome.py
Icon=camera
Terminal=false
Type=Application
Categories=Settings;System;
EOF
    
    # GameMode Toggle
    cat > "$HOME/.local/share/applications/gamemode-toggle.desktop" << EOF
[Desktop Entry]
Name=Toggle GameMode
Comment=Toggle gaming optimizations on/off
Exec=$WEHTTAMSNAPS_DIR/scripts/toggle-gamemode.sh toggle
Icon=input-gaming
Terminal=false
Type=Application
Categories=Game;Settings;
EOF
    
    log "Desktop entries created"
}

run_post_install() {
    log_header "Post-Installation Setup"
    
    # Set up JARVIS
    if [[ -f "$WEHTTAMSNAPS_DIR/scripts/jarvis/jarvis-ai.sh" ]]; then
        log_info "Setting up JARVIS AI..."
        chmod +x "$WEHTTAMSNAPS_DIR/scripts/jarvis/jarvis-ai.sh"
    fi
    
    # Set up sound system
    if [[ -f "$WEHTTAMSNAPS_DIR/scripts/sound-system" ]]; then
        chmod +x "$WEHTTAMSNAPS_DIR/scripts/sound-system"
    fi
    
    # Generate widgets
    if [[ -f "$WEHTTAMSNAPS_DIR/scripts/widget-generator.sh" ]]; then
        log_info "Generating widgets..."
        "$WEHTTAMSNAPS_DIR/scripts/widget-generator.sh" all 2>/dev/null
    fi
    
    # Initialize audio
    if [[ -f "$WEHTTAMSNAPS_DIR/scripts/audio-setup.sh" ]]; then
        log_info "Initializing audio..."
        "$WEHTTAMSNAPS_DIR/scripts/audio-setup.sh" init 2>/dev/null
    fi
    
    log "Post-installation complete"
}

# =============================================================================
# Summary
# =============================================================================

show_summary() {
    log_header "Installation Complete!"
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC} ${BOLD}WehttamSnaps Niri Setup Complete!${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} ${CYAN}Installed Components:${NC}"
    echo -e "${GREEN}║${NC}   ${BOLD}•${NC} Niri Configuration      $NIRI_DIR"
    echo -e "${GREEN}║${NC}   ${BOLD}•${NC} Shell Aliases            $CONFIG_DIR/shell/aliases"
    echo -e "${GREEN}║${NC}   ${BOLD}•${NC} Scripts                  $WEHTTAMSNAPS_DIR/scripts"
    echo -e "${GREEN}║${NC}   ${BOLD}•${NC} Sound System             $WEHTTAMSNAPS_DIR/sounds"
    echo -e "${GREEN}║${NC}   ${BOLD}•${NC} Assets                   $WEHTTAMSNAPS_DIR/assets"
    echo -e "${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} ${YELLOW}Next Steps:${NC}"
    echo -e "${GREEN}║${NC}   1. Log out and select Niri from your display manager"
    echo -e "${GREEN}║${NC}   2. Press Mod+Space to open the launcher"
    echo -e "${GREEN}║${NC}   3. Press Mod+? to show keybindings"
    echo -e "${GREEN}║${NC}   4. Run 'gamemode-toggle' to toggle gaming mode"
    echo -e "${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} ${PURPLE}Key Bindings:${NC}"
    echo -e "${GREEN}║${NC}   Mod = Super/Windows key"
    echo -e "${GREEN}║${NC}   Mod+Enter     Terminal"
    echo -e "${GREEN}║${NC}   Mod+Space     Launcher"
    echo -e "${GREEN}║${NC}   Mod+G         Toggle GameMode"
    echo -e "${GREEN}║${NC}   Mod+P         Screenshot"
    echo -e "${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} ${BLUE}Documentation:${NC}"
    echo -e "${GREEN}║${NC}   GitHub: https://github.com/Crowdrocker"
    echo -e "${GREEN}║${NC}   Twitch: https://twitch.tv/WehttamSnaps"
    echo -e "${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo -e "${YELLOW}Backup saved to: $BACKUP_DIR${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}Happy photographing and gaming! 📷🎮${NC}"
    echo ""
}

# =============================================================================
# Installation Modes
# =============================================================================

install_full() {
    show_banner
    
    log_info "Starting full installation..."
    echo ""
    
    install_base_dependencies
    install_gaming_dependencies
    install_photography_dependencies
    install_streaming_dependencies
    install_optional_dependencies
    
    install_niri_config
    install_shell_config
    install_scripts
    install_sounds
    install_wallpapers
    install_assets
    
    enable_services
    create_desktop_entries
    run_post_install
    
    show_summary
}

install_minimal() {
    show_banner
    
    log_info "Starting minimal installation (core only)..."
    echo ""
    
    install_base_dependencies
    install_niri_config
    install_scripts
    install_sounds
    
    enable_services
    
    show_summary
}

install_config_only() {
    show_banner
    
    log_info "Installing configuration only..."
    echo ""
    
    install_niri_config
    install_shell_config
    install_scripts
    install_assets
    
    show_summary
}

# =============================================================================
# Menu System
# =============================================================================

show_menu() {
    show_banner
    
    echo -e "${CYAN}Select installation type:${NC}"
    echo ""
    echo "  1) Full Installation        - Everything (recommended for new setups)"
    echo "  2) Minimal Installation     - Core components only"
    echo "  3) Config Only              - Just configuration files"
    echo "  4) Gaming Dependencies      - Install gaming packages"
    echo "  5) Photography Dependencies - Install photography packages"
    echo "  6) Streaming Dependencies   - Install streaming packages"
    echo "  7) Custom Selection         - Choose what to install"
    echo "  8) Uninstall                - Remove WehttamSnaps configuration"
    echo "  9) Help                     - Show help information"
    echo "  0) Exit"
    echo ""
    read -rp "Enter selection [0-9]: " choice
    
    case $choice in
        1) install_full ;;
        2) install_minimal ;;
        3) install_config_only ;;
        4) install_gaming_dependencies ;;
        5) install_photography_dependencies ;;
        6) install_streaming_dependencies ;;
        7) custom_selection ;;
        8) uninstall ;;
        9) show_help ;;
        0) echo "Goodbye!"; exit 0 ;;
        *) 
            log_error "Invalid selection"
            sleep 1
            show_menu
            ;;
    esac
}

custom_selection() {
    show_banner
    
    echo -e "${CYAN}Custom Selection - Choose components:${NC}"
    echo ""
    
    local install_base=""
    local install_gaming=""
    local install_photo=""
    local install_stream=""
    local install_niri=""
    local install_scripts=""
    
    read -rp "Install base dependencies? [Y/n]: " install_base
    read -rp "Install gaming packages? [y/N]: " install_gaming
    read -rp "Install photography packages? [Y/n]: " install_photo
    read -rp "Install streaming packages? [y/N]: " install_stream
    read -rp "Install Niri configuration? [Y/n]: " install_niri
    read -rp "Install scripts? [Y/n]: " install_scripts
    
    echo ""
    log_info "Starting custom installation..."
    
    [[ "$install_base" != "n" ]] && install_base_dependencies
    [[ "$install_gaming" == "y" ]] && install_gaming_dependencies
    [[ "$install_photo" != "n" ]] && install_photography_dependencies
    [[ "$install_stream" == "y" ]] && install_streaming_dependencies
    [[ "$install_niri" != "n" ]] && install_niri_config
    [[ "$install_scripts" != "n" ]] && install_scripts
    
    enable_services
    show_summary
}

uninstall() {
    show_banner
    
    log_warn "This will remove all WehttamSnaps configuration!"
    read -rp "Are you sure? [y/N]: " confirm
    
    if [[ "$confirm" == "y" ]]; then
        log_info "Removing configuration..."
        
        # Backup before removing
        backup_config "$WEHTTAMSNAPS_DIR"
        backup_config "$NIRI_DIR"
        
        rm -rf "$WEHTTAMSNAPS_DIR"
        rm -rf "$NIRI_DIR"
        
        log "WehttamSnaps configuration removed"
        log_info "Backup saved to: $BACKUP_DIR"
    else
        log_info "Uninstall cancelled"
    fi
}

show_help() {
    show_banner
    
    echo -e "${CYAN}WehttamSnaps Niri Setup - Help${NC}"
    echo ""
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  --full         Full installation (all components)"
    echo "  --minimal      Minimal installation (core only)"
    echo "  --config       Configuration files only"
    echo "  --gaming       Install gaming dependencies"
    echo "  --photo        Install photography dependencies"
    echo "  --stream       Install streaming dependencies"
    echo "  --help, -h     Show this help message"
    echo "  --version, -v  Show version information"
    echo ""
    echo "Without options, an interactive menu will be shown."
    echo ""
    echo "Hardware Requirements:"
    echo "  - Dell XPS 8700 or similar"
    echo "  - AMD Radeon RX 580 (or similar AMD GPU)"
    echo "  - 16GB RAM recommended"
    echo "  - Arch Linux or Arch-based distribution"
    echo ""
    echo "For more information, visit:"
    echo "  GitHub: https://github.com/Crowdrocker"
    echo "  Twitch: https://twitch.tv/WehttamSnaps"
    echo ""
}

# =============================================================================
# Main Entry Point
# =============================================================================

main() {
    # Check for command line arguments
    case "${1:-menu}" in
        --full|-f)
            install_full
            ;;
        --minimal|-m)
            install_minimal
            ;;
        --config|-c)
            install_config_only
            ;;
        --gaming|-g)
            install_gaming_dependencies
            ;;
        --photo|-p)
            install_photography_dependencies
            ;;
        --stream|-s)
            install_streaming_dependencies
            ;;
        --help|-h)
            show_help
            ;;
        --version|-v)
            echo "WehttamSnaps Niri Setup v$SCRIPT_VERSION"
            ;;
        menu)
            show_menu
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main
main "$@"