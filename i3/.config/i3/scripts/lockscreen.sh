#!/usr/bin/env bash
pkill picom
i3lock -nfe -c 000000 && picom -b
rm $HOME/.xidleoff
