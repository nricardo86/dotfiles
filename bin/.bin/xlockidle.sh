#!/usr/bin/env bash
XSS=/usr/bin/xssstate
LS=$HOME/.bin/lockscreen.sh

while getopts "t: l" opt 2>/dev/null; do
    case ${opt} in
    l)
        if [ -e $HOME/.xidleoff ]; then
            rm $HOME/.xidleoff
            echo "xLockIdle Enable"
            dunstify "xLockIdle Enable"
        else
            touch $HOME/.xidleoff
            echo "xLockIdle Disable"
            dunstify "xLockIdle Disable"
        fi
        ;;
    t)
        if [[ $($XSS -i) -ge $(($2 * 60 * 1000)) && ! -e /home/ricardo/.xidleoff ]]; then
            bash -c $LS
        fi
        echo "xlock in $2 minutes"
        ;;
    esac
done

#Read Variables from a file Key/Value
#export $(grep -v '^#' .env | xargs -d '\n')
