#!/usr/bin/env bash
bash $HOME/.bin/bkp.sh -bc
mountpoint=$(udisksctl mount -b $1 | awk '{print $4}')
rsync -avh -e ssh root@10.0.4.57:/data/asdfg98/ $mountpoint/asdfg98/ --delete-excluded
rsync -avh $HOME/.password-store/ $mountpoint/password-store/ --delete-excluded
udisksctl unmount -b $1
