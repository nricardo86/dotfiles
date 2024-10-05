#!/usr/bin/env bash

/usr/bin/bash ~/.bin/restic-av.sh unlock
/usr/bin/bash ~/.bin/restic-av.sh forget \
    --keep-daily=30 --keep-monthly=12 --prune $@
