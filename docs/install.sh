#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# WEHTTAMSNAPS DOTFILES AUTO-INSTALLER (CACHYOS EDITION)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 1. Sync Binaries
echo "🚀 Installing system binaries..."
sudo cp ./bin/sound-system /usr/local/bin/
sudo cp ./bin/workmode /usr/local/bin/
sudo cp ./bin/gamemode /usr/local/bin/
sudo chmod +x /usr/local/bin/sound-system /usr/local/bin/workmode /usr/local/bin/gamemode

# 2. Sync Configs
echo "📁 Syncing configurations..."
mkdir -p ~/.config/niri/snaps ~/.config/fastfetch/logos
cp ./config/.aliases ~/.config/wehttamsnaps/shell/.aliases
cp ./.bashrc ~/.bashrc
cp ./config/fastfetch/config.jsonc ~/.config/fastfetch/
cp ./config/fastfetch/logos/wehttamsnaps.txt ~/.config/fastfetch/logos/

# 3. Handle GPU Permissions for RX 580
echo "⚡ Setting GPU performance permissions..."
RULE="wehttamsnaps ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/drm/card0/device/power_dpm_force_performance_level"
if ! sudo grep -q "$RULE" /etc/sudoers; then
    echo "$RULE" | sudo tee -a /etc/sudoers
fi

# 4. Final Shell Refresh
source ~/.bashrc
echo "✨ Installation complete. J.A.R.V.I.S. is now online."
