#!/usr/bin/env bash

/usr/bin/bash $DIR/.bin/restic-av.sh unlock
/usr/bin/bash $DIR/.bin/restic-av.sh forget \
    --keep-daily=7 --keep-weekly=4 --keep-monthly=12 --prune
