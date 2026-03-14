// =============================================================================
// MO2 Linux Helper - Tauri Backend
// =============================================================================
// A Tauri-based helper application for running Mod Organizer 2 on Linux
// Part of the WehttamSnaps Photography & Gaming Setup
// =============================================================================

#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use serde::{Deserialize, Serialize};
use std::path::PathBuf;
use std::process::Command;

// =============================================================================
// Data Structures
// =============================================================================

#[derive(Debug, Serialize, Deserialize)]
pub struct GameInfo {
    pub name: String,
    pub app_id: String,
    pub proton_path: PathBuf,
    pub mo2_path: PathBuf,
    pub mods_path: PathBuf,
    pub is_installed: bool,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct MO2Installation {
    pub path: PathBuf,
    pub version: String,
    pub games: Vec<GameInfo>,
    pub has_nxm_handler: bool,
}

// =============================================================================
// Commands
// =============================================================================

/// Get the default MO2 installation path
#[tauri::command]
fn get_mo2_path() -> PathBuf {
    dirs::home_dir()
        .unwrap_or_else(|| PathBuf::from("/home/user"))
        .join(".config")
        .join("mo2")
}

/// Check if MO2 is installed
#[tauri::command]
fn is_mo2_installed() -> bool {
    let mo2_path = get_mo2_path();
    mo2_path.join("ModOrganizer2").exists()
}

/// Get Steam library folders
#[tauri::command]
fn get_steam_libraries() -> Vec<PathBuf> {
    let mut libraries = Vec::new();
    
    // Default Steam library
    let steam_default = dirs::home_dir()
        .unwrap_or_else(|| PathBuf::from("/home/user"))
        .join(".steam")
        .join("steam");
    
    if steam_default.exists() {
        libraries.push(steam_default);
    }
    
    // Parse libraryfolders.vdf for additional libraries
    let library_vdf = steam_default.join("steamapps").join("libraryfolders.vdf");
    if library_vdf.exists() {
        // TODO: Parse VDF file for additional library paths
    }
    
    libraries
}

/// Get supported games
#[tauri::command]
fn get_supported_games() -> Vec<GameInfo> {
    vec![
        GameInfo {
            name: "Skyrim Special Edition".to_string(),
            app_id: "489830".to_string(),
            proton_path: PathBuf::new(),
            mo2_path: PathBuf::new(),
            mods_path: PathBuf::new(),
            is_installed: false,
        },
        GameInfo {
            name: "Skyrim Anniversary Edition".to_string(),
            app_id: "489830".to_string(),  // Same app ID, different content
            proton_path: PathBuf::new(),
            mo2_path: PathBuf::new(),
            mods_path: PathBuf::new(),
            is_installed: false,
        },
        GameInfo {
            name: "Fallout 4".to_string(),
            app_id: "377160".to_string(),
            proton_path: PathBuf::new(),
            mo2_path: PathBuf::new(),
            mods_path: PathBuf::new(),
            is_installed: false,
        },
        GameInfo {
            name: "Fallout New Vegas".to_string(),
            app_id: "22380".to_string(),
            proton_path: PathBuf::new(),
            mo2_path: PathBuf::new(),
            mods_path: PathBuf::new(),
            is_installed: false,
        },
        GameInfo {
            name: "Oblivion".to_string(),
            app_id: "22330".to_string(),
            proton_path: PathBuf::new(),
            mo2_path: PathBuf::new(),
            mods_path: PathBuf::new(),
            is_installed: false,
        },
    ]
}

/// Launch MO2 for a specific game
#[tauri::command]
fn launch_mo2(game_name: String) -> Result<String, String> {
    let mo2_path = get_mo2_path();
    let mo2_exe = mo2_path.join("ModOrganizer2").join("ModOrganizer.exe");
    
    if !mo2_exe.exists() {
        return Err("MO2 installation not found. Please install MO2 first.".to_string());
    }
    
    // Find Proton
    let proton_path = find_proton()?;
    
    // Build command
    let game_profile = mo2_path.join(&game_name);
    
    let output = Command::new(&proton_path)
        .env("STEAM_COMPAT_DATA_PATH", game_profile.join("prefix"))
        .env("STEAM_COMPAT_CLIENT_INSTALL_PATH", "")
        .arg("run")
        .arg(&mo2_exe)
        .output()
        .map_err(|e| format!("Failed to launch MO2: {}", e))?;
    
    if output.status.success() {
        Ok(format!("Launched MO2 for {}", game_name))
    } else {
        Err(String::from_utf8_lossy(&output.stderr).to_string())
    }
}

/// Find Proton installation
fn find_proton() -> Result<PathBuf, String> {
    let steam_path = dirs::home_dir()
        .unwrap_or_else(|| PathBuf::from("/home/user"))
        .join(".steam")
        .join("steam");
    
    // Look for Proton-GE first
    let proton_ge = steam_path.join("compatibilitytools.d");
    if proton_ge.exists() {
        if let Ok(entries) = std::fs::read_dir(&proton_ge) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.is_dir() {
                    let proton = path.join("proton");
                    if proton.exists() {
                        return Ok(proton);
                    }
                }
            }
        }
    }
    
    // Fall back to Steam Proton
    let steam_proton = steam_path.join("steamapps").join("common");
    if steam_proton.exists() {
        if let Ok(entries) = std::fs::read_dir(&steam_proton) {
            for entry in entries.flatten() {
                let path = entry.path();
                if path.file_name()
                    .map(|n| n.to_string_lossy().starts_with("Proton"))
                    .unwrap_or(false)
                {
                    let proton = path.join("proton");
                    if proton.exists() {
                        return Ok(proton);
                    }
                }
            }
        }
    }
    
    Err("Proton not found. Please install Proton or Proton-GE.".to_string())
}

/// Install MO2
#[tauri::command]
fn install_mo2(install_path: String) -> Result<String, String> {
    let path = PathBuf::from(&install_path);
    
    // Create installation directory
    std::fs::create_dir_all(&path)
        .map_err(|e| format!("Failed to create directory: {}", e))?;
    
    // TODO: Download and extract MO2
    // For now, return instructions
    Ok(format!(
        "MO2 installation directory created at {}.\n\
         Please download MO2 from https://www.modorganizer2.org/ and extract to this location.",
        install_path
    ))
}

/// Configure NXM link handler
#[tauri::command]
fn configure_nxm_handler() -> Result<String, String> {
    let mo2_path = get_mo2_path();
    let nxm_handler = mo2_path.join("nxm-handler.sh");
    
    // Create NXM handler script
    let script = format!(r#"#!/bin/bash
# MO2 NXM Handler for Linux
# Generated by MO2 Linux Helper

MO2_PATH="{}"
GAME="$1"
MOD_URL="$2"

# Launch MO2 with the NXM link
"$MO2_PATH/ModOrganizer2/ModOrganizer.exe" "$MOD_URL"
"#, mo2_path.display());
    
    std::fs::write(&nxm_handler, script)
        .map_err(|e| format!("Failed to create NXM handler: {}", e))?;
    
    // Make executable
    Command::new("chmod")
        .arg("+x")
        .arg(&nxm_handler)
        .output()
        .map_err(|e| format!("Failed to make executable: {}", e))?;
    
    Ok(format!("NXM handler created at {}", nxm_handler.display()))
}

// =============================================================================
// Main
// =============================================================================

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            get_mo2_path,
            is_mo2_installed,
            get_steam_libraries,
            get_supported_games,
            launch_mo2,
            install_mo2,
            configure_nxm_handler,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}