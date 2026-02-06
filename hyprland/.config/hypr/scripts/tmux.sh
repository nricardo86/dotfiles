#!/usr/bin/env bash

tmux ls 2>/dev/null 1>&2 && tmux at || tmux
