#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ADD THESE FUNCTIONS TO YOUR EXISTING /usr/local/bin/sound-system
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# These are new sound commands to support app launch sounds
# Add them to the case statement at the bottom of your sound-system script
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ═══════════════════════════════════════════════════════════════════════════════
# ADD THESE NEW FUNCTIONS (paste into sound-system before the case statement)
# ═══════════════════════════════════════════════════════════════════════════════

# App launch sounds
launch_terminal() {
    play_sound "open-terminal"
}

launch_browser() {
    play_sound "launch-browser"
}

launch_editor() {
    play_sound "launch-editor"
}

launch_files() {
    play_sound "open-files"
}

launch_obs() {
    play_sound "launch-obs"
}

launch_spotify() {
    play_sound "launch-spotify"
}

launch_discord() {
    play_sound "launch-discord"
}

# Config reload
config_reload() {
    play_sound "reload"
}

# ═══════════════════════════════════════════════════════════════════════════════
# ADD THESE TO THE case STATEMENT AT THE BOTTOM
# ═══════════════════════════════════════════════════════════════════════════════

# App launches
launch-terminal) launch_terminal ;;
launch-browser) launch_browser ;;
launch-editor) launch_editor ;;
launch-files) launch_files ;;
launch-obs) launch_obs ;;
launch-spotify) launch_spotify ;;
launch-discord) launch_discord ;;

# Config
config-reload) config_reload ;;

# ═══════════════════════════════════════════════════════════════════════════════
# OR - SIMPLIFIED VERSION (just add to case statement directly)
# ═══════════════════════════════════════════════════════════════════════════════

# App launches (inline)
launch-terminal) play_sound "open-terminal" ;;
launch-browser) play_sound "launch-browser" ;;
launch-editor) play_sound "launch-editor" ;;
launch-files) play_sound "open-files" ;;
launch-obs) play_sound "launch-obs" ;;
launch-spotify) play_sound "launch-spotify" ;;
launch-discord) play_sound "launch-discord" ;;
config-reload) play_sound "reload" ;;

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SOUND FILES NEEDED
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# For these new commands to work, you need these sound files:
#
# /usr/share/wehttamsnaps/sounds/jarvis/open-terminal.mp3
# /usr/share/wehttamsnaps/sounds/jarvis/launch-browser.mp3
# /usr/share/wehttamsnaps/sounds/jarvis/launch-editor.mp3
# /usr/share/wehttamsnaps/sounds/jarvis/open-files.mp3
# /usr/share/wehttamsnaps/sounds/jarvis/launch-obs.mp3
# /usr/share/wehttamsnaps/sounds/jarvis/launch-spotify.mp3
# /usr/share/wehttamsnaps/sounds/jarvis/launch-discord.mp3
# /usr/share/wehttamsnaps/sounds/jarvis/reload.mp3
#
# Suggested phrases:
#   open-terminal:  "Opening terminal."
#   launch-browser: "Launching browser."
#   launch-editor:  "Opening code editor, sir."
#   open-files:     "Opening file manager."
#   launch-obs:     "OBS Studio ready."
#   launch-spotify: "Opening Spotify."
#   launch-discord: "Opening Discord."
#   reload:         "Configuration reloaded, sir."
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━