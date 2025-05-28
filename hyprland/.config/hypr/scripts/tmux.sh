#!/usr/bin/env zsh

tmux ls 2>/dev/null 1>&2

if [ "$?" = "1" ]; then
    tmux
else
    tmux at
fi
