#!/bin/bash

# 1. Stop all systemd user services
# This properly shuts down Waybar, Dunst, and other session services
systemctl --user stop graphical-session.target

# 2. Gracefully ask apps to close
# This sends a termination signal to all your user processes
pkill -TERM -u $USER
sleep 1

# # 3. Force kill stubborn apps (like VS Code)
# # VS Code often leaves lock files if not killed decisively
pkill -9 -u $USER code
pkill -9 -u $USER discord
pkill -9 -u $USER steam

# 4. Final Exit
hyprshutdown