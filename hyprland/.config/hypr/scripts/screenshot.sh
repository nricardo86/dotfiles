#!/usr/bin/env bash
DIR="$HOME/Pictures/"
NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"

options="Selected area,All Displays,Current display,Current Active Window"

choice=$(hyprlauncher -o "$options")
[[ "$choice" = "Exited without selection" ]] && exit
if [[ "$choice" != "Selected area" ]]; then
    delay=$(hyprlauncher -o "Instant,2s,10s")
    case $delay in
    2s) delay_set=2 ;;
    10s) delay_set=10 ;;
    Instant) delay_set=0 ;;
    *) exit 1 ;;
    esac
fi

case $choice in
"Selected area")
    grim -g "$(slurp)" "$DIR$NAME" || exit 1
    cat "$DIR$NAME" | wl-copy -t image/png -o
    notify-send "Screenshot created and copied to clipboard" "Mode: Selected area"
    # swappy -f "$DIR$NAME"
    ;;
"All Displays")
    sleep $delay_set
    grim "$DIR$NAME"
    cat "$DIR$NAME" | wl-copy -t image/png -o
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    # swappy -f "$DIR$NAME"
    ;;
"Current display")
    monitor="$(hyprctl monitors | awk '/Monitor/{monitor=$2} /focused: yes/{print monitor; exit}')"
    sleep $delay_set
    grim -o "$monitor" "$DIR$NAME"
    cat "$DIR$NAME" | wl-copy -t image/png -o
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    # swappy -f "$DIR$NAME"
    ;;
"Current Active Window")
    activewindow=$(hyprctl -j activewindow)
    pos_x=$(echo $activewindow | jq -r '(.at[0])')
    pos_y=$(echo $activewindow | jq -r '(.at[1])')
    size_x=$(echo $activewindow | jq -r '(.size[0])')
    size_y=$(echo $activewindow | jq -r '(.size[1])')
    sleep $delay_set
    grim -g "${pos_x},${pos_y} ${size_x}x${size_y}" "$DIR$NAME"
    cat "$DIR$NAME" | wl-copy -t image/png -o
    notify-send "Screenshot created and copied to clipboard" "Mode: Active Window"
    # swappy -f "$DIR$NAME"
    ;;

esac
