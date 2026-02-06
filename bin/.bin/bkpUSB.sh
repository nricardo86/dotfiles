#!/usr/bin/env bash
if [[ -z "$1" ]]; then
    echo "Need Destination Device /dev/sdx#"
    exit 1
fi

mountpoint=$(udisksctl mount -b $1 | awk '{print $4}')

[[ -n $mountpoint ]] || exit 2

bash $HOME/.bin/bkp.sh -bgc

rsync -avh -e ssh root@10.0.4.57:/data/asdfg98/ $mountpoint/asdfg98/ --delete-excluded
rsync -avh $HOME/.password-store/ $mountpoint/password-store/ --delete-excluded

udisksctl unmount -b $1
