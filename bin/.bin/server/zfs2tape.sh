#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k

function sizeSnap {
	SNAP_SIZE=$(zfs send -Pnwc $@ | tail -1 | awk '{print $2}' | bc)
	SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
	SNAP_SIZE_GB=$(echo "scale=2;${SNAP_SIZE_MB} / 1024" | bc)
	echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"
}

function sizeRemain {
	SIZE_REMAIN_MB=$(sudo sg_read_attr ${TAPE} -f 0x0 | awk '{print $6}' | bc)
	SIZE_REMAIN_GB=$(echo "scale=2;${SIZE_REMAIN_MB} / 1024" | bc)
	echo "Remain space on tape: ${SIZE_REMAIN_MB}MiB / ${SIZE_REMAIN_GB}GiB"
}

function send2tape {
	zfs send -wc ${@} | dd status=progress of=${TAPE} bs=${BS}
}

function findEOM {
	echo "Finding EOM..."
	count=3
	while true; do
		mt -f ${TAPE} eom
		if [[ "$?" -eq "0" ]]; then
			break
		fi
		if [[ "${count}" -eq "0" ]]; then
			echo "EOM not Found!"
			exit "$?"
		fi
		((count--))
		mt -f ${TAPE} rewind
	done
	echo "EOM Found!"
	files_ontape=$(mt -f ${TAPE} status | grep 'file number' | awk '{print $4}')
}

function tapeRewind {
	echo "Rewinding Tape!"
	mt -f $TAPE rewind
}

function tapeEject {
	echo "Rewinding and Ejecting Tape!"
	mt -f $TAPE eject
}

function firstSnapshot {
	echo "First Snapshot"
	SNAP_INIT=$(zfs list -t snapshot $1 -H | grep $2 | head -n1 | awk '{print $1}')

	sizeRemain
	sizeSnap "${SNAP_INIT}"

	if [[ ! "${SIZE_REMAIN_MB}" -ge "${SNAP_SIZE_MB}" ]]; then
		echo "Insuficient remain space on tape"
	else
		echo "Sending from ${SNAP_INIT}"
		send2tape "-R ${SNAP_INIT}"
	fi

	files_ontape=1
}

function snapshot {
	LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)
	zfs snapshot -r "${1}@${2}-$(date --utc +%Y%m%d-%H%M)"
	NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)

	sizeRemain
	sizeSnap "-RI ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"

	if [[ ! "${SIZE_REMAIN_MB}" -ge "${SNAP_SIZE_MB}" ]]; then
		echo "Insuficient remain space on tape"
		zfs destroy ${NOW_SNAPTSHOT} &>/dev/null
	else
		echo "Incremental Snapshot from ${LAST_SNAPSHOT} to ${NOW_SNAPSHOT}"
		send2tape "-RI ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
	fi
}

function recursiveSend {
	local count=0
	local snapshots=()
	for i in $(zfs list -t snapshot $1 -H -o name); do
		if [[ "$i" == *"$2"* ]]; then
			snapshots+=("$i")
		fi
	done

	count=$(("${#snapshots[@]}" - "${files_ontape}" + 1))
	while [ "${count}" -gt "1" ]; do
		SNAP_FROM=${snapshots[((${#snapshots[@]} - ${count}))]}
		SNAP_TO=${snapshots[((${#snapshots[@]} - ((${count} - 1))))]}

		sizeRemain
		sizeSnap "-I ${SNAP_FROM} ${SNAP_TO}"

		if [[ ! "${SIZE_REMAIN_MB}" -ge "${SNAP_SIZE_MB}" ]]; then
			echo "Insuficient remain space on tape"
			exit 1
		else
			echo "Sending incremental snapshot from ${SNAP_FROM} to ${SNAP_TO}"
			send2tape "-RI ${SNAP_FROM} ${SNAP_TO}"
		fi
		((count--))
	done
}

function main {
	local DS=${1}
	local prefix="${2:-tapebkp}"

	if [[ -z "${DS}" ]]; then
		echo "need dataset to backup"
		exit 1
	fi

	echo "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)"
	echo "----------------------------------"

	TAPE_SERIAL=$(sudo sg_read_attr ${TAPE} -f 0x401 | awk '{print $4}')
	if [[ -z ${TAPE_SERIAL} ]]; then
		echo "fail to identify tape"
		exit 2
	else	
		echo "Tape Serial: ${TAPE_SERIAL}"
	fi

	tapeRewind
	findEOM

	if [ "${files_ontape}" -eq 0 ]; then
		tapeRewind
		firstSnapshot "${DS}" "${prefix}"
	fi

	recursiveSend "${DS}" "${prefix}"
	snapshot "${DS}" "${prefix}"

	tapeEject

	echo "--------------------------------"
	echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
}

main $@
