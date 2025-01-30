#!/usr/bin/bash

if [ -z $(pgrep hyprpaper) ]; then
    hyprpaper &
    sleep 1
fi

hyprctl hyprpaper unload 'all'
for i in $(hyprctl monitors -j | jq -r '.[].name'); do
    IMAGE=$(find $HOME/.wallpaper -type f -maxdepth 1 | shuf -n1)
    hyprctl hyprpaper preload $IMAGE
    sleep 1
    hyprctl hyprpaper wallpaper $i,$IMAGE
done
