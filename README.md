# 🔧 Hyprland Wayland Dotfiles

A comprehensive configuration repository for a modern Wayland-based Linux desktop environment using **Hyprland** as the window manager. This setup is optimized for productivity, gaming, and customization with pre-configured integration between multiple tools and utilities.

## 🌟 Features

- **Hyprland Window Manager** – Tiling compositor for Wayland with advanced animations and GPU acceleration
- **Gaming Mode** – Performance profile toggle that disables animations, optimizes power settings, and pauses notifications for distraction-free gaming
- **Custom Waybar Status Bar** – Modular status bar with system tray, clock, media controls, and custom gamemode indicator
- **Kitty Terminal** – GPU-accelerated terminal with custom fonts and color themes
- **Desktop Notifications** – Dunst daemon configured to integrate seamlessly with Waybar aesthetic
- **Systemd User Services** – Automated daemon management for core session components
- **Automatic Installation** – `install.sh` script handles package installation, symlink management, and service enabling

---

## 📁 Project Structure

This repository follows the [GNU Stow](https://www.gnu.org/software/stow/) symlink farm pattern. Each top-level directory represents a "package" containing a `.config/` subdirectory structure that mirrors your home directory.

### Directory Layout

```
dotfiles/
├── hypr/                          # Hyprland window manager configuration
│   └── .config/hypr/
│       ├── hyprland.conf          # Core Hyprland settings (monitors, keybinds, rules)
│       ├── keybindings.conf       # All keyboard shortcuts and window management bindings
│       ├── monitors.conf          # Display configuration (resolution, refresh, scaling)
│       ├── workspaces.conf        # Workspace setup and behavior
│       ├── autostart.conf         # Applications to launch on session start
│       ├── hypridle.conf          # Idle management (screen off, suspend timeouts)
│       ├── hyprlock.conf          # Screen lock appearance and behavior
│       ├── windowrules.conf       # Per-app window rules and behaviors
│       ├── wallpapers/            # Wallpaper images for swww daemon
│       └── scripts/
│           ├── gamemode.sh        # Gaming Mode toggle script
│           └── wallpaper_manager.go  # Automatic wallpaper rotation daemon
│
├── systemd/                       # User-level systemd services
│   └── .config/systemd/user/
│       ├── hyprpolkitagent.service     # PolicyKit authentication service
│       ├── ssh-agent.service          # SSH key management daemon
│       ├── swww.service               # Wallpaper daemon
│       ├── waybar.service             # Status bar service
│       ├── hypridle.service           # Idle management service
│       ├── default.target.wants/      # Default session startup targets
│       └── graphical-session.target.wants/  # Graphical session targets
│
├── kitty/                         # Terminal emulator configuration
│   └── .config/kitty/
│       └── kitty.conf             # Terminal settings, fonts, colors, keybindings
│
├── waybar/                        # Status bar and system tray
│   └── .config/waybar/
│       ├── config.jsonc           # Module definitions and layout configuration
│       ├── style.css              # Colors, fonts, spacing, and visual styling
│       └── icons/                 # Custom icon definitions and theme
│
├── dunst/                         # Desktop notification daemon
│   └── .config/dunst/
│       └── dunstrc                # Notification styling, placement, and urgency levels
│
├── wlogout/                       # Lock/logout screen interface
│   └── .config/wlogout/
│       ├── layout                 # Button layout for power menu
│       ├── logout                 # Handler script for system commands
│       └── style.css              # Lock screen styling and theme
│
├── install.sh                     # Automated installation and setup script
└── README.md                      # This file
```

### Stow Farm Concept

Each directory (e.g., `hypr/`, `kitty/`, `waybar/`) is a Stow "package." Running `stow hypr` creates symlinks from `.config/hypr/` → `~/.config/hypr/`. This modular approach makes it easy to:
- Enable/disable individual configurations
- Manage multiple profiles
- Keep dotfiles organized

---

## 🚀 Installation

### Prerequisites

- **OS:** Arch Linux or Arch-based distribution (Manjaro, EndeavourOS, etc.)
- **Wayland Session:** A Wayland login session (not X11)
- **Standard Tools:** `git`, `curl`, and `bash`

### Automatic Installation

The easiest way to set up these dotfiles is to run the provided installation script:

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the installer
bash install.sh
```

#### What `install.sh` Does

1. **Installs `yay` (AUR helper)** – If not already installed, builds and installs it from source
2. **Installs all dependencies** – Uses `yay` to install all required packages (see Dependencies section)
3. **Symlinks configurations** – Uses `stow` to create symlinks for each package (hypr, kitty, waybar, etc.)
4. **Enables systemd services** – Reloads systemd daemon and enables/starts user services
5. **Prints status** – Shows progress and errors for each step

### Manual Installation

If you prefer granular control, use Stow manually:

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Manually stow packages
stow hypr systemd kitty waybar dunst wlogout

# Install dependencies via your package manager
sudo pacman -S hyprland waybar kitty wlogout hyprlock hypridle dunst stow yay git base-devel

# Enable and start services
systemctl --user daemon-reload
systemctl --user enable --now waybar.service hypridle.service hyprpolkitagent.service swww.service ssh-agent.service
```

### Customizing Installation

Edit `install.sh` before running it to customize which packages are installed:

```bash
# In install.sh, modify PACKAGES array:
PACKAGES=("hypr" "systemd" "kitty" "waybar" "dunst" "wlogout")

# And modify ALL_SOFTWARE array to add/remove packages:
ALL_SOFTWARE=(
    "hyprland"
    "waybar"
    "kitty"
    # ... add or remove as needed
)
```

---

## ⚙️ Configuration Modules

### 🪟 Hyprland (`hypr/`)

Hyprland is a tiling compositor for Wayland with advanced animations, multiple workspace support, and GPU acceleration. The configuration is split into modular files for easier maintenance.

**Core Files:**

- **`hyprland.conf`** – Main configuration file that includes all other configs and sets core Hyprland behavior (decorations, animations, input settings, general options)

- **`keybindings.conf`** – All keyboard shortcuts organized by function:
  - Window management (focus, move, resize, fullscreen, float)
  - Workspace switching
  - Application launching
  - Gaming Mode toggle (`$mainMod+Shift+G`)
  - Media/brightness controls

- **`monitors.conf`** – Display configuration with monitor definitions:
  ```
  monitor=HDMI-1,1920x1080@60,0x0,1
  monitor=DP-1,3440x1440@100,1920x0,1
  ```
  Adjust resolution, refresh rate, position, and scaling for each display

- **`workspaces.conf`** – Workspace settings and per-workspace configurations

- **`autostart.conf`** – Applications/commands to execute on session start:
  - Daemons: `waybar`, `swww`, `cliphist`
  - Environment variables: Wayland/XDG settings
  - Wallpaper loading

- **`hypridle.conf`** – Idle management settings:
  - Screen timeout (e.g., turn off after 5 minutes)
  - Suspend behavior (e.g., suspend after 10 minutes)
  - Lock behavior (e.g., lock on idle)

- **`hyprlock.conf`** – Screen lock appearance:
  - Login widget styling
  - Password input appearance
  - Background/wallpaper display

- **`windowrules.conf`** – Application-specific window rules:
  - Window size/positioning
  - Floating vs tiling behavior
  - Opacity and animation rules

- **`wallpapers/`** – Directory containing wallpaper images used by `swww`

- **`scripts/gamemode.sh`** – Gaming Mode toggle script that:
  - Disables animations, shadows, and blur
  - Sets system power profile to `performance`
  - Pauses desktop notifications via `dunstctl`
  - Can be toggled via keybinding or Waybar module

- **`scripts/wallpaper_manager.go`** – Automatic wallpaper rotation daemon that:
  - Rotates desktop wallpapers at configurable intervals (default: 1 hour)
  - Supports multiple monitors with independent wallpaper selection
  - Applies smooth transitions via `swww`
  - Pauses during Gaming Mode via lock file mechanism

**Customization Tips:**

- Update `monitors.conf` if your display setup differs
- Modify `keybindings.conf` to change keyboard shortcuts
- Add applications to `autostart.conf` for automatic launching
- Adjust idle timeouts in `hypridle.conf` for your preference
- Add window rules in `windowrules.conf` for app-specific behavior

### 🎮 Gaming Mode

Gaming Mode is a performance profile toggle that optimizes Hyprland for gaming:

**What it does:**
- Disables animations, shadows, blur, and window gaps in Hyprland (reduces latency and CPU usage)
- Sets system power profile to `performance` (unlocks higher CPU/GPU clocks)
- Pauses desktop notifications (prevents popups during gameplay)

**How to use:**
- **Keybinding:** Press `$mainMod + Shift + G` to toggle
- **Waybar Module:** Click the gaming mode icon in the status bar

**How it works:**
- Implemented in `hypr/scripts/gamemode.sh`
- Script checks Hyprland's `animations:enabled` option to detect current state
- On enable: runs `hyprctl` commands to disable effects + `powerprofilesctl set performance` + `dunstctl set-paused true`
- On disable: runs `hyprctl reload` to restore config + `powerprofilesctl set balanced` + `dunstctl set-paused false`

### 🎨 Wallpaper Manager (`wallpaper_manager.go`)

The Wallpaper Manager is an automated wallpaper switching daemon written in Go that rotates desktop backgrounds at configurable intervals. It supports multiple monitors with independent wallpaper selection and smooth transitions.

**What it does:**

- **Automatic rotation:** Changes wallpapers at a configurable interval (default: 1 hour / 3600 seconds)
- **Multi-monitor support:** Independently manages wallpapers for different displays (main monitor: DP-1, side monitor: DP-3)
- **Random selection:** Randomly picks wallpapers from designated folders (`main` and `side` directories)
- **Smooth transitions:** Uses `swww` daemon to apply transitions with configurable FPS and animation steps
- **Gaming Mode integration:** Automatically pauses wallpaper switching during Gaming Mode via lock file mechanism
- **Lazy loading:** Scans wallpaper directories once on startup, no continuous disk I/O

**Features:**

| Feature | Details |
|---------|---------|
| **Interval Control** | Configure via `-interval` flag (in seconds) |
| **Monitor Support** | Handles multiple displays with per-monitor configuration |
| **Image Formats** | Supports `.jpg`, `.png`, `.webp`, `.jpeg` formats |
| **Transition Effects** | Random transition types with 60 FPS smoothness |
| **Gaming Mode** | Detects `/tmp/wallpaper_cycle.lock` lock file and pauses switching |
| **Error Recovery** | Waits for `swww-daemon` to start, retries with 5-second intervals |

**Setup and Configuration:**

The Wallpaper Manager runs as a systemd user service and is configured through the `swww.service` file:

```ini
[Unit]
Description=swww Wallpaper Daemon
PartOf=graphical-session.target

[Service]
Type=simple
ExecStart=/path/to/wallpaper_manager -interval 3600
Restart=on-failure
RestartSec=5
```

**Wallpaper Directory Structure:**

```
~/.config/hypr/wallpapers/
├── main/          # Main monitor wallpapers (DP-1)
│   ├── wallpaper1.jpg
│   ├── wallpaper2.png
│   └── ...
└── side/          # Side monitor wallpapers (DP-3)
    ├── landscape1.jpg
    ├── landscape2.webp
    └── ...
```

**Customization:**

1. **Change rotation interval:**
   ```bash
   # Edit systemd service to change interval (in seconds)
   # 3600 = 1 hour, 1800 = 30 minutes, etc.
   systemctl --user edit swww.service
   ```

2. **Add wallpaper images:**
   - Place `.jpg`, `.png`, `.webp`, or `.jpeg` files in `~/.config/hypr/wallpapers/main/` and/or `~/.config/hypr/wallpapers/side/`
   - Manager will automatically discover and include them

3. **Configure monitor outputs:**
   - Edit `hypr/scripts/wallpaper_manager.go` (lines 43-44) to match your display names:
   ```go
   cmdMain := exec.Command("swww", "img", "-o", "DP-1", ...)  // Your main monitor
   cmdSide := exec.Command("swww", "img", "-o", "DP-3", ...)  // Your side monitor
   ```

4. **Adjust transition smoothness:**
   - Modify `--transition-fps` (currently 60 FPS) and `--transition-step` (currently 90) in the source code for different transition effects

**Gaming Mode Integration:**

When Gaming Mode is enabled via `$mainMod + Shift + G`:
- A lock file `/tmp/wallpaper_cycle.lock` is created
- The Wallpaper Manager detects this and pauses switching
- When Gaming Mode is disabled, the lock file is removed and switching resumes

**Manual Execution:**

Build and run the Wallpaper Manager manually:

```bash
# Navigate to scripts directory
cd ~/.config/hypr/scripts

# Compile the Go program
go build -o wallpaper_manager wallpaper_manager.go

# Run with default 1-hour interval
./wallpaper_manager

# Run with custom interval (e.g., 30 minutes = 1800 seconds)
./wallpaper_manager -interval 1800

# Kill the process when done
killall wallpaper_manager
```

**Troubleshooting:**

- **Wallpapers not changing:** Verify `swww-daemon` is running (`pgrep swww`)
- **Gaming Mode not pausing:** Confirm lock file mechanism is working or manually restart the daemon
- **No images found:** Ensure wallpaper directories exist and contain valid image files
- **Slow transitions:** Reduce `-interval` value or adjust FPS/step values in source code

### 💻 Kitty Terminal (`kitty/`)

Kitty is a modern, GPU-accelerated terminal emulator with excellent performance and feature support.

**Configuration:**

- **`kitty.conf`** – Master configuration file including:
  - Font family and size (default: JetBrains Mono Nerd Font)
  - Color scheme and theme
  - Keyboard shortcuts for terminal operations
  - Scrollback history settings
  - Mouse and copy-paste behavior
  - Shell integration
  - Padding and line height

**Customization Tips:**

- Change font: `font_family` and `font_size` options
- Modify colors: Update color palette definitions
- Define custom keybindings for terminal-specific operations
- Adjust scrollback to control history depth

### 📊 Waybar (`waybar/`)

Waybar is a highly customizable status bar for Wayland. It displays system information, has integrated system tray, and supports custom modules.

**Configuration:**

- **`config.jsonc`** – Defines modules, layout, and behavior:
  - Modules list and order
  - Module-specific settings (pulse, network, battery, etc.)
  - Bar position and margins
  - Systemd service integration
  - Gaming Mode custom module
  - Shortcuts and click commands
  - Signal handlers for real-time updates

- **`style.css`** – Visual styling:
  - Colors and themes (matches Hyprland aesthetic)
  - Font and text styling
  - Module spacing and sizing
  - Hover and active states
  - Progress bar styling
  - Gaming Mode indicator styling

- **`icons/`** – Custom icon definitions and theme overrides

**Available Modules:**

- `clock` – Date and time display
- `network` – WiFi status and connectivity
- `battery` – Battery percentage and status
- `pulseaudio` – Volume control
- `backlight` – Screen brightness
- `cpu` – CPU usage percentage
- `memory` – RAM usage
- `disk` – Disk space usage
- `custom/gamemode` – Gaming Mode indicator (custom module)
- `tray` – System tray integration
- And many more...

**Customization Tips:**

- Add/remove modules by editing `config.jsonc`
- Modify bar position (top/bottom) and margins
- Customize colors and fonts in `style.css`
- Create custom modules for specific tasks
- Adjust update intervals for performance

### 🔔 Dunst Notifications (`dunst/`)

Dunst is a lightweight notification daemon that displays desktop notifications. It integrates with Hyprland and is paused during Gaming Mode.

**Configuration:**

- **`dunstrc`** – Main configuration file:
  - Monitor selection where notifications appear
  - Origin and offset (where notifications spawn on screen)
  - Width, height, and dynamic sizing
  - Notification limits
  - Corner radius and frame styling
  - Font selection (matches Waybar aesthetic)
  - Padding and spacing
  - Progress bars for volume/brightness feedback
  - Urgency levels (low, normal, critical) with different styling/timeouts

**Urgency Levels:**

- `low` – 5 second timeout, muted colors
- `normal` – 10 second timeout, standard visibility
- `critical` – No timeout, highlighted with red frame

**Gaming Mode Integration:**

During Gaming Mode, the `gamemode.sh` script pauses notifications:
```bash
dunstctl set-paused true   # Pause on enable
dunstctl set-paused false  # Resume on disable
```

**Customization Tips:**

- Adjust `timeout` values for notification duration
- Change colors to match your theme
- Modify `offset` to reposition notifications
- Adjust `width` and `height` for different screen sizes
- Enable/disable `progress_bar` for volume/brightness feedback

### 🔒 Wlogout (`wlogout/`)

Wlogout provides an on-screen lock/logout/power menu interface for Hyprland sessions.

**Configuration:**

- **`layout`** – Button layout definition:
  - Specifies which buttons appear and their order
  - Button labels and icons
  - Button actions (power off, reboot, logout, lock, etc.)

- **`logout`** – Handler script:
  - Executes system commands based on button clicks
  - Uses `systemctl` for power operations
  - Handles logout and lock actions

- **`style.css`** – Visual styling:
  - Background and overall layout styling
  - Button appearance, hover, and active states
  - Theming and colors

**Customization Tips:**

- Edit `layout` to add/remove buttons or change their order
- Modify `logout` script to customize system commands
- Adjust `style.css` for color and appearance changes

### ⚙️ Systemd User Services (`systemd/`)

User-level systemd services that manage daemons and utilities for the graphical session.

**Service Files:**

- **`hyprpolkitagent.service`** – PolicyKit authentication agent
  - Handles password prompts for privileged operations
  - Launched on graphical session start

- **`ssh-agent.service`** – SSH key management
  - Manages SSH keys for authentication
  - Provides SSH_AUTH_SOCK environment variable

- **`swww.service`** – Wallpaper daemon
  - Manages desktop wallpapers
  - Supports animated wallpapers via swww

- **`waybar.service`** – Status bar service
  - Runs the Waybar process
  - Respawn on crash

- **`hypridle.service`** – Idle management
  - Monitors user activity
  - Triggers idle actions (screen off, suspend, lock)

**Service Targets:**

- **`default.target.wants/`** – Services linked here start with the default user target
- **`graphical-session.target.wants/`** – Services linked here start with the graphical session

**Customization Tips:**

- Edit service files to add dependencies or environment variables
- Create new service files for custom daemons
- Adjust `Type` and `Restart` policies for different behavior
- Use `Environment` and `ExecStart` to customize commands

---

## ✅ System Requirements

- **Distribution:** Arch Linux, Manjaro, EndeavourOS, or other Arch-based distribution
- **Display Server:** Wayland (not X11)
- **Build Tools:** `base-devel` package (required for building AUR packages with `yay`)
- **Package Manager:** `pacman` (with AUR support via `yay`)
- **Symlink Manager:** `stow` (for managing dotfiles)

---

## 📦 Dependencies & Software Stack

| Component | Purpose | Package Manager |
|-----------|---------|-----------------|
| **hyprland** | Window manager and Wayland compositor | Official Repos |
| **waybar** | Customizable status bar for Wayland | Official Repos |
| **kitty** | GPU-accelerated terminal emulator | Official Repos |
| **wlogout** | On-screen logout/power menu | Official Repos |
| **hyprpolkitagent** | PolicyKit authentication agent for Hyprland | Official Repos |
| **hypridle** | Idle management daemon with screen timeout | Official Repos |
| **hyprlock** | Screen lock utility for Hyprland | Official Repos |
| **hyprshutdown** | Power menu helper for Hyprland sessions | AUR |
| **swww** | Wallpaper daemon with animation support | AUR |
| **ssh-agent** | SSH key management utility | Official Repos |
| **wl-clipboard** | X11/Wayland clipboard synchronization | Official Repos |
| **cliphist** | Clipboard history manager | AUR |
| **power-profiles-daemon** | Power management profile switcher | Official Repos |
| **dunst** | Lightweight desktop notification daemon | Official Repos |
| **noto-fonts-emoji** | Noto emoji font family | Official Repos |
| **ttf-jetbrains-mono-nerd** | JetBrains Mono Nerd Font (used in terminal/status bar) | AUR |
| **stow** | Symlink farm manager (GNU Stow) | Official Repos |
| **yay** | AUR helper (automatically installed by script) | AUR |
| **git** | Version control system | Official Repos |
| **base-devel** | Build tools and development utilities | Official Repos |

**All dependencies are automatically installed by `install.sh`.**

---

## 🛠️ Usage & Customization

### Basic Usage

After installation, your Hyprland session should start automatically on the next login. Default keybindings include:

- `$mainMod + Return` – Open terminal (Kitty)
- `$mainMod + Q` – Close focused window
- `$mainMod + V` – Toggle floating window
- `$mainMod + F` – Toggle fullscreen
- `$mainMod + 1-9` – Switch to workspace 1-9
- `$mainMod + Shift + 1-9` – Move window to workspace 1-9
- `$mainMod + Shift + G` – Toggle Gaming Mode
- `$mainMod + E` – Open file manager
- `$mainMod + Esc` – Open logout menu (wlogout)

See [keybindings.conf](hypr/.config/hypr/keybindings.conf) for the complete list.

### Customizing Displays

Edit `hypr/monitors.conf` with your display configuration:

```
# Format: monitor=NAME,RESOLUTION@REFRESH,POSITION,SCALE
monitor=DP-1,3440x1440@100,0x0,1
monitor=HDMI-1,1920x1080@60,3440x0,1.25
monitor=eDP-1,disable  # Disable built-in laptop display
```

Run `hyprctl monitors` to list connected displays and their names.

### Customizing Keybindings

Edit `hypr/keybindings.conf` to add/modify shortcuts:

```
# Syntax: bind = MODIFIERS, KEY, DISPATCHER, ARGUMENTS
bind = $mainMod, Q, killactive
bind = $mainMod SHIFT, Q, exec, systemctl poweroff
```

### Customizing Autostart Applications

Edit `hypr/autostart.conf` to add applications that launch on session start:

```
# Syntax: exec-once = command
exec-once = $terminal  # Start terminal
exec-once = firefox &  # Start Firefox in background
```

### Customizing Idle Behavior

Edit `hypr/hypridle.conf` to adjust screen timeout and suspend behavior:

```
listener {
    timeout = 300    # 5 minutes
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}
```

### Enabling Additional Waybar Modules

Edit `waybar/config.jsonc` to add more modules to the status bar:

```json
"modules-center": [
    "clock",
    "custom/weather",  // Add custom weather module
    "custom/gamemode"
]
```

### Customizing Waybar Styling

Edit `waybar/style.css` to change colors, fonts, and layout:

```css
* {
    font-family: "JetBrains Mono";
    font-size: 12px;
    color: #cdd6f4;
    background: #1e1e2e;
}
```

---

## 🐛 Troubleshooting

### Hyprland won't start

1. Ensure you're using a Wayland session (not X11)
2. Check if required packages are installed: `pacman -Q hyprland waybar`
3. View Hyprland logs: `journalctl --user -u Hyprland -n 50`

### Waybar not showing

1. Verify symlinks are correct: `ls -la ~/.config/waybar/`
2. Check service status: `systemctl --user status waybar`
3. Restart the service: `systemctl --user restart waybar`

### Configurations not loading after stow

1. Verify symlinks were created: `ls -la ~/.config/hypr/`
2. Re-run stow with force: `cd ~/dotfiles && stow -R hypr waybar kitty systemd wlogout dunst`
3. Reload Hyprland: `$mainMod + Esc` then open a new session

### Gaming Mode not toggling

1. Ensure `powerprofilesctl` is installed: `pacman -Q power-profiles-daemon`
2. Check if Gaming Mode script is executable: `ls -la ~/.config/hypr/scripts/gamemode.sh`
3. Test manually: `~/.config/hypr/scripts/gamemode.sh 1`

### Notifications not appearing

1. Ensure `dunst` is running: `pgrep dunst`
2. Start dunst manually: `dunst &`
3. Add to autostart: Edit `hypr/autostart.conf` and add `exec-once = dunst`

### Terminal/fonts look wrong

1. Install required fonts: `sudo pacman -S ttf-jetbrains-mono-nerd noto-fonts-emoji`
2. Reload terminal: Close and reopen Kitty
3. Check font settings in `kitty/kitty.conf`

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. **Test thoroughly** – Ensure changes work on a fresh Wayland/Hyprland session
2. **Update documentation** – Modify the README if adding new files or features
3. **Verify symlinks** – Run `stow` to ensure configurations link correctly
4. **Check services** – Confirm systemd services start without errors
5. **Commit clearly** – Use clear, descriptive commit messages

### Submitting Changes

```bash
# Create a feature branch
git checkout -b feature/my-improvement

# Make your changes and commit
git add .
git commit -m "Add feature: brief description"

# Push and open a pull request
git push origin feature/my-improvement
```

---

## 📄 License

MIT License – Feel free to reuse, modify, and adapt these dotfiles for your setup. See the LICENSE file for full details (if included).

---

## 📚 Useful Resources

- [Hyprland Wiki](https://wiki.hyprland.org/) – Comprehensive Hyprland documentation
- [Waybar GitHub](https://github.com/Alexays/Waybar) – Waybar source and module documentation
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/) – Kitty terminal documentation
- [Dunst GitHub](https://github.com/dunst-project/dunst) – Dunst notification daemon
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/) – Symlink farm management
- [systemd User Services](https://wiki.archlinux.org/title/Systemd/User) – User service guide
- [Wayland Protocol](https://wayland.freedesktop.org/) – Wayland display server protocol

---

**Happy tiling! 🚀**
