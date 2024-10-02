#!/usr/bin/env bash

$HOME/.config/hypr/scripts/wgDisconnect.sh

nmcli radio wifi off
bluetooth off

loginctl terminate-user $USER
