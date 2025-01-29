#!/usr/bin/env bash

/usr/bin/bash ~/.bin/restic-vault.sh unlock
/usr/bin/bash ~/.bin/restic-vault.sh forget \
    --keep-daily=30 --keep-monthly=12 --prune $@
