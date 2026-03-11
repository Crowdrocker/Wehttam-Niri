#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════════
# WEHTTAMSNAPS GAMING MODE TOGGLE
# ════════════════════════════════════════════════════════════════════════════════
# Toggles gaming mode for maximum performance
# - Disables SwayFX effects (blur, shadows)
# - Sets CPU to performance mode
# - Switches sound system to iDroid mode
# - Enables GameMode

set -euo pipefail

# Configuration
STATE_FILE="$HOME/.cache/wehttamsnaps/gaming-mode.active"
SWAYFX_GAMING_CONFIG="/tmp/swayfx-gaming.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ────────────────────────────────────────────────────────────────────────────────
# Enable Gaming Mode
# ────────────────────────────────────────────────────────────────────────────────
enable_gaming_mode() {
    echo -e "${CYAN}🎮 Enabling Gaming Mode...${NC}"
    
    # Create state file
    mkdir -p "$(dirname "$STATE_FILE")"
    touch "$STATE_FILE"
    
    # Disable SwayFX effects for performance
    cat > "$SWAYFX_GAMING_CONFIG" << 'EOF'
# Gaming Mode - Effects Disabled
blur disable
shadows disable
corner_radius 0
default_dim_inactive 0.0
EOF
    
    swaymsg include "$SWAYFX_GAMING_CONFIG"
    
    # Set CPU to performance mode
    if command -v gamemode &> /dev/null; then
        gamemode -r true 2>/dev/null || true
    fi
    
    # Set CPU governor to performance
    if [[ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || true
    fi
    
    # Switch sound system to iDroid
    if command -v sound-system &> /dev/null; then
        sound-system mode idroid
    fi
    
    # Notification
    notify-send "🎮 Gaming Mode" "Enabled - iDroid active\nEffects disabled for performance" -i input-gaming
    
    # Play gaming mode sound
    if command -v sound-system &> /dev/null; then
        sound-system gaming-toggle 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✓ Gaming Mode enabled${NC}"
}

# ────────────────────────────────────────────────────────────────────────────────
# Disable Gaming Mode
# ────────────────────────────────────────────────────────────────────────────────
disable_gaming_mode() {
    echo -e "${CYAN}🖥️ Disabling Gaming Mode...${NC}"
    
    # Remove state file
    rm -f "$STATE_FILE"
    
    # Re-enable SwayFX effects
    rm -f "$SWAYFX_GAMING_CONFIG"
    
    # Reload SwayFX config to restore effects
    swaymsg reload
    
    # Disable GameMode
    if command -v gamemode &> /dev/null; then
        gamemode -r false 2>/dev/null || true
    fi
    
    # Set CPU governor to powersave
    if [[ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
        echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || true
    fi
    
    # Switch sound system back to J.A.R.V.I.S.
    if command -v sound-system &> /dev/null; then
        sound-system mode jarvis
    fi
    
    # Notification
    notify-send "🖥️ Gaming Mode" "Disabled - J.A.R.V.I.S. active\nEffects restored" -i preferences-desktop
    
    # Play gaming mode off sound
    if command -v sound-system &> /dev/null; then
        sound-system gaming-toggle 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✓ Gaming Mode disabled${NC}"
}

# ────────────────────────────────────────────────────────────────────────────────
# Toggle Gaming Mode
# ────────────────────────────────────────────────────────────────────────────────
if [[ -f "$STATE_FILE" ]]; then
    disable_gaming_mode
else
    enable_gaming_mode
fi