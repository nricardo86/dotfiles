#!/usr/bin/env bash
DIR=/home/ricardo

function usage {
    echo "Usage $(basename $0): [-b] [-c] [-g] [-h]"
    echo "backup: $(basename $0) [-b]"
    echo "clean: $(basename $0) [-c]"
    echo "idrivee2 backup and clean $(basename $0) [-i]"
    echo "password-store backup: $(basename $0) [-g]"
    echo "help: $(basename $0) [-h]"
}

function backup {
    unlock_vault
    /usr/bin/bash $DIR/.bin/vault.sh backup --one-file-system \
        --exclude="*/node_modules/*" --exclude-caches=true $DIR/Documents
}

function idrive {
    unlock_idrive
    /usr/bin/bash $DIR/.bin/idrive.sh backup --one-file-system \
        --exclude="*/node_modules/*" --exclude-caches=true \
        /home/ricardo/Documents/ricardo/config/dotfiles/ --tag "dotfiles"
    unlock_idrive || return 1
    /usr/bin/bash ~/.bin/idrive.sh forget \
        --keep-daily=30 --keep-monthly=12 --prune $@
}

function clean {
    unlock_vault || return 1
    /usr/bin/bash ~/.bin/vault.sh forget \
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

no_args=1
while getopts "bcgi" o; do
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
    i)
        idrive
        ;;
    *)
        usage && exit 1
        ;;
    esac
    unset no_args
done

[[ -z "$no_args" ]] || usage
