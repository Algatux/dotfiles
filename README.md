# dotfiles

This repository stores configuration files ("dotfiles") for a personal Linux setup. It includes custom settings for Hyprland window manager and systemd units, among other system configurations.

## Structure

The repository is organized into subdirectories that are intended to be managed via [GNU Stow](https://www.gnu.org/software/stow/). Each top‑level directory corresponds to a group of related configuration files:

- `hypr/` – Hyprland configuration (typically symlinked to `~/.config/hypr`).
- `systemd/` – user/systemd service and timer unit files (`~/.config/systemd/user/`).
- `kitty/` – configuration for the Kitty terminal emulator (`~/.config/kitty/`).
- `waybar/` – Waybar bar configuration (`~/.config/waybar/`).
- `wlogout/` – lock/logout screen configuration for the wlogout utility.

This layout makes it easy to add or remove individual tools by adjusting the `PACKAGES` array in `install.sh` or by running `stow` manually from the repository root.

## Usage

Clone this repo into your home directory (e.g. `~/dotfiles`) and symlink the desired files to their expected locations. Adjust paths and options as needed for your distribution.

### Example

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/hypr/.config/hypr ~/.config/hypr
ln -s ~/dotfiles/systemd/* ~/.config/systemd/user/
```

### Installation Script

An installation helper script (`install.sh`) is provided to simplify setup. It performs several tasks automatically:

1. Ensures the Arch AUR helper `yay` is installed (building it from AUR if necessary).
2. Installs all required software packages and fonts from the `ALL_SOFTWARE` list:
   ```
   noto-fonts-emoji
   ttf-jetbrains-mono-nerd
   wlogout
   fastfetch
   stow
   git
   base-devel     # needed to compile AUR packages
   ```
3. Uses GNU Stow to symlink configuration directories (see the `PACKAGES` array):
   - `hypr` ‒ Hyprland configuration
   - `systemd` ‒ user/systemd unit files
   - `kitty` ‒ Kitty terminal settings
   - `waybar` ‒ Waybar bar configuration
   - `wlogout` ‒ lock/logout screen configuration
4. Reloads the systemd user daemon and enables/starts the following services:
   - `hyprpolkitagent.service`
   - `ssh-agent.service`
   - `swww.service`
   - `waybar.service`

To run the script, make sure the file is executable and then:

```bash
cd ~/dotfiles
bash install.sh
```  
(You may need to adjust or review the script for your distribution.)

The script is a convenient starting point but manual stow/symlink arrangements are still supported if you prefer finer control.

## Contributing

Add, modify, or remove configuration files and submit pull requests. Ensure changes are tested on a compatible Linux environment.

## License

MIT License – feel free to reuse and adapt these dotfiles.

