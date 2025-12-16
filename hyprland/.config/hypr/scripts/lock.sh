#!/bin/bash

if [ -z $(pgrep hyprlock) ]; then
    playerctl --all-players pause
    hyprlock
fi
