#!/usr/bin/env bash
TAPE=/dev/nst0
BS=512
TAPELIBRARY=$(lsscsi -g | grep mediumx | awk '{print $7}')
TAPEDRIVE=${TAPE: -1:1}

while getopts "b:t:s" o; do
    case "${o}" in
    s) STATS_ONLY=true ;;
    t)
        TAPE=$OPTARG
        TAPEDRIVE=${TAPE: -1:1}
        ;;
    b) BS=$OPTARG ;;
    *) usage ;;
    esac
done
shift $((OPTIND - 1))

function usage {
    echo "$(basename $0) [options] directory slot"
    echo "options:"
    echo "[-s] Statistics only"
    echo "[-t <Tape dev>] default $TAPE"
    echo "[-b <n blocksize>] \"n*512bytes\" default $((BS * 512 / 1024))kb"
    exit 1
}

function loadTape {
    mtx -f $TAPELIBRARY load $SLOT $TAPEDRIVE
}

function unloadTape {
    mtx -f $TAPELIBRARY unload $TAPEDRIVE
}

function find_select {
    if [[ -e $DIR/lastTapeBackup ]]; then
        DAYS=("-mtime")
        DAYS+=($echo $((($(stat -c %Y $DIR/lastTapeBackup) - $(date +%s)) / 86400)))
    fi
    find $DIR -type f ${DAYS[@]} $@
}

function tar_cmd {
    tar --format=pax -T - -cf - 2>/dev/null
}

function sizeRemain {
    sudo sg_read_attr $TAPE -f 0x0 2>/dev/null | awk '{print $6}'
}

function mbuffer_send {
    mbuffer -s $((BS * 512)) \
        -m 10% \
        -D $(sizeRemain)M \
        -A "mtx -f $TAPELIBRARY next $TAPEDRIVE" \
        -o $TAPE 2>/dev/null && touch $DIR/lastTapeBackup
}

function sizeFiles {
    find_select "-printf %s\n" | awk '{sum += $1} END {print sum}'
}

function main {
    DIR=$1
    SLOT=$2
    [[ -z $SLOT || -z $DIR ]] && usage
    if [[ ! -d $DIR ]]; then
        echo directory invalid
        exit 1
    fi

    echo "Directory: $DIR"
    if [[ -n $STATS_ONLY ]]; then
        if [[ -e $DIR/lastTapeBackup ]]; then
            echo "Partial Backup"
            echo "Last Backup: $(stat -c %y $DIR/lastTapeBackup)"
        else
            echo "Full Backup"
        fi
        echo "Processing sizes..."
        echo "Size for next backup: $(($(sizeFiles) / 1048576))M"
        return 0
    fi

    echo "Tape dev: $TAPE"
    echo "Blocksize: $((BS * 512 / 1024))kb"
    echo "Tape Library dev: $TAPELIBRARY"
    echo "Slot TapeLibrary: $SLOT"

    loadTape
    if [[ ! -e $DIR/lastTapeBackup ]]; then
        echo "Full Backup"
        find_select "-print0" | tar_cmd | mbuffer_send
        unloadTape
        return 0
    fi
    while [[ "$(($(sizeFiles) / 1048576))" -gt "$(sizeRemain)" ]]; do
        mtx -f $TAPELIBRARY next $TAPEDRIVE
    done
    echo "Partial Backup"
    find_select "-print0" | tar_cmd | mbuffer_send
    unloadTape
}

main $@
