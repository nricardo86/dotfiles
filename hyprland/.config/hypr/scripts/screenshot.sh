#!/bin/bash
#  ____                               _           _
# / ___|  ___ _ __ ___  ___ _ __  ___| |__   ___ | |_
# \___ \ / __| '__/ _ \/ _ \ '_ \/ __| '_ \ / _ \| __|
#  ___) | (__| | |  __/  __/ | | \__ \ | | | (_) | |_
# |____/ \___|_|  \___|\___|_| |_|___/_| |_|\___/ \__|
#
#
# by Stephan Raabe (2023)
# -----------------------------------------------------

DIR="$HOME/Downloads/"
NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"

option2="Selected area"
option3="Fullscreen (delay 1s)"
option4="Current display (delay 1s)"
option5="Current Active Window (delay 1s)"

options="$option2\n$option3\n$option4\n$option5"
choice=$(echo -e "$options" | wofi -dmenu -i -L 10 -p "Take Screenshot")

case $choice in
$option2)
    grim -g "$(slurp)" "$DIR$NAME"
    xclip -selection clipboard -t image/png -i "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Selected area"
    swappy -f "$DIR$NAME"
    ;;
$option3)
    sleep 1
    grim "$DIR$NAME"
    xclip -selection clipboard -t image/png -i "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    swappy -f "$DIR$NAME"
    ;;
$option4)
    sleep 1
    monitor="$(hyprctl monitors | awk '/Monitor/{monitor=$2} /focused: yes/{print monitor; exit}')"
    grim -o "$monitor" "$DIR$NAME"
    xclip -selection clipboard -t image/png -i "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    swappy -f "$DIR$NAME"
    ;;
$option5)
    sleep 1
    window=$(hyprctl -j activewindow | jq -r '(.at)')
    grim -g "${window[0]} ${window[1]}" "$DIR$NAME"
    xclip -selection clipboard -t image/png -i "$DIR$NAME"
    notify-send "Screenshot created and copied to clipboard" "Mode: Active Window"
    swappy -f "$DIR$NAME"
    ;;
esac
