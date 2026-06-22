#!/usr/bin/env bash
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal

sleep 1
/usr/lib/xdg-desktop-portal-hyprland
