#!/usr/bin/env bash

# --- Configuration ---
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PACKAGES=("hypr" "systemd" "kitty" "waybar" "wlogout", "dunst")
ALL_SOFTWARE=(
    "noto-fonts-emoji" 
    "ttf-jetbrains-mono-nerd" 
    "wlogout"
    "hyprshutdown"
    "hyprlock"
    "hypridle"
    "fastfetch"
    "stow"
    "git"
    "base-devel"
    "wl-clipboard"
    "cliphist"
    "power-profiles-daemon"
    "go"
    "awww"
)
SERVICES=("hyprpolkitagent.service" "ssh-agent.service" "awww.service" "waybar.service" "hypridle.service")
TARGET_DIR="$HOME"

echo "🚀 Starting dotfiles installation..."

# --- Step 0: AUR Helper Installation (yay) ---
echo "--- Step 0: Ensuring AUR helper (yay) is installed ---"
if ! command -v yay &> /dev/null; then
    echo "📥 'yay' not found. Installing dependencies and compiling from AUR..."
    
    # Install base-devel and git first (required to build yay)
    sudo pacman -S --needed --noconfirm base-devel git
    
    # Clone and build yay in a temporary directory
    _temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$_temp_dir"
    cd "$_temp_dir" || exit 1
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR" || exit 1
    rm -rf "$_temp_dir"
    
    echo "✅ 'yay' installed successfully."
else
    echo "✅ 'yay' is already installed."
fi

echo "📥 Installing all required software and fonts via yay..."
yay -S --needed --noconfirm "${ALL_SOFTWARE[@]}"

# --- Step 0: Building Executables ---
cd "$DOTFILES_DIR" || exit 1
HYPR_DIR=./hypr/.config/hypr
go build -o "${HYPR_DIR}/bin/wallpaper-manager" -ldflags="-s -w" "${HYPR_DIR}/scripts/wallpaper_manager.go"


# --- Step 1: Symlinks with Stow ---
echo "--- Step 1: Linking configurations with Stow ---"
cd "$DOTFILES_DIR" || exit 1

for pkg in "${PACKAGES[@]}"; do
    pkg_clean=$(echo "$pkg" | tr -d ',')
    if [ -d "$pkg_clean" ]; then
        echo "📦 Stowing package: $pkg_clean"
        stow -v -R -t "$TARGET_DIR" "$pkg_clean"
        if [ $? -eq 0 ]; then
            echo "  ✅ $pkg_clean stowed successfully."
        else
            echo "  ❌ Error stowing $pkg_clean."
        fi
    else
        echo "  ⚠️  Warning: Package directory '$pkg_clean' not found. Skipping."
    fi
done

# --- Step 2: Systemd Services ---
echo "--- Step 2: Managing systemd user services ---"
echo "🔄 Reloading systemd daemon..."
systemctl --user daemon-reload

for service in "${SERVICES[@]}"; do
    echo "⚙️  Enabling and starting: $service"
    systemctl --user enable --now "$service"
    
    if [ $? -eq 0 ]; then
        echo "  ✅ $service is active."
    else
        echo "  ❌ Failed to start $service."
    fi
done

echo "🎉 Installation complete!"