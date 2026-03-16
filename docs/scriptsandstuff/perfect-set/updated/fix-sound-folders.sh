#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# WehttamSnaps - Sound Folder Cleanup
# Run once to fix misplaced/duplicate files per jarvis_sounds_and_notes.md
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

JARVIS_DIR="/usr/share/wehttamsnaps/sounds/jarvis"
IDROID_DIR="/usr/share/wehttamsnaps/sounds/idroid"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  J.A.R.V.I.S. Sound Folder Cleanup${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ── Step 1: Move jarvis files that ended up in idroid/ ────────────
echo -e "${YELLOW}Step 1: Moving misplaced jarvis files out of idroid/...${NC}"

for name in jarvis-greeting jarvis-startup; do
    for ext in mp3 wav; do
        src="$IDROID_DIR/${name}.${ext}"
        dst="$JARVIS_DIR/${name}.${ext}"
        if [[ -f "$src" ]]; then
            if [[ -f "$dst" ]]; then
                echo -e "  ${YELLOW}⚠${NC}  $dst already exists — skipping move, remove duplicate manually if needed"
            else
                mv "$src" "$dst"
                echo -e "  ${GREEN}✓${NC}  Moved: idroid/${name}.${ext} → jarvis/"
            fi
        fi
    done
done

# ── Step 2: Delete jarvis-prefixed duplicates from idroid/ ────────
echo ""
echo -e "${YELLOW}Step 2: Removing jarvis-* duplicates from idroid/...${NC}"

TO_DELETE=(
    "jarvis-alert-high"
    "jarvis-alert-medium"
    "jarvis-gamemode-off"
    "jarvis-gamemode-on"
    "jarvis-mission-start"
    "jarvis-performance-warn"
)

for name in "${TO_DELETE[@]}"; do
    found=0
    for ext in mp3 wav; do
        f="$IDROID_DIR/${name}.${ext}"
        if [[ -f "$f" ]]; then
            rm "$f"
            echo -e "  ${RED}✗${NC}  Deleted: idroid/${name}.${ext}"
            found=1
        fi
    done
    if [[ $found -eq 0 ]]; then
        echo -e "  ${CYAN}–${NC}  Not found (already clean): $name"
    fi
done

# ── Step 3: Summary ───────────────────────────────────────────────
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Done! Run 'sound-system list' to verify.${NC}"
echo ""
