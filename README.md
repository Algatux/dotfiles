# dotfiles

This repository stores configuration files ("dotfiles") for a personal Linux setup. It includes custom settings for Hyprland window manager and systemd units, among other system configurations.

## Structure

- `hypr/` – contains Hyprland configuration under `config/`.
- `systemd/` – holds user/system service and timer units managed via systemd.

## Usage

Clone this repo into your home directory (e.g. `~/dotfiles`) and symlink the desired files to their expected locations. Adjust paths and options as needed for your distribution.

### Example

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/hypr/.config/hypr ~/.config/hypr
ln -s ~/dotfiles/systemd/* ~/.config/systemd/user/
```

## Contributing

Add, modify, or remove configuration files and submit pull requests. Ensure changes are tested on a compatible Linux environment.

## License

MIT License – feel free to reuse and adapt these dotfiles.

