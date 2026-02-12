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
    unlock_vault
    /usr/bin/bash $DIR/.bin/vault.sh backup --one-file-system \
        --exclude="*/node_modules/*" --exclude-caches=true $DIR/Documents
    unlock_idrive
    /usr/bin/bash $DIR/.bin/idrive.sh backup --one-file-system \
        --exclude="*/node_modules/*" --exclude-caches=true \
        /home/ricardo/Documents/ricardo/config/dotfiles/ --tag "dotfiles"
}

function clean {
    unlock_vault
    /usr/bin/bash ~/.bin/vault.sh forget \
        --keep-daily=30 --keep-monthly=12 --prune $@
    unlock_idrive
    /usr/bin/bash ~/.bin/idrive.sh forget \
        --keep-daily=30 --keep-monthly=12 --prune $@
}

function unlock_vault {
    /usr/bin/bash $DIR/.bin/vault.sh -q unlock
}

function unlock_idrive {
    /usr/bin/bash $DIR/.bin/vault.sh -q unlock
}

function git {
    /usr/bin/pass git pull
    /usr/bin/pass git push
}

no_args="true"
while getopts "bcg" o; do
    case "${o}" in
    b)
        backup && exit 0
        ;;
    c)
        clean && exit 0
        ;;
    g)
        git && exit 0
        ;;
    *)
        usage && exit 1
        ;;
    esac
    no_args="false"
done

[[ "$no_args" == "true" ]] && usage
