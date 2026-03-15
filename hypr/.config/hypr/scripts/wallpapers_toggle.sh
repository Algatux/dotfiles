#!/bin/bash

LOCK_FILE="/tmp/wallpaper_cycle.lock"
ACTION=$1 

if [[ "$ACTION" == "active" ]]; then
    rm -f "$LOCK_FILE" # -f evita errori se il file non esiste già
    notify-send -u low  "󰸉 Wallpaper" "Cycle Active"
else
    touch "$LOCK_FILE"
    notify-send -u low -t 990  "󰸉 Wallpaper" "Cycle Paused"
fi