#!/usr/bin/env bash
pkill picom
slock && picom -b
if [ -e $HOME/.xidleoff ]; then
    rm $HOME/.xidleoff
fi
