#!/usr/bin/env bash
pkill picom
slock && picom -Cb
rm $HOME/.xidleoff
