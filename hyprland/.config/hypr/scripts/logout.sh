#!/usr/bin/env bash

$HOME/.config/hypr/scripts/wgDisconnect.sh
mullvad disconnect

pkill ssh-agent
pkill gpg-agent

nmcli radio wifi off
bluetooth off

loginctl terminate-user $USER
