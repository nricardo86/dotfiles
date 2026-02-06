#!/usr/bin/env bash
DIR="$HOME/Downloads/"
NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"

option2="Selected area"
option3="Fullscreen - delay 2s"
option4="Current display - delay 2s"
option5="Current Active Window - delay 2s"

options="$option2\n$option3\n$option4\n$option5"
choice=$(echo -e "$options" | wofi -dmenu -i -L 10 -p "Take Screenshot")

case $choice in
$option2)
    grim -g "$(slurp)" "$DIR$NAME"
    wl-copy -t image/png "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Selected area"
    # swappy -f "$DIR$NAME"
    ;;
$option3)
    sleep 2
    grim "$DIR$NAME"
    wl-copy -t image/png "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    # swappy -f "$DIR$NAME"
    ;;
$option4)
    monitor="$(hyprctl monitors | awk '/Monitor/{monitor=$2} /focused: yes/{print monitor; exit}')"
    sleep 2
    grim -o "$monitor" "$DIR$NAME"
    wl-copy -t image/png "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    # swappy -f "$DIR$NAME"
    ;;
$option5)
    activewindow=$(hyprctl -j activewindow)
    pos_x=$(echo $activewindow | jq -r '(.at[0])')
    pos_y=$(echo $activewindow | jq -r '(.at[1])')
    size_x=$(echo $activewindow | jq -r '(.size[0])')
    size_y=$(echo $activewindow | jq -r '(.size[1])')
    sleep 2
    grim -g "${pos_x},${pos_y} ${size_x}x${size_y}" "$DIR$NAME"
    wl-copy -t image/png "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Active Window"
    # swappy -f "$DIR$NAME"
    ;;
esac
