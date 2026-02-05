#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k

function set_bs {
	echo "${OPTARG}"
	BS="${OPTARG}"
}

function set_tape {
	echo "${OPTARG}"
	TAPE="${OPTARG}"
}

while getopts "b:t:" o; do
	case "${o}" in
	b) set_bs ;;
	t) set_tape ;;
	*) usage ;;
	esac
done

function usage {
	echo "$(basename $0) [-b '256k'] [-t '/dev/nst0'] dataset"
	exit 1
}

function tapeRewind {
	echo "Rewinding Tape!"
	mt -f $TAPE rewind
}

function tapeEject {
	echo "Rewinding and Ejecting Tape!"
	mt -f $TAPE eject
}

function findEOM {
	echo "Finding EOM..."
	local count=3
	while true; do
		mt -f ${TAPE} eom 2>/dev/null && return $?
		if [[ "${count}" -eq "0" ]]; then
			echo "EOM not Found!"
			return 9
		fi
		((count--))
		tapeRewind || return $?
	done
	echo "EOM Found!"
	FILES_ONTAPE=$(mt -f ${TAPE} status | grep 'file number' | awk '{print $4}')
}

function checkSize {
	local snap_size=$(zfs send -Pnwc $@ | tail -1 | awk '{print $2}' | bc)
	[[ $? -eq 0 ]] || return $?
	local snap_size_mb=$(echo "${snap_size} / 1024^2" | bc)
	local snap_size_gb=$(echo "scale=2;${snap_size_mb} / 1024" | bc)
	echo "Snapshot Size: ${snap_size_mb}MiB / ${snap_size_gb}GiB"

	local size_remain_mb=$(sudo sg_read_attr ${TAPE} -f 0x0 2>/dev/null | awk '{print $6}' | bc)
	[[ $? -eq 0 ]] || return $?
	local size_remain_gb=$(echo "scale=2;${size_remain_mb} / 1024" | bc)
	echo "Remain space on tape: ${size_remain_mb}MiB / ${size_remain_gb}GiB"

	[[ "${size_remain_mb}" -ge "((snap_size_mb+5000))" ]] && return $? || echo "Insuficient remain space on tape"
	return 1
}

function destroySnap {
	zfs destroy ${1} &>/dev/null
}

function send2tape {
	zfs send -wc $@ | dd status=progess of=${TAPE} bs=${BS}
}

function firstSnapshot {
	tapeRewind || exit $?
	echo "First Snapshot"
	local snap_init=$(zfs list -t snapshot $1 -H | grep $2 | head -n1 | awk '{print $1}')
	[[ $? -eq 0 ]] || return $?

	checkSize "${snap_init}" || exit $?

	echo "Sending from ${snap_init}"
	send2tape "-R ${snap_init}" || return $?

	FILES_ONTAPE=1
}

function snapshot {
	local last_snapshot=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)
	zfs snapshot -r "${1}@${2}-$(date --utc +%Y%m%d-%H%M)" || return $?
	local now_snapshot=$(zfs list -t snapshot -H -o name $1 | grep $2 | tail -1)

	if ! checkSize "-RI ${last_snapshot} ${now_snapshot}"; then
		destroySnap "${now_snapshot}"
		exit 6
	fi

	echo "Incremental Snapshot from ${last_snapshot} to ${now_snapshot}"
	send2tape "-RI ${last_snapshot} ${now_snapshot}"
}

function recursiveSend {
	local count=0
	local snapshots=()
	for i in $(zfs list -t snapshot $1 -H -o name); do
		[[ "$i" == *"$2"* ]] && snapshots+=("$i")
	done

	count=$(("${#snapshots[@]}" - "${FILES_ONTAPE}" + 1))
	while [ "${count}" -gt "1" ]; do
		local snap_from=${snapshots[((${#snapshots[@]} - ${count}))]}
		local snap_to=${snapshots[((${#snapshots[@]} - ((${count} - 1))))]}

		checkSize "-I ${snap_from} ${snap_to}" || return $?

		echo "Sending incremental snapshot from ${snap_from} to ${snap_to}"
		send2tape "-RI ${snap_from} ${snap_to}" || return $?
		((count--))
	done
}

function main {
	local ds=${1}
	local prefix="${2:-tapebkp}"

	[[ -z "${ds}" ]] && usage

	echo "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)"
	echo "----------------------------------"

	local tape_serial=$(sudo sg_read_attr ${TAPE} -f 0x401 2>/dev/null | awk '{print $4}')
	if [[ -z ${tape_serial} ]]; then
		echo "fail to identify tape"
		exit 8
	fi
	echo "Tape Serial: ${tape_serial}"

	tapeRewind || exit $?
	findEOM || exit $?

	[[ "${FILES_ONTAPE}" -eq 0 ]] && firstSnapshot "${ds}" "${prefix}" || exit $?

	recursiveSend "${ds}" "${prefix}" || exit $?
	snapshot "${ds}" "${prefix}" || exit $?

	tapeEject || exit $?

	echo "--------------------------------"
	echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
}

main $@
