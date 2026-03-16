#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════
#   WehttamSnaps — Install Rofi Theme + Update i3 Bindings
#   Run: bash install-rofi.sh
# ═══════════════════════════════════════════════════════════════════════
set -euo pipefail
GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
info() { echo -e "  ${CYAN}→${NC} $1"; }

THEME_DIR="$HOME/.config/rofi/themes"
THEME="$THEME_DIR/wehttamsnaps.rasi"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
I3_CONFIG="$HOME/.config/i3/config"

# ── 1. Install rofi if missing ──────────────────────────────────────────
if ! command -v rofi &>/dev/null; then
    info "Installing rofi..."
    sudo pacman -S --noconfirm rofi
fi
ok "rofi available: $(rofi -version | head -1)"

# ── 2. Copy theme file ──────────────────────────────────────────────────
mkdir -p "$THEME_DIR"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/wehttamsnaps.rasi" ]]; then
    cp "$SCRIPT_DIR/wehttamsnaps.rasi" "$THEME"
    ok "Theme copied → $THEME"
else
    echo "  wehttamsnaps.rasi not found next to this script"
    echo "  Put wehttamsnaps.rasi in the same folder as install-rofi.sh"
    exit 1
fi

# ── 3. Write rofi global config ─────────────────────────────────────────
cat > "$ROFI_CONFIG" << ROFIEOF
/* WehttamSnaps rofi global config */
configuration {
    modi:           "drun,run,window";
    show-icons:     true;
    icon-theme:     "Papirus-Dark";
    drun-display-format: "{name}";
    display-drun:   " Apps";
    display-run:    " Run";
    display-window: " Windows";
    font:           "JetBrains Mono 11";
    matching:       "fuzzy";
    sort:           true;
    sorting-method: "fzf";
    scroll-method:  0;
    kb-cancel:      "Escape,Super+d";
}

@theme "$THEME"
ROFIEOF
ok "Rofi config written → $ROFI_CONFIG"

# ── 4. Patch i3 config to pass theme to all rofi calls ─────────────────
if [[ -f "$I3_CONFIG" ]]; then
    # Replace bare rofi drun call with themed one
    sed -i "s|exec rofi -show drun$|exec rofi -show drun -theme $THEME|g" "$I3_CONFIG"
    sed -i "s|exec rofi -show drun -theme.*$|exec rofi -show drun -theme $THEME|g" "$I3_CONFIG"
    ok "i3 config patched — \$mod+d now uses WehttamSnaps theme"

    # Reload i3
    i3-msg reload 2>/dev/null && ok "i3 reloaded" || \
        info "Press Super+Shift+R to reload i3"
fi

# ── 5. Install icon theme for app icons ────────────────────────────────
if ! pacman -Qi papirus-icon-theme &>/dev/null; then
    info "Installing Papirus icon theme for app icons in rofi..."
    sudo pacman -S --noconfirm papirus-icon-theme
    ok "Papirus-Dark icons installed"
else
    ok "Papirus icons already installed"
fi

# ── 6. Test it ─────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}Done! Test it now:${NC}"
echo -e "  Press  ${CYAN}Super + D${NC}  to open the launcher"
echo -e ""
echo -e "  Or preview directly:"
echo -e "  ${CYAN}rofi -show drun -theme $THEME${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Keybinds:"
echo -e "  ${CYAN}Super+D${NC}        App launcher (drun)"
echo -e "  ${CYAN}Super+Space${NC}    JARVIS menu"
echo -e "  ${CYAN}Super+Slash${NC}    JARVIS free command"
echo -e "  ${CYAN}Alt+Tab${NC}        Window switcher (add to i3 if wanted)"
echo ""
