#!/usr/bin/env bash
# =============================================================================
# WEHTTAMSNAPS - GameMode Toggle Script
# =============================================================================
# Toggles gaming optimizations on/off for the WehttamSnaps Photography setup
# Integrates with JARVIS sound system for voice feedback
# =============================================================================

# Configuration
GAMEMODE_CONFIG="$HOME/.config/wehttamsnaps/gamemode.conf"
NOTIFY_APP="notify-send"
GAMING_ICON="🎮"
WORK_ICON="📷"

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# =============================================================================
# Functions
# =============================================================================

log() {
    echo -e "${CYAN}[GameMode]${NC} $1"
}

error() {
    echo -e "${RED}[GameMode ERROR]${NC} $1"
}

notify() {
    local title="$1"
    local message="$2"
    local icon="$3"
    $NOTIFY_APP -a "WehttamSnaps" "$title" "$message" -h string:x-canonical-private-synchronous:gamemode &
}

# Check if gamemode is currently active
is_gamemode_active() {
    if command -v gamemode &>/dev/null; then
        gamemode-query 2>/dev/null | grep -q "active"
        return $?
    fi
    
    # Fallback: check our config file
    if [[ -f "$GAMEMODE_CONFIG" ]]; then
        source "$GAMEMODE_CONFIG"
        [[ "$GAMEMODE_ACTIVE" == "true" ]]
        return $?
    fi
    
    return 1
}

# Enable gaming mode
enable_gamemode() {
    log "Enabling Gaming Mode..."
    
    # Create config directory if needed
    mkdir -p "$(dirname "$GAMEMODE_CONFIG")"
    
    # Set environment variables for gaming
    export RADV_PERFTEST="nocache,gt"
    export mesa_glthread=true
    export DXVK_STATE_CACHE_PATH="$HOME/.cache/dxvk-cache"
    export PROTON_ENABLE_NVAPI=1
    export PROTON_HIDE NVIDIA_GPU=0
    export WINE_FULLSCREEN_FSR=1
    export WINE_FULLSCREEN_FSR_STRENGTH=2
    
    # Enable GameMode if installed
    if command -v gamemode &>/dev/null; then
        gamemoded -a 2>/dev/null
        log "GameMode daemon activated"
    fi
    
    # Set CPU performance governor
    if [[ -w /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ]]; then
        echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null
        log "CPU governor set to performance"
    fi
    
    # Switch JARVIS to iDroid voice (gaming persona)
    if [[ -x "$HOME/.config/wehttamsnaps/scripts/sound-system" ]]; then
        "$HOME/.config/wehttamsnaps/scripts/sound-system" gaming 2>/dev/null
        log "Switched to iDroid voice"
    fi
    
    # Apply gaming color scheme (optional - uncomment if desired)
    # if [[ -f "$HOME/.config/niri/themes/gaming.kdl" ]]; then
    #     cp "$HOME/.config/niri/themes/gaming.kdl" "$HOME/.config/niri/current-theme.kdl"
    #     niri msg action reload-config
    # fi
    
    # Update config file
    cat > "$GAMEMODE_CONFIG" << EOF
GAMEMODE_ACTIVE=true
GAMEMODE_STARTED=\$(date +%s)
EOF
    
    # Notify user
    notify "Gaming Mode ${GAMING_ICON}" "Gaming optimizations enabled!\n• GameMode active\n• CPU performance mode\n• iDroid voice assistant" "$GAMING_ICON"
    
    log "${GREEN}Gaming Mode ENABLED${NC}"
    
    # Play activation sound
    play_sound "gaming-on"
}

# Disable gaming mode
disable_gamemode() {
    log "Disabling Gaming Mode..."
    
    # Disable GameMode if installed
    if command -v gamemode &>/dev/null; then
        gamemoded -r 2>/dev/null
        log "GameMode daemon deactivated"
    fi
    
    # Reset CPU governor to powersave/ondemand
    if [[ -w /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ]]; then
        echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || \
        echo "ondemand" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null
        log "CPU governor reset"
    fi
    
    # Switch JARVIS back to default voice
    if [[ -x "$HOME/.config/wehttamsnaps/scripts/sound-system" ]]; then
        "$HOME/.config/wehttamsnaps/scripts/sound-system" default 2>/dev/null
        log "Switched to JARVIS voice"
    fi
    
    # Restore default color scheme (optional)
    # if [[ -f "$HOME/.config/niri/themes/default.kdl" ]]; then
    #     cp "$HOME/.config/niri/themes/default.kdl" "$HOME/.config/niri/current-theme.kdl"
    #     niri msg action reload-config
    # fi
    
    # Update config file
    cat > "$GAMEMODE_CONFIG" << EOF
GAMEMODE_ACTIVE=false
GAMEMODE_STOPPED=\$(date +%s)
EOF
    
    # Notify user
    notify "Work Mode ${WORK_ICON}" "Gaming optimizations disabled.\n• GameMode off\n• CPU power saving\n• JARVIS voice assistant" "$WORK_ICON"
    
    log "${PURPLE}Work Mode Restored${NC}"
    
    # Play deactivation sound
    play_sound "gaming-off"
}

# Play sound effect
play_sound() {
    local sound_type="$1"
    local sound_dir="$HOME/.config/wehttamsnaps/sounds"
    
    if [[ -d "$sound_dir" ]]; then
        case "$sound_type" in
            "gaming-on")
                if [[ -f "$sound_dir/idroid-activate.wav" ]]; then
                    pw-play "$sound_dir/idroid-activate.wav" 2>/dev/null &
                elif [[ -f "$sound_dir/game-on.wav" ]]; then
                    pw-play "$sound_dir/game-on.wav" 2>/dev/null &
                fi
                ;;
            "gaming-off")
                if [[ -f "$sound_dir/idroid-deactivate.wav" ]]; then
                    pw-play "$sound_dir/idroid-deactivate.wav" 2>/dev/null &
                elif [[ -f "$sound_dir/game-off.wav" ]]; then
                    pw-play "$sound_dir/game-off.wav" 2>/dev/null &
                fi
                ;;
        esac
    fi
}

# Show status
show_status() {
    if is_gamemode_active; then
        echo -e "${GREEN}● Gaming Mode: ACTIVE${NC}"
        echo "  • GameMode: Enabled"
        echo "  • CPU: Performance mode"
        echo "  • Voice: iDroid"
        
        if [[ -f "$GAMEMODE_CONFIG" ]]; then
            source "$GAMEMODE_CONFIG"
            if [[ -n "$GAMEMODE_STARTED" ]]; then
                local duration=$(( $(date +%s) - GAMEMODE_STARTED ))
                echo "  • Duration: $(printf '%02d:%02d:%02d' $((duration/3600)) $((duration%3600/60)) $((duration%60)))"
            fi
        fi
    else
        echo -e "${PURPLE}● Work Mode: ACTIVE${NC}"
        echo "  • GameMode: Disabled"
        echo "  • CPU: Power saving"
        echo "  • Voice: JARVIS"
    fi
}

# =============================================================================
# Main
# =============================================================================

case "${1:-toggle}" in
    on|enable|start)
        enable_gamemode
        ;;
    off|disable|stop)
        disable_gamemode
        ;;
    toggle)
        if is_gamemode_active; then
            disable_gamemode
        else
            enable_gamemode
        fi
        ;;
    status|query)
        show_status
        ;;
    *)
        echo "Usage: $0 {on|off|toggle|status}"
        echo ""
        echo "Commands:"
        echo "  on, enable, start  - Enable gaming mode"
        echo "  off, disable, stop - Disable gaming mode"
        echo "  toggle             - Toggle gaming mode (default)"
        echo "  status, query      - Show current status"
        exit 1
        ;;
esac