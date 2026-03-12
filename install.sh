#!/usr/bin/env bash

# --- Configuration ---
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PACKAGES=("hypr" "systemd" "kitty")
FONTS=("noto-fonts-emoji" "ttf-jetbrains-mono-nerd")
SERVICES=("hyprpolkitagent.service" "ssh-agent.service" "swww.service" "waybar.service")
TARGET_DIR="$HOME"

echo "🚀 Starting dotfiles installation..."
echo "📍 Source directory: $DOTFILES_DIR"
echo "🏠 Target directory: $TARGET_DIR"

# --- Step 1: Font Installation ---
echo "--- Step 1: Checking fonts ---"
for font in "${FONTS[@]}"; do
    if pacman -Qi "$font" &> /dev/null; then
        echo "✅ $font is already installed."
    else
        echo "📥 Installing $font..."
        sudo pacman -S --noconfirm "$font"
    fi
done

# --- Step 2: Symlinks with Stow ---
echo "--- Step 2: Linking configurations with Stow ---"
cd "$DOTFILES_DIR" || exit 1

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        echo "📦 Stowing package: $pkg"
        stow -v -R -t "$TARGET_DIR" "$pkg"
        if [ $? -eq 0 ]; then
            echo "  ✅ $pkg stowed successfully."
        else
            echo "  ❌ Error stowing $pkg."
        fi
    else
        echo "  ⚠️  Warning: Package directory '$pkg' not found. Skipping."
    fi
done

# --- Step 3: Systemd Services ---
echo "--- Step 3: Managing systemd user services ---"
echo "🔄 Reloading systemd daemon..."
systemctl --user daemon-reload

for service in "${SERVICES[@]}"; do
    echo "⚙️  Enabling and starting: $service"
    # Enable (per l'avvio al boot) e Start (per l'avvio immediato)
    systemctl --user enable --now "$service"
    
    if [ $? -eq 0 ]; then
        echo "  ✅ $service is active."
    else
        echo "  ❌ Failed to start $service. Check 'systemctl --user status $service'"
    fi
done

echo "🎉 Installation complete!"
echo "💡 Note: If icons don't appear, restart Kitty or log out and back in."