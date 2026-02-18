#!/usr/bin/env bash
DIR="$HOME/Pictures/"
NAME="screenshot_$(date +%d%m%Y_%H%M%S).png"

option2="Selected area"
option3="All Displays"
option4="Current display"
option5="Current Active Window"

options="$option2\n$option3\n$option4\n$option5"
choice=$(echo -e "$options" | tofi --placeholder-text "Take Screenshot > ")
[[ -z $choice ]] && exit $?
if [[ "$choice" != "$option2" ]]; then
    delay=$(echo -e "Instant\n2s\n10s" | tofi --placeholder-text "Select Delay! > ")
    case $delay in
    2s) delay_set=2 ;;
    10s) delay_set=10 ;;
    Instant) delay_set=0 ;;
    *) exit 1 ;;
    esac
fi

case $choice in
$option2)
    grim -g "$(slurp)" "$DIR$NAME" || exit 1
    cat "$DIR$NAME" | wl-copy -t image/png -o
    notify-send "Screenshot created and copied to clipboard" "Mode: Selected area"
    # swappy -f "$DIR$NAME"
    ;;
$option3)
    sleep $delay_set
    grim "$DIR$NAME"
    cat "$DIR$NAME" | wl-copy -t image/png -o
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    # swappy -f "$DIR$NAME"
    ;;
$option4)
    monitor="$(hyprctl monitors | awk '/Monitor/{monitor=$2} /focused: yes/{print monitor; exit}')"
    sleep $delay_set
    grim -o "$monitor" "$DIR$NAME"
    cat "$DIR$NAME" | wl-copy -t image/png -o
    notify-send "Screenshot created and copied to clipboard" "Mode: Fullscreen"
    # swappy -f "$DIR$NAME"
    ;;

$option5)
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
