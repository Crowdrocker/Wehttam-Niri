#!/usr/bin/env bash
# =============================================================================
# WEHTTAMSNAPS - Audio Setup Script
# =============================================================================
# Configures PipeWire audio routing for streaming, gaming, and recording
# Supports qpwgraph integration for visual audio management
# =============================================================================

# Configuration
CONFIG_DIR="$HOME/.config/wehttamsnaps/audio"
AUDIO_PROFILES_DIR="$CONFIG_DIR/profiles"
CURRENT_PROFILE="$CONFIG_DIR/current-profile.conf"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# =============================================================================
# Functions
# =============================================================================

log() {
    echo -e "${CYAN}[Audio]${NC} $1"
}

error() {
    echo -e "${RED}[Audio ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[Audio]${NC} $1"
}

# Check PipeWire status
check_pipewire() {
    if ! pgrep -x pipewire &>/dev/null; then
        error "PipeWire is not running!"
        echo "Start PipeWire with: systemctl --user start pipewire pipewire-pulse"
        return 1
    fi
    success "PipeWire is running"
    return 0
}

# List audio devices
list_devices() {
    log "Available Audio Devices:"
    echo ""
    
    echo -e "${YELLOW}Speakers/Output:${NC}"
    wpctl status | grep -A 20 "Sinks:" | head -n 15
    
    echo ""
    echo -e "${YELLOW}Microphones/Input:${NC}"
    wpctl status | grep -A 10 "Sources:" | head -n 10
    
    echo ""
    echo -e "${YELLOW}Audio Nodes (pw-cli):${NC}"
    pw-cli list-objects 2>/dev/null | grep -E "node\.name|node\.description" | head -n 20
}

# Set default output device
set_default_output() {
    local device_id="$1"
    
    if [[ -z "$device_id" ]]; then
        error "Please specify a device ID"
        echo "Use: $0 list"
        return 1
    fi
    
    wpctl set-default "$device_id"
    success "Set default output to device $device_id"
}

# Set default input device
set_default_input() {
    local device_id="$1"
    
    if [[ -z "$device_id" ]]; then
        error "Please specify a device ID"
        echo "Use: $0 list"
        return 1
    fi
    
    wpctl set-default "$device_id"
    success "Set default input to device $device_id"
}

# Set volume
set_volume() {
    local device_id="$1"
    local volume="$2"
    
    if [[ -z "$device_id" ]] || [[ -z "$volume" ]]; then
        error "Usage: $0 volume <device-id> <volume>"
        echo "Volume can be: 0-100 or +X% / -X%"
        return 1
    fi
    
    if [[ "$volume" == "+"* ]] || [[ "$volume" == "-"* ]]; then
        wpctl set-volume "$device_id" "${volume}%"
    else
        wpctl set-volume "$device_id" "${volume}%"
    fi
    
    success "Volume set for device $device_id"
}

# Toggle mute
toggle_mute() {
    local device_id="$1"
    
    if [[ -z "$device_id" ]]; then
        error "Please specify a device ID"
        return 1
    fi
    
    wpctl set-mute "$device_id" toggle
    success "Toggled mute for device $device_id"
}

# Create streaming audio profile
create_streaming_profile() {
    log "Creating streaming audio profile..."
    
    mkdir -p "$AUDIO_PROFILES_DIR"
    
    # Create streaming profile for OBS
    cat > "$AUDIO_PROFILES_DIR/streaming.sh" << 'EOF'
#!/usr/bin/env bash
# Streaming Audio Profile
# Routes: Mic -> Discord/Stream, Desktop Audio -> Stream, Monitor -> Headphones

# Set up virtual audio devices for streaming
pw-cli create-node adapter '{ 
    node.name = "streaming-mic" 
    media.class = "Audio/Source/Virtual"
    audio.position = [ MONO ]
}'

# Configure default routing for streaming
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.8
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.6

echo "Streaming audio profile loaded"
EOF
    
    chmod +x "$AUDIO_PROFILES_DIR/streaming.sh"
    success "Created streaming profile: $AUDIO_PROFILES_DIR/streaming.sh"
}

# Create gaming audio profile
create_gaming_profile() {
    log "Creating gaming audio profile..."
    
    mkdir -p "$AUDIO_PROFILES_DIR"
    
    cat > "$AUDIO_PROFILES_DIR/gaming.sh" << 'EOF'
#!/usr/bin/env bash
# Gaming Audio Profile
# Optimized for low latency and immersive audio

# Set audio latency to minimal for gaming
pw-metadata -n settings 0 clock.force-quantum 256
pw-metadata -n settings 0 clock.force-rate 48000

# Boost volume slightly for immersive gaming
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.9

echo "Gaming audio profile loaded"
EOF
    
    chmod +x "$AUDIO_PROFILES_DIR/gaming.sh"
    success "Created gaming profile: $AUDIO_PROFILES_DIR/gaming.sh"
}

# Create recording audio profile
create_recording_profile() {
    log "Creating recording audio profile..."
    
    mkdir -p "$AUDIO_PROFILES_DIR"
    
    cat > "$AUDIO_PROFILES_DIR/recording.sh" << 'EOF'
#!/usr/bin/env bash
# Recording Audio Profile
# High-quality settings for photography/video work

# Set higher latency for stable recording
pw-metadata -n settings 0 clock.force-quantum 1024
pw-metadata -n settings 0 clock.force-rate 48000

# Balanced volume for monitoring
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.7
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.5

echo "Recording audio profile loaded"
EOF
    
    chmod +x "$AUDIO_PROFILES_DIR/recording.sh"
    success "Created recording profile: $AUDIO_PROFILES_DIR/recording.sh"
}

# Load audio profile
load_profile() {
    local profile="$1"
    
    if [[ -z "$profile" ]]; then
        error "Please specify a profile name"
        echo "Available profiles:"
        ls -1 "$AUDIO_PROFILES_DIR" 2>/dev/null || echo "  (none created yet)"
        return 1
    fi
    
    local profile_path="$AUDIO_PROFILES_DIR/${profile}.sh"
    
    if [[ ! -f "$profile_path" ]]; then
        error "Profile not found: $profile_path"
        return 1
    fi
    
    source "$profile_path"
    echo "$profile" > "$CURRENT_PROFILE"
    success "Loaded profile: $profile"
}

# Open qpwgraph for visual routing
open_qpwgraph() {
    if command -v qpwgraph &>/dev/null; then
        log "Opening qpwgraph for visual audio routing..."
        qpwgraph &
        success "qpwgraph launched"
    else
        error "qpwgraph is not installed"
        echo "Install with: sudo pacman -S qpwgraph"
        return 1
    fi
}

# Open Helvum for patch bay
open_helvum() {
    if command -v helvum &>/dev/null; then
        log "Opening Helvum patch bay..."
        helvum &
        success "Helvum launched"
    else
        error "Helvum is not installed"
        echo "Install with: sudo pacman -S helvum"
        return 1
    fi
}

# Show current audio status
show_status() {
    log "Audio System Status:"
    echo ""
    
    check_pipewire
    echo ""
    
    echo -e "${YELLOW}Current Profile:${NC}"
    if [[ -f "$CURRENT_PROFILE" ]]; then
        echo "  $(cat "$CURRENT_PROFILE")"
    else
        echo "  Default (no profile loaded)"
    fi
    
    echo ""
    echo -e "${YELLOW}Default Devices:${NC}"
    wpctl status | grep -E "^\*"
    
    echo ""
    echo -e "${YELLOW}Audio Settings:${NC}"
    pw-metadata -n settings | grep -E "quantum|rate" || echo "  Using defaults"
}

# Create noise reduction filter
setup_noise_reduction() {
    log "Setting up noise reduction..."
    
    if ! command -v noisetorch &>/dev/null; then
        error "NoiseTorch is not installed"
        echo "Install from: https://github.com/noisetorch/NoiseTorch"
        echo "Or use: yay -S noisetorch-bin"
        return 1
    fi
    
    noisetorch -i
    success "Noise reduction enabled via NoiseTorch"
}

# =============================================================================
# Initialize
# =============================================================================

init_audio() {
    log "Initializing WehttamSnaps audio configuration..."
    
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$AUDIO_PROFILES_DIR"
    
    # Create default profiles
    create_streaming_profile
    create_gaming_profile
    create_recording_profile
    
    # Create default profile symlink
    echo "default" > "$CURRENT_PROFILE"
    
    success "Audio configuration initialized!"
    echo ""
    echo "Quick Start:"
    echo "  $0 list              - List audio devices"
    echo "  $0 profile gaming    - Load gaming profile"
    echo "  $0 profile streaming - Load streaming profile"
    echo "  $0 qpwgraph          - Open visual audio router"
}

# =============================================================================
# Main
# =============================================================================

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"
mkdir -p "$AUDIO_PROFILES_DIR"

case "${1:-help}" in
    init)
        init_audio
        ;;
    list|devices)
        check_pipewire
        list_devices
        ;;
    output)
        set_default_output "$2"
        ;;
    input)
        set_default_input "$2"
        ;;
    volume)
        set_volume "$2" "$3"
        ;;
    mute)
        toggle_mute "$2"
        ;;
    profile)
        load_profile "$2"
        ;;
    profiles)
        echo "Available audio profiles:"
        ls -1 "$AUDIO_PROFILES_DIR" 2>/dev/null || echo "  (none)"
        ;;
    create-profile)
        case "$2" in
            streaming) create_streaming_profile ;;
            gaming) create_gaming_profile ;;
            recording) create_recording_profile ;;
            *) 
                error "Unknown profile type: $2"
                echo "Available: streaming, gaming, recording"
                ;;
        esac
        ;;
    qpwgraph)
        open_qpwgraph
        ;;
    helvum)
        open_helvum
        ;;
    status)
        show_status
        ;;
    noise|noisereduction)
        setup_noise_reduction
        ;;
    check)
        check_pipewire
        ;;
    help|--help|-h)
        echo "WehttamSnaps Audio Setup"
        echo ""
        echo "Usage: $0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "  init                Initialize audio configuration"
        echo "  list, devices       List available audio devices"
        echo "  output <id>         Set default output device"
        echo "  input <id>          Set default input device"
        echo "  volume <id> <vol>   Set volume (0-100 or +/-X%)"
        echo "  mute <id>           Toggle mute for device"
        echo "  profile <name>      Load audio profile"
        echo "  profiles            List available profiles"
        echo "  qpwgraph            Open qpwgraph visual router"
        echo "  helvum              Open Helvum patch bay"
        echo "  status              Show current audio status"
        echo "  noise               Setup noise reduction"
        echo "  check               Check PipeWire status"
        echo ""
        echo "Examples:"
        echo "  $0 list                  # List all devices"
        echo "  $0 volume 45 80          # Set device 45 to 80%"
        echo "  $0 profile gaming        # Load gaming audio profile"
        ;;
    *)
        error "Unknown command: $1"
        echo "Use: $0 help"
        exit 1
        ;;
esac