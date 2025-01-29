#!/bin/bash

if [ -z $(pgrep hyprlock) ]; then
    hyprlock
fi
