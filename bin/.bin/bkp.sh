#!/usr/bin/env bash
DIR=/home/ricardo

/usr/bin/bash $DIR/.bin/restic-vault.sh unlock
/usr/bin/bash $DIR/.bin/restic-vault.sh backup --one-file-system \
    --exclude="*/node_modules/*" --exclude-caches=true $DIR/Documents

/usr/bin/pass git pull
/usr/bin/pass git push
