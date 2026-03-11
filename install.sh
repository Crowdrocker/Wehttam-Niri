#!/usr/bin/env bash
#
# WehttamSnaps-SwayFx Installation Script
# ======================================
# Automated setup for the WehttamSnaps SwayFx workstation
#
# Usage: ./install.sh [options]
#
# Options:
#   --full        Full installation (default)
#   --config      Only copy configuration files
#   --sounds      Only setup sound system
#   --docs        Only copy documentation
#   --backup      Create backup of existing configs
#   --no-backup   Skip backup creation
#   --help        Show this help message
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/backups/sway-$(date +%Y%m%d_%H%M%S)"

# Default options
FULL_INSTALL=true
CONFIG_ONLY=false
SOUNDS_ONLY=false
DOCS_ONLY=false
CREATE_BACKUP=true

# Print functions
print_header() {
    echo -e "${MAGENTA}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║   ██████╗ ██╗    ██╗███████╗████████╗ ██████╗██╗  ██╗██╗      ║"
    echo "║   ██╔══██╗██║    ██║██╔════╝╚══██╔══╝██╔════╝██║  ██║██║      ║"
    echo "║   ██████╔╝██║ █╗ ██║█████╗     ██║   ██║     ███████║██║      ║"
    echo "║   ██╔══██╗██║███╗██║██╔══╝     ██║   ██║     ██╔══██║██║      ║"
    echo "║   ██║  ██║╚███╔███╔╝███████╗   ██║   ╚██████╗██║  ██║███████╗ ║"
    echo "║   ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚══════╝ ║"
    echo "║                                                                ║"
    echo "║                    S w a y F x   S e t u p                     ║"
    echo "║                                                                ║"
    echo "║              Gaming & Photography Workstation                  ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}▶ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Show help
show_help() {
    echo "WehttamSnaps-SwayFx Installation Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --full        Full installation (default)"
    echo "  --config      Only copy configuration files"
    echo "  --sounds      Only setup sound directories"
    echo "  --docs        Only copy documentation"
    echo "  --backup      Create backup of existing configs (default)"
    echo "  --no-backup   Skip backup creation"
    echo "  --help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Full installation with backup"
    echo "  $0 --config           # Only copy configs"
    echo "  $0 --no-backup        # Full installation without backup"
}

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full)
                FULL_INSTALL=true
                shift
                ;;
            --config)
                CONFIG_ONLY=true
                FULL_INSTALL=false
                shift
                ;;
            --sounds)
                SOUNDS_ONLY=true
                FULL_INSTALL=false
                shift
                ;;
            --docs)
                DOCS_ONLY=true
                FULL_INSTALL=false
                shift
                ;;
            --backup)
                CREATE_BACKUP=true
                shift
                ;;
            --no-backup)
                CREATE_BACKUP=false
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Check dependencies
check_dependencies() {
    print_step "Checking Dependencies"
    
    local missing_deps=()
    
    # Essential dependencies
    local deps=(
        "sway"
        "waybar"
        "rofi"
        "foot"
        "pipewire"
        "playerctl"
        "brightnessctl"
        "grim"
        "slurp"
        "wl-copy"
    )
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_warning "Missing dependencies: ${missing_deps[*]}"
        print_info "Install them with:"
        echo ""
        echo "  sudo pacman -S ${missing_deps[*]}"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "All essential dependencies found"
    fi
}

# Backup existing configs
backup_configs() {
    if [ "$CREATE_BACKUP" = false ]; then
        return
    fi
    
    print_step "Backing Up Existing Configurations"
    
    mkdir -p "$BACKUP_DIR"
    
    # Backup sway config
    if [ -d "$HOME/.config/sway" ]; then
        print_info "Backing up ~/.config/sway"
        cp -r "$HOME/.config/sway" "$BACKUP_DIR/sway"
    fi
    
    # Backup waybar config
    if [ -d "$HOME/.config/waybar" ]; then
        print_info "Backing up ~/.config/waybar"
        cp -r "$HOME/.config/waybar" "$BACKUP_DIR/waybar"
    fi
    
    # Backup rofi config
    if [ -d "$HOME/.config/rofi" ]; then
        print_info "Backing up ~/.config/rofi"
        cp -r "$HOME/.config/rofi" "$BACKUP_DIR/rofi"
    fi
    
    # Backup mako config
    if [ -d "$HOME/.config/mako" ]; then
        print_info "Backing up ~/.config/mako"
        cp -r "$HOME/.config/mako" "$BACKUP_DIR/mako"
    fi
    
    # Backup foot config
    if [ -d "$HOME/.config/foot" ]; then
        print_info "Backing up ~/.config/foot"
        cp -r "$HOME/.config/foot" "$BACKUP_DIR/foot"
    fi
    
    print_success "Backup created at: $BACKUP_DIR"
}

# Install configurations
install_configs() {
    print_step "Installing SwayFx Configurations"
    
    # Create directories
    mkdir -p "$HOME/.config/sway/config.d"
    mkdir -p "$HOME/.config/sway/scripts"
    mkdir -p "$HOME/.config/sway/sounds/jarvis"
    mkdir -p "$HOME/.config/sway/sounds/idroid"
    
    # Copy main config
    print_info "Copying main Sway config"
    cp "$SCRIPT_DIR/configs/swayfx/config" "$HOME/.config/sway/config"
    
    # Copy modular configs
    print_info "Copying modular configuration files"
    for config_file in "$SCRIPT_DIR/configs/swayfx/config.d"/*; do
        if [ -f "$config_file" ]; then
            filename=$(basename "$config_file")
            cp "$config_file" "$HOME/.config/sway/config.d/$filename"
            print_info "  - $filename"
        fi
    done
    
    # Copy scripts
    print_info "Copying scripts"
    for script in "$SCRIPT_DIR/configs/swayfx/scripts"/*; do
        if [ -f "$script" ]; then
            filename=$(basename "$script")
            cp "$script" "$HOME/.config/sway/scripts/$filename"
            chmod +x "$HOME/.config/sway/scripts/$filename"
            print_info "  - $filename (made executable)"
        fi
    done
    
    # Create user overrides file
    if [ ! -f "$HOME/.config/sway/config.d/user-overrides" ]; then
        print_info "Creating user overrides placeholder"
        cat > "$HOME/.config/sway/config.d/user-overrides" << 'EOF'
# User Overrides
# ==============
# Add your personal customizations here.
# This file will not be overwritten by updates.
#
# Examples:
#   bindsym $mod+Shift+N exec notify-send "Hello" "Custom binding"
#   exec --no-startup-id your-program
#   output * bg /path/to/wallpaper.jpg fill
EOF
    fi
    
    print_success "SwayFx configurations installed"
}

# Install sounds
install_sounds() {
    print_step "Setting Up Sound System"
    
    # Create sound directories
    mkdir -p "$HOME/.config/sway/sounds/jarvis"
    mkdir -p "$HOME/.config/sway/sounds/idroid"
    
    # Copy README files
    if [ -f "$SCRIPT_DIR/configs/sounds/README.md" ]; then
        cp "$SCRIPT_DIR/configs/sounds/README.md" "$HOME/.config/sway/sounds/"
    fi
    
    if [ -f "$SCRIPT_DIR/configs/sounds/jarvis/README.md" ]; then
        cp "$SCRIPT_DIR/configs/sounds/jarvis/README.md" "$HOME/.config/sway/sounds/jarvis/"
    fi
    
    if [ -f "$SCRIPT_DIR/configs/sounds/idroid/README.md" ]; then
        cp "$SCRIPT_DIR/configs/sounds/idroid/README.md" "$HOME/.config/sway/sounds/idroid/"
    fi
    
    print_info "Sound directories created at ~/.config/sway/sounds/"
    print_warning "Remember to add your J.A.R.V.I.S. and iDroid sound files!"
    print_info "  J.A.R.V.I.S.: ~/.config/sway/sounds/jarvis/"
    print_info "  iDroid:       ~/.config/sway/sounds/idroid/"
    
    print_success "Sound system directories ready"
}

# Install documentation
install_docs() {
    print_step "Installing Documentation"
    
    mkdir -p "$HOME/.local/share/doc/wehttamsnaps-swayfx"
    
    if [ -d "$SCRIPT_DIR/docs" ]; then
        for doc in "$SCRIPT_DIR/docs"/*.md; do
            if [ -f "$doc" ]; then
                filename=$(basename "$doc")
                cp "$doc" "$HOME/.local/share/doc/wehttamsnaps-swayfx/$filename"
                print_info "  - $filename"
            fi
        done
    fi
    
    # Copy main README
    if [ -f "$SCRIPT_DIR/README.md" ]; then
        cp "$SCRIPT_DIR/README.md" "$HOME/.local/share/doc/wehttamsnaps-swayfx/"
    fi
    
    print_success "Documentation installed to ~/.local/share/doc/wehttamsnaps-swayfx/"
}

# Configure gaming optimizations
configure_gaming() {
    print_step "Configuring Gaming Optimizations"
    
    # Check if GameMode is installed
    if command -v gamemoded &> /dev/null; then
        print_info "GameMode found, enabling service"
        systemctl --user enable gamemoded 2>/dev/null || true
        systemctl --user start gamemoded 2>/dev/null || true
        print_success "GameMode service enabled"
    else
        print_warning "GameMode not installed. Install with: sudo pacman -S gamemode"
    fi
    
    # Create gamemode config
    if [ ! -f "$HOME/.config/gamemode.ini" ]; then
        print_info "Creating GameMode configuration"
        cat > "$HOME/.config/gamemode.ini" << 'EOF'
[general]
renice = 10
ioprio = 0

[gpu]
apply_gpu_optimisations = accept-responsibility
gpu_device = 0
amd_performance_level = high

[cpu]
park_cores = no
pin_cores = no

[supervisor]
supervisor = systemd
EOF
        print_success "GameMode configuration created"
    fi
    
    # Add environment variables
    if ! grep -q "RADV_PERFTEST" "$HOME/.config/sway/config.d/env" 2>/dev/null; then
        print_info "Adding AMD GPU optimizations"
        mkdir -p "$HOME/.config/sway/config.d"
        cat >> "$HOME/.config/sway/config.d/env" << 'EOF'

# AMD GPU Optimizations
exec_always --no-startup-id echo "RADV_PERFTEST=gpl,nosam" >> /etc/environment
exec_always --no-startup-id echo "mesa_glthread=true" >> /etc/environment
EOF
    fi
}

# Configure audio
configure_audio() {
    print_step "Configuring Audio System"
    
    # Check PipeWire
    if systemctl --user is-active pipewire &>/dev/null; then
        print_success "PipeWire is running"
    else
        print_warning "PipeWire not running. Starting..."
        systemctl --user start pipewire pipewire-pulse wireplumber 2>/dev/null || true
    fi
    
    # Run audio setup script if it exists
    if [ -f "$HOME/.config/sway/scripts/audio-setup.sh" ]; then
        print_info "Running audio setup script"
        "$HOME/.config/sway/scripts/audio-setup.sh" 2>/dev/null || true
    fi
}

# Final setup
final_setup() {
    print_step "Final Setup"
    
    # Make all scripts executable
    print_info "Ensuring all scripts are executable"
    find "$HOME/.config/sway/scripts" -type f -exec chmod +x {} \; 2>/dev/null || true
    
    # Create Screenshots directory
    mkdir -p "$HOME/Pictures/Screenshots"
    
    # Reload Sway if running
    if pgrep -x "sway" > /dev/null; then
        print_info "Sway is running. Reload configuration with: Super + Shift + C"
    fi
    
    print_success "Setup complete!"
}

# Main installation
main() {
    print_header
    parse_args "$@"
    
    print_info "Installation type: $([ "$FULL_INSTALL" = true ] && echo "Full" || echo "Partial")"
    print_info "Create backup: $CREATE_BACKUP"
    
    if [ "$FULL_INSTALL" = true ]; then
        check_dependencies
        backup_configs
        install_configs
        install_sounds
        install_docs
        configure_gaming
        configure_audio
        final_setup
    elif [ "$CONFIG_ONLY" = true ]; then
        backup_configs
        install_configs
        final_setup
    elif [ "$SOUNDS_ONLY" = true ]; then
        install_sounds
    elif [ "$DOCS_ONLY" = true ]; then
        install_docs
    fi
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    Installation Complete!                      ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Next Steps:${NC}"
    echo "  1. Add your J.A.R.V.I.S. sounds: ~/.config/sway/sounds/jarvis/"
    echo "  2. Add your iDroid sounds:       ~/.config/sway/sounds/idroid/"
    echo "  3. Customize your setup:         ~/.config/sway/config.d/user-overrides"
    echo "  4. Read the documentation:       ~/.local/share/doc/wehttamsnaps-swayfx/"
    echo ""
    echo -e "${CYAN}Start Sway:${NC}"
    echo "  sway --unsupported-gpu"
    echo ""
    echo -e "${MAGENTA}Welcome to WehttamSnaps-SwayFx, Matthew!${NC}"
    echo -e "${CYAN}Your gaming and photography workstation is ready.${NC}"
    echo ""
}

# Run main
main "$@"