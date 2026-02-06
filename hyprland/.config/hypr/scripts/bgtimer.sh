#!/usr/bin/env bash
CONFIG_FILES="$HOME/.bg_timer"

[[ -e $CONFIG_FILES ]] && touch $CONFIG_FILES

while true; do
    inotifywait -q -e attrib $CONFIG_FILES
    $HOME/.config/hypr/scripts/bgaction.sh
done
