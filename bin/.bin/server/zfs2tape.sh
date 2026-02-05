#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k

function sizeSnap {
	SNAP_SIZE=$(zfs send -Pnwc $@ | tail -1 | awk '{print $2}' | bc)
	[[ $? -eq 0 ]] || return $?
	SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
	SNAP_SIZE_GB=$(echo "scale=2;${SNAP_SIZE_MB} / 1024" | bc)
	echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"
	return $?
}

function sizeRemain {
	SIZE_REMAIN_MB=$(sudo sg_read_attr ${TAPE} -f 0x0 | awk '{print $6}' | bc)
	[[ $? -eq 0 ]] || return $?
	SIZE_REMAIN_GB=$(echo "scale=2;${SIZE_REMAIN_MB} / 1024" | bc)
	echo "Remain space on tape: ${SIZE_REMAIN_MB}MiB / ${SIZE_REMAIN_GB}GiB"
	return $?
}

function send2tape {
	zfs send -wc ${@} | dd status=progress of=${TAPE} bs=${BS}
	return $?
}

function findEOM {
	echo "Finding EOM..."
	count=3
	while true; do
		mt -f ${TAPE} eom && return 0
		if [[ "${count}" -eq "0" ]]; then
			echo "EOM not Found!"
			return 9
		fi
		((count--))
		tapeRewind || return $?
	done
	echo "EOM Found!"
	files_ontape=$(mt -f ${TAPE} status | grep 'file number' | awk '{print $4}')
	return $?
}

function tapeRewind {
	echo "Rewinding Tape!"
	mt -f $TAPE rewind
	return $?
}

function tapeEject {
	echo "Rewinding and Ejecting Tape!"
	mt -f $TAPE eject
	return $?
}

function checkSize {
	[[ ! "${SIZE_REMAIN_MB}" -ge "${SNAP_SIZE_MB}" ]] && echo "Insuficient remain space on tape"
	return $?
}

function firstSnapshot {
	tapeRewind || exit $?
	echo "First Snapshot"
	SNAP_INIT=$(zfs list -t snapshot $1 -H | grep $2 | head -n1 | awk '{print $1}')
	[[ $? -eq 0 ]] || return $?

	sizeRemain || return $?
	sizeSnap "${SNAP_INIT}" || return $?
	checkSize || exit $?

	echo "Sending from ${SNAP_INIT}"
	send2tape "-R ${SNAP_INIT}" || return $?

	files_ontape=1
	return $?
}

function destroySnap {
	zfs destroy ${1} &>/dev/null
	return $?
}

function snapshot {
	LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)
	zfs snapshot -r "${1}@${2}-$(date --utc +%Y%m%d-%H%M)" || return $?
	NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)

	sizeRemain || return $?
	sizeSnap "-RI ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}" || return $?

	checkSize || destroySnap "${NOW_SNAPSHOT}" && return 6

	echo "Incremental Snapshot from ${LAST_SNAPSHOT} to ${NOW_SNAPSHOT}"
	send2tape "-RI ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
	return $?
}

function recursiveSend {
	local count=0
	local snapshots=()
	for i in $(zfs list -t snapshot $1 -H -o name); do
		[[ "$i" == *"$2"* ]] && snapshots+=("$i")
	done

	count=$(("${#snapshots[@]}" - "${files_ontape}" + 1))
	while [ "${count}" -gt "1" ]; do
		SNAP_FROM=${snapshots[((${#snapshots[@]} - ${count}))]}
		SNAP_TO=${snapshots[((${#snapshots[@]} - ((${count} - 1))))]}

		sizeRemain || return $?
		sizeSnap "-I ${SNAP_FROM} ${SNAP_TO}" || return $?

		checkSize || exit $?
		echo "Sending incremental snapshot from ${SNAP_FROM} to ${SNAP_TO}"
		send2tape "-RI ${SNAP_FROM} ${SNAP_TO}" || return $?
		((count--))
	done
}

function main {
	local DS=${1}
	local prefix="${2:-tapebkp}"

	if [[ -z "${DS}" ]]; then
		echo "need dataset to backup"
		exit 7
	fi

	echo "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)"
	echo "----------------------------------"

	TAPE_SERIAL=$(sudo sg_read_attr ${TAPE} -f 0x401 | awk '{print $4}')
	if [[ -z ${TAPE_SERIAL} ]]; then
		echo "fail to identify tape"
		exit 8
	fi
	echo "Tape Serial: ${TAPE_SERIAL}"

	tapeRewind || exit $?
	findEOM || exit $?

	[[ "${files_ontape}" -eq 0 ]] && firstSnapshot "${DS}" "${prefix}"

	recursiveSend "${DS}" "${prefix}" || exit $?
	snapshot "${DS}" "${prefix}" || exit $?

	tapeEject || exit $?

	echo "--------------------------------"
	echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
}

main $@
