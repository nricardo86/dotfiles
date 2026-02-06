#!/usr/bin/env bash
DIR=/home/ricardo

function usage {
    echo "Usage $(basename $0): [-b] [-c] [-g] [-h]"
    echo "backup: $(basename $0) [-b]"
    echo "clean: $(basename $0) [-c]"
    echo "password-store backup: $(basename $0) [-g]"
    echo "help: $(basename $0) [-h]"
}

function backup {
    unlock
    /usr/bin/bash $DIR/.bin/restic-vault.sh backup --one-file-system \
        --exclude="*/node_modules/*" --exclude-caches=true $DIR/Documents
}

function clean {
    unlock
    /usr/bin/bash ~/.bin/restic-vault.sh forget \
        --keep-daily=30 --keep-monthly=12 --prune $@
}

function unlock {
    /usr/bin/bash $DIR/.bin/restic-vault.sh -q unlock
}

function git {
    /usr/bin/pass git pull
    /usr/bin/pass git push
}

while getopts "hbcg" o; do
    case "${o}" in
    b)
        backup
        ;;
    c)
        clean
        ;;
    g)
        git
        ;;
    *)
        usage
        ;;
    esac
done
