#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k
TAPELIBRARY=$(lsscsi -g | grep mediumx | awk '{print $7}')
TAPEDRIVE=${TAPE: -1:1}
FILES_ONTAPE=0

function usage {
	echo "usage: $(basename $0) [-b '$BS'] [-t '$TAPE'] dataset slot [prefix]"
	exit 1
}

while getopts "rb:t:" o; do
	case "${o}" in
	r) RECURSIVE_ONLY=true ;;
	b) BS="${OPTARG}" ;;
	t) TAPE="${OPTARG}" ;;
	*) usage ;;
	esac
done

function tapeSerial {
	local tape_serial=$(sudo sg_read_attr "${TAPE}" -f 0x401 2>/dev/null | awk '{print $4}')
	if [[ -z "${tape_serial}" ]]; then
		echo "fail to identify tape"
		exit 100
	fi
	echo "Tape Serial: ${tape_serial}"
}

function tapeRewind {
	echo "Rewinding Tape!"
	mt -f "$TAPE" rewind
}

function findEOM {
	echo "Finding EOM..."
	local count=3
	while true; do
		mt -f "${TAPE}" eom 2>/dev/null && break
		if [[ "${count}" -eq "0" ]]; then
			echo "EOM not Found!"
			return 101
		fi
		((count--))
		tapeRewind || return $?
	done
	echo "EOM Found!"
	FILES_ONTAPE=$((FILES_ONTAPE + $(mt -f "${TAPE}" status | grep 'file number' | awk '{print $4}')))
}

function loadTape {
	echo "Loading Tape..."
	mtx -f $TAPELIBRARY load $1 $TAPEDRIVE || exit $?
	tapeSerial || exit $?
	findEOM || exit $?
}

function unloadTape {
	echo "Unloading Tape..."
	mtx -f $TAPELIBRARY unload $TAPEDRIVE || exit $?
}

function loadNextTape {
	echo "Loading next Tape..."
	mtx -f $TAPELIBRARY next $TAPEDRIVE || exit $?
	tapeSerial || exit $?
	findEOM || exit $?
}

function checkSize {
	local snap_size=$(zfs send -Pnwc $1 | tail -1 | awk '{print $2}' | bc) || return $?
	local snap_size_mb=$(echo "${snap_size} / 1024^2" | bc)
	echo "Snapshot Size: ${snap_size_mb}MiB"

	local size_remain_mb=$(sudo sg_read_attr "${TAPE}" -f 0x0 2>/dev/null | awk '{print $6}' | bc) || return $?
	echo "Remain space on tape: ${size_remain_mb}MiB"

	[[ "${size_remain_mb}" -ge "((snap_size_mb))" ]] && return $? || echo "Insuficient remain space on tape"
	return 102
}

function destroySnap {
	echo "Destroying $1"
	zfs destroy "$1" &>/dev/null
}

function send2tape {
	zfs send -wc $1 | mbuffer -m 50G -s $((BS * 512)) -o "${TAPE}"
}

function firstSnapshot {
	tapeRewind || exit $?
	echo "Sending First Snapshot"
	local snap_init=$(zfs list -t snapshot $1 -H | grep $2 | head -n1 | awk '{print $1}') || return $?

	checkSize "${snap_init}"

	echo "Sending from ${snap_init}"
	send2tape "-R ${snap_init}" || return $?

	FILES_ONTAPE=1
}

function recursiveSend {
	echo "Sending Recursive Snapshots"
	local count=0
	local snapshots=()
	for i in $(zfs list -t snapshot $1 -H -o name | grep $2); do
		snapshots+=("$i")
	done

	snaps=${#snapshots[@]}
	count=$(("${#snapshots[@]}" - "${FILES_ONTAPE}" + 1))
	while [ "${count}" -gt "1" ]; do
		local snap_from="${snapshots[((snaps - count))]}"
		local snap_to="${snapshots[((snaps - ((count - 1))))]}"

		if [[ ! $(checkSize "-I ${snap_from} ${snap_to}") ]]; then
			loadNextTape
			count=$(("${#snapshots[@]}" - "${FILES_ONTAPE}" + 1))
			continue
		fi

		echo "Sending incremental snapshot from ${snap_from} to ${snap_to}"
		send2tape "-RI ${snap_from} ${snap_to}" || return $?
		((count--))
	done
}

function snapshot {
	local last_snapshot=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)
	zfs snapshot -r "${1}@${2}-$(date --utc +%Y%m%d-%H%M)" || return $?
	local now_snapshot=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)

	echo "Creating snapshot: $now_snapshot"

	while [[ ! $(checkSize "-RI ${last_snapshot} ${now_snapshot}") ]]; do
		loadNextTape
	done

	echo "Incremental Snapshot from ${last_snapshot} to ${now_snapshot}"
	if [[ ! $(send2tape "-RI ${last_snapshot} ${now_snapshot}") ]]; then
		destroySnap $now_snapshot
		return 103
	fi
}

function main {
	echo "Block Size set: ${BS}"
	echo "Tape Drive set: ${TAPE}"
	echo "TapeLibrary set: ${TAPELIBRARY}"

	local slot=${2}
	local ds=${1}
	local prefix="${3:-tapebkp}"

	[[ -z "${ds}" || -z "${slot}" ]] && usage
	[[ $(zfs list -H -o name ${ds}) ]] || exit $?

	echo "Dataset: ${ds}"
	echo "Prefix: ${prefix}"
	echo -e "\n"

	echo "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)"
	echo "----------------------------------"

	loadTape $slot

	[[ "${FILES_ONTAPE}" -eq 0 ]] && firstSnapshot "${ds}" "${prefix}" || exit $?

	recursiveSend "${ds}" "${prefix}" || exit $?
	[[ -z $RECURSIVE_ONLY ]] && snapshot "${ds}" "${prefix}" || exit $?

	unloadTape

	echo "--------------------------------"
	echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
}

main $@
