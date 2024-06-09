#!/usr/bin/env bash
DIR=/home/ricardo
bash $DIR/.bin/bkp.sh
mountpoint=$(udisksctl mount -b $1 | awk '{print $4}')
rsync -avh -e ssh av:/z/data/.asdfg98 $mountpoint/.asdfg98 --delete-excluded
rsync -avh $DIR/.password-store/ $mountpoint/.password-store/ --delete-excluded
udisksctl unmount -b $1
