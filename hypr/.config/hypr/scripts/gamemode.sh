#!/bin/bash

# Arguments: $1 (TOGGLE)
# 0: Just check status (for Waybar startup/polling)
# 1: Perform toggle action (on click)
TOGGLE=$1

# Fetch current animation state from Hyprland (1 = animations active, 0 = disabled)
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

# Define JSON objects for Waybar integration
GAME_MODE_ON='{"text": "󰊴", "class": "on", "tooltip": "Gaming Mode: ON (Performance Profile)"}'
GAME_MODE_OFF='{"text": "󰊵", "class": "off", "tooltip": "Gaming Mode: OFF (Balanced Profile)"}'

# --- STATUS CHECK MODE ---
# If called with 0, return current state without changing anything
if [[ "$TOGGLE" -eq 0 ]]; then
    if [[ "$HYPRGAMEMODE" -eq 1 ]]; then
        echo "$GAME_MODE_OFF" # Animations are ON, so Gaming Mode is OFF
    else
        echo "$GAME_MODE_ON"  # Animations are OFF, so Gaming Mode is ON
    fi

# --- TOGGLE ACTION MODE ---
# If called with 1, switch between Gaming and Desktop modes
elif [[ "$TOGGLE" -eq 1 ]]; then
    if [[ "$HYPRGAMEMODE" -eq 1 ]]; then
        # --- ENABLE GAMING MODE ---
        # 1. Disable eye-candy to minimize input lag and CPU jitter
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:drop_shadow 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1" > /dev/null
        
        # 2. Set system power profile to Performance
        # Unlocks higher clock speeds and disables aggressive power management
        powerprofilesctl set performance

        # 3. Deactivate wallpaper cycle
        ~/.config/hypr/scripts/wallpapers_toggle.sh pause 1

        # 4. Send notification
        notify-send -u low -t 990 "Gaming Mode 󰊴" "Enabled: High Performance Profile"

        echo "$GAME_MODE_ON"

        sleep 1
        
        # 5. Pause notifications
        dunstctl set-paused true
    else
        # --- DISABLE GAMING MODE ---
        # 1. Reset Hyprland to user's default configuration
        hyprctl reload > /dev/null
        
        # 2. Revert to Balanced power profile for better efficiency
        powerprofilesctl set balanced

        # 3. Resume notifications
        dunstctl set-paused false

        # 4. Activate wallpaper cycle
        ~/.config/hypr/scripts/wallpapers_toggle.sh active 1

        # 5. Send notification
        notify-send -u low "Gaming Mode 󰊵" "Disabled: Balanced Profile"

        echo "$GAME_MODE_OFF"
    fi
fi

# Refresh Waybar UI immediately by sending a real-time signal
# Make sure "signal": 1 is defined in your waybar config module$
(sleep 0.1 && pkill -RTMIN+1 waybar) &
exit 0