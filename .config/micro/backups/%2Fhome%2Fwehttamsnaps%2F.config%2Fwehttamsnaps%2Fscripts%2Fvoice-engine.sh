#!/bin/bash
# WehttamSnaps Voice Engine - J.A.R.V.I.S. & iDroid Integration

JARVIS_DIR="/usr/share/wehttamsnaps/sounds/jarvis"
IDROID_DIR="/usr/share/wehttamsnaps/sounds/idroid"
PLAYER="mpv --no-video" # Using mpv for mp3 support

case $1 in
    # --- System Events ---

    # --- Productivity Tools ---
    "terminal")     $PLAYER "$JARVIS_DIR/opening-terminal.mp3" ;;
    "files")        $PLAYER "$JARVIS_DIR/opening-files.mp3" ;;
    "screenshot")   $PLAYER "$JARVIS_DIR/jarvis-screen-capture.mp3" ;;
    "export")       $PLAYER "$JARVIS_DIR/photo-export.mp3" ;;

    # --- Gaming Mode (iDroid) ---
    "gamemode-on")  $PLAYER "$IDROID_DIR/gamemode-on.mp3" ;;
    "gamemode-off") $PLAYER "$IDROID_DIR/gamemode-off.mp3" ;;
    "steam")        $PLAYER "$IDROID_DIR/steam-launch.mp3" ;;

    # --- Layouts ---
    "float")        $PLAYER "$JARVIS_DIR/window-float.mp3" ;;
    "fullscreen")   $PLAYER "$JARVIS_DIR/window-fullscreen.mp3" ;;
    *)              exit 1 ;;

    # Add these inside the 'case $1 in' block:
    "browser")      $PLAYER "$JARVIS_DIR/accessing-web.mp3" ;;
    "spotify")      $PLAYER "$JARVIS_DIR/initializing-audio.mp3" ;;
    "obs")          $PLAYER "$JARVIS_DIR/broadcast-ready.mp3" ;;
    "discord")      $PLAYER "$JARVIS_DIR/comms-online.mp3" ;;
    "edit-config")  $PLAYER "$JARVIS_DIR/accessing-core-files.mp3" ;;
esac
