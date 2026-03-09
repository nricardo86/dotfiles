#!/usr/bin/env bash
DIR=/z/torrent/
TAPE=/dev/nst0
TAPELIBRARY=/dev/sg11
TAPEDRIVE=0
BS=512 #default 512*512 = 256k

while getopts "n:d:b:s:t:l:" o; do
        case "${o}" in
        d) DIR=$OPTARG ;;
        s) SLOT=$OPTARG ;;
        t) TAPE=$OPTARG ;;
        l) TAPELIBRARY=$OPTARG ;;
        n) TAPEDRIVE=$OPTARG ;;
        b) BS=$OPTARG ;;
        *) usage ;;
        esac
done

function usage {
        echo "$(basename $0) -s <Slot in TapeLibrary> [-t <Tape dev>] [-l <Tape Library dev>] [-b <blocksize n*512bytes]"
        exit 1
}

[[ -z $SLOT ]] && usage

if [[ -e ~/.lastTorrentBackup ]]; then
        DAYS=("-mtime")
        DAYS+=($((($(stat -c %Y ~/.lastTorrentBackup) - $(date +%s)) / 86400)))
fi

echo "Directory: $DIR"
echo "Tape dev: $TAPE"
echo "Tape Library dev: $TAPELIBRARY"
echo "Blocksize: $((BS * 512 / 1024))kb"
echo "Slot of 1st Tape in Tape Library: $SLOT"

function sizeRemain {
        echo "$(sudo sg_read_attr $TAPE -f 0x0 2>/dev/null | awk '{print $6}' | bc)M"
}

function load {
        echo -e '\nLoading the 1st Tape'
        mtx -f $TAPELIBRARY load $SLOT $TAPEDRIVE
}

function uload {
        echo -e '\n\nUnloading tape!'
        mtx -f $TAPELIBRARY unload $TAPEDRIVE
}

function loadNext {
        echo -e '\nLoading next tape!'
        mtx -f $TAPELIBRARY next $TAPEDRIVE
}

function find_select {
        find $DIR -type f ${DAYS[@]} ! -name *[sS]ample* | egrep -i '.mkv|.avi|.m4v|.mp4|.srt'
}

function tar_alt {
        tar -T - -cf -
}

function mbuffer_send {
        REMAIN=$(sizeRemain)
        mbuffer -m 50G -s $((BS * 512)) -D $REMAIN -A "loadNext;REMAIN=$(sizeRemain)" -o $TAPE && touch ~/.lastTorrentBackup
}

load
find_select | tar_alt | mbuffer_send
unload
