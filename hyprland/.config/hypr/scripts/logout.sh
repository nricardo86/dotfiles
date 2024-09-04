#!/usr/bin/env bash

$HOME/.config/hypr/scripts/wgDisconnect.sh

wifi off
bluetooth off

loginctl terminate-user $USER
