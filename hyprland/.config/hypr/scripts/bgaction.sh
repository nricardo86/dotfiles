#!/usr/bin/bash

if [ -z $(pgrep hyprpaper) ]; then
    hyprpaper &
fi

hyprctl hyprpaper unload 'all'
for i in $(hyprctl monitors | grep Monitor | cut -d' ' -f2); do
    IMAGE=$(find $HOME/.wallpaper | shuf -n1)
    hyprctl hyprpaper preload $IMAGE
    sleep 1
    hyprctl hyprpaper wallpaper "$i,$IMAGE"
done
