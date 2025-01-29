#!/usr/bin/env bash
bash $HOME/.bin/bkp.sh
bash $HOME/.bin/bkp_clean.sh
mountpoint=$(udisksctl mount -b $1 | awk '{print $4}')
rsync -avh -e ssh vault:/data/asdfg98/ $mountpoint/asdfg98/ --delete-excluded
rsync -avh $DIR/.password-store/ $mountpoint/password-store/ --delete-excluded
udisksctl unmount -b $1
