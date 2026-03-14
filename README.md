# 🔧 dotfiles

This repository stores configuration files ("dotfiles") for a personal Wayland-based Linux setup. It includes custom settings for Hyprland window manager, systemd services, terminal emulator, status bar, and lock/logout utilities.

## 📁 Structure

This repository is organized as a [GNU Stow](https://www.gnu.org/software/stow/) stow farm. Each top‑level directory is a "package" containing a `.config/` tree that will be symlinked into your home directory.

- `hypr/` – Hyprland configuration (`.config/hypr/`)
  - `.config/hypr/hyprland.conf` – Main Hyprland configuration
  - `.config/hypr/keybindings.conf` – Keyboard shortcuts and bindings
  - `.config/hypr/monitors.conf` – Display and monitor settings
  - `.config/hypr/workspaces.conf` – Workspace configuration
  - `.config/hypr/autostart.conf` – Autostart applications on session start
  - `.config/hypr/hypridle.conf` – Idle management and screen timeout settings
  - `.config/hypr/hyprlock.conf` – Screen lock configuration
  - `.config/hypr/windowrules.conf` – Window rules and application behavior
  - `.config/hypr/wallpapers/` – Wallpaper files

- `systemd/` – User systemd service and target files (`.config/systemd/user/`)
  - `.config/systemd/user/hyprpolkitagent.service` – PolicyKit authentication agent service
  - `.config/systemd/user/ssh-agent.service` – SSH agent service
  - `.config/systemd/user/swww.service` – Wallpaper switching service (swww)
  - `.config/systemd/user/waybar.service` – System tray and status bar service
  - `.config/systemd/user/hypridle.service` – Idle management service
  - `.config/systemd/user/default.target.wants/` – Default session targets
  - `.config/systemd/user/graphical-session.target.wants/` – Graphical session targets

- `kitty/` – Kitty terminal emulator configuration (`.config/kitty/`)
  - `.config/kitty/kitty.conf` – Terminal settings, colors, fonts, and keybindings

- `waybar/` – Waybar status bar configuration (`.config/waybar/`)
  - `.config/waybar/config.jsonc` – Bar layout, modules, and settings
  - `.config/waybar/style.css` – Bar styling and themes
  - `.config/waybar/icons/` – Custom icon definitions

- `wlogout/` – Lock/logout utility configuration (`.config/wlogout/`)
  - `.config/wlogout/layout` – Button layout and order
  - `.config/wlogout/logout` – Logout handling script
  - `.config/wlogout/style.css` – Lock screen styling

This layout makes it easy to add or remove individual tools by adjusting the `PACKAGES` array in `install.sh` or by running `stow` manually from the repository root.

## 📖 Usage

### ⚡ Automated Installation

The easiest way to set up these dotfiles is using the installation script:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The script will handle package installation, configuration linking, and service setup automatically.

**Note:** You may need to review and adjust the script for your distribution. The script is optimized for Arch Linux and AUR.

### 🛠️ Manual Installation

If you prefer finer control, you can use GNU Stow manually:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow hypr systemd kitty waybar wlogout
```

Then manually install the required packages and enable systemd services as needed.

## ⚙️ Configuration Modules

### 🪟 Hyprland (`hypr/`)

Hyprland is a tiling window manager for Wayland. The configuration is split across multiple files for maintainability:

- **hyprland.conf** – Core Hyprland settings (input, general, animations, window rules)
- **keybindings.conf** – All keyboard shortcuts and window management bindings
- **monitors.conf** – Display configuration (resolution, refresh rate, DPI scaling)
- **workspaces.conf** – Workspace definitions and settings
- **autostart.conf** – Applications to launch on session start (waybar, swww, cliphist, etc.)
- **hypridle.conf** – Idle timeout settings (screen off, suspend after inactivity)
- **hyprlock.conf** – Screen lock appearance and behavior configuration
- **wallpapers/** – Directory containing wallpaper images for swww

**Customization Tips:**
- Edit `monitors.conf` to adjust display settings for your hardware
- Modify `keybindings.conf` to change keyboard shortcuts
- Update `autostart.conf` to launch additional applications
- Configure idle timeouts and lock behavior in `hypridle.conf` and `hyprlock.conf`
- Add wallpaper images to `wallpapers/` directory

### 💻 Kitty Terminal (`kitty/`)

Kitty is a modern GPU-based terminal emulator with excellent performance and feature support.

- **kitty.conf** – Font settings, colors, keyboard shortcuts, and other terminal behavior

**Customization Tips:**
- Adjust font family, size, and line height
- Customize color schemes and themes
- Define custom keybindings for terminal operations
- Configure scrollback history and shell integration

### 📊 Waybar (`waybar/`)

Waybar is a highly customizable status bar for Wayland compositors.

- **config.jsonc** – Module definitions, layout configuration, and behavior settings
- **style.css** – Colors, spacing, fonts, and visual styling
- **icons/** – Custom icon mappings and icon theme definitions

**Available Modules (typically configured in config.jsonc):**
- Clock and calendar display
- System tray integration
- Media player controls
- Network and WiFi status
- Battery and power status
- Volume and brightness controls
- CPU and memory usage
- Keyboard layout indicator
- And many more...

**Customization Tips:**
- Add or remove modules in `config.jsonc`
- Modify bar position (top/bottom) and margins
- Customize colors and themes in `style.css`
- Create custom icon sets in `icons/`

### 🔒 Wlogout (`wlogout/`)

Wlogout provides a lock/logout screen interface for Hyprland sessions.

- **layout** – Button layout configuration (power off, reboot, logout, lock buttons)
- **logout** – Handler script for shutdown/reboot/logout commands
- **style.css** – Lock screen visual styling and theme

**Customization Tips:**
- Modify `layout` to change button arrangement and available options
- Update `logout` to change system commands (uses systemctl)
- Customize appearance with `style.css`

### ⚙️ Systemd User Services (`systemd/`)

User-level systemd services that run when the graphical session starts.

**Service Files:**
- **hyprpolkitagent.service** – Runs the Hyprland PolicyKit agent for authentication prompts
- **ssh-agent.service** – SSH authentication agent for key management
- **swww.service** – Wallpaper daemon for dynamic wallpaper support
- **waybar.service** – System status bar service
- **hypridle.service** – Idle management service for screen timeout and suspend

**Service Targets:**
- **default.target.wants/** – Services that should start with the default user target
- **graphical-session.target.wants/** – Services for the graphical session environment

**Customization Tips:**
- Edit service files to modify startup behavior or add dependencies
- Add new service files for additional background daemons
- Adjust service environment variables as needed
- See [systemd.service documentation](https://man.archlinux.org/man/systemd.service.5) for options

## ✅ System Requirements

- **Linux Distribution:** Arch Linux (or Arch-based distributions like Manjaro, EndeavourOS)
- **Window Manager:** Hyprland (Wayland compositor)
- **Wayland Session:** A Wayland login session (not X11)
- **Build Tools:** `base-devel` package (required for building AUR packages)
- **Package Manager:** `pacman` with AUR support (`yay` recommended)

## 📦 Dependencies & Software Stack

The dotfiles require the following software components:

| Component | Purpose |
|-----------|---------|
| **hyprland** | Window manager and compositor |
| **waybar** | System status bar and tray |
| **kitty** | Terminal emulator |
| **wlogout** | Lock/logout screen |
| **hyprpolkitagent** | PolicyKit authentication agent |
| **hypridle** | Idle management daemon |
| **hyprlock** | Screen lock utility |
| **swww** | Wallpaper daemon |
| **ssh-agent** | SSH key management |
| **wl-clipboard** | X11/Wayland clipboard sync |
| **cliphist** | Clipboard history |
| **stow** | Symlink farm manager |
| **git** | Version control |

All dependencies are automatically installed by the `install.sh` script.

## 🐛 Troubleshooting

### ⚠️ Services not starting
If systemd services fail to start:
```bash
systemctl --user status waybar
journalctl --user -xe
```
Check the service status and logs to identify issues.

### ⚠️ Configuration not loading
If configurations don't apply after installation:
```bash
# Verify stow symlinks were created correctly
ls -la ~/.config/hypr
ls -la ~/.config/waybar

# Re-run stow if needed
cd ~/dotfiles && stow -R hypr waybar kitty systemd wlogout
```

### ⚠️ Keyboard layouts and input
Hyprland input settings are configured in `keybindings.conf`. Adjust keyboard layout and repeat rate as needed:
```
input {
    kb_layout = us
    kb_variant =
    kb_repeat_delay = 600
    kb_repeat_rate = 25
}
```

### ⚠️ Display scaling and DPI
Edit `monitors.conf` to adjust display settings for your hardware:
```
monitor=HDMI-1,1920x1080@60,0x0,1
monitor=DP-1,3440x1440@100,1920x0,1
```

## 📚 Resources & Documentation

- [Hyprland Documentation](https://wiki.hyprland.org/)
- [Waybar GitHub Repository](https://github.com/Alexays/Waybar)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
- [systemd Documentation](https://systemd.io/)
- [Wayland Protocol](https://wayland.freedesktop.org/)

## 🤝 Contributing

Add, modify, or remove configuration files and submit pull requests. Ensure changes are tested on a compatible Wayland/Hyprland environment. When contributing:

1. Test your changes thoroughly on a Wayland/Hyprland session
2. Update the README if adding new files or modules
3. Ensure all symlinks work correctly with stow
4. Verify systemd services start without errors
5. Provide clear commit messages describing changes

## 📄 License

MIT License – feel free to reuse and adapt these dotfiles.