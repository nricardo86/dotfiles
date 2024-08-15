#!/usr/bin/env bash

wifi off
bluetooth off

$HOME/.config/hypr/scripts/wgDisconnect.sh

loginctl terminate-user $USER
