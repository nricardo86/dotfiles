#!/usr/bin/env bash
DIR=/home/ricardo

function usage {
    echo "Usage $(basename $0): [-b] [-c] [-h]"
    echo "backup: $(basename $0) -b"
    echo "clean: $(basename $0) [-c]"
    echo "help: $(basename $0) [-h]"
}

function backup {
    unlock
    /usr/bin/bash $DIR/.bin/restic-vault.sh backup --one-file-system \
        --exclude="*/node_modules/*" --exclude-caches=true $DIR/Documents

    /usr/bin/pass git pull
    /usr/bin/pass git push
}

function clean {
    unlock
    /usr/bin/bash ~/.bin/restic-vault.sh forget \
        --keep-daily=30 --keep-monthly=12 --prune $@
}

function unlock {
    /usr/bin/bash $DIR/.bin/restic-vault.sh -q unlock
}

while getopts "hbc" o; do
    case "${o}" in
    b)
        backup
        ;;
    c)
        clean
        ;;
    *)
        usage
        ;;
    esac
done
