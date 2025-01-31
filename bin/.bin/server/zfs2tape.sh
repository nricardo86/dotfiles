#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k
 
DS=z/main
snap_prefix="tapebkp"

function send2tape {
	SIZE_REMAIN=$(sudo sg_read_attr ${TAPE} -f 0x0 | awk '{print $6}' | bc)
	SIZE_REMAIN_GB=$(echo "scale=2;${SIZE_REMAIN} / 1024" | bc)
	SNAP_SIZE=$(zfs send -Pnwc ${options} | tail -1 | awk '{print $2}' | bc)
	SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
	SNAP_SIZE_GB=$(echo "scale=2;${SNAP_SIZE_MB} / 1024" | bc)

	echo "Remain space on tape: ${SIZE_REMAIN}MiB / ${SIZE_REMAIN_GB}GiB"
	echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"

	if [[ ! "${SIZE_REMAIN}" -ge "${SNAP_SIZE_MB}" ]]; then
		echo "Insuficient remain space on tape"
		zfs destroy ${NOW_SNAPTSHOT} &>/dev/null
		exit 1
	fi

	zfs send -wc ${options} | dd status=progress of=${TAPE} bs=${BS}
}

#timeout 60 mt -f ${TAPE} rewind

TAPE_ATTR=$(sudo sg_read_attr ${TAPE})
if [[ "$?" -ne "0" ]]; then
	exit "$?"
fi

TAPE_SERIAL=$(sudo sg_read_attr ${TAPE} -f 0x401 | awk '{print $4}')

echo "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)"
echo "Tape Serial: ${TAPE_SERIAL}"

echo "Finding EOM.."
count=3
while true
do
	mt -f ${TAPE} eom
	if [[ "$?" -eq "0" ]]; then
		break
	fi
	if [[ "${count}" -eq "0" ]]; then
		echo "EOM not Found"
		exit "$?"
	fi
	((count--))
	mt -f ${TAPE} rewind
done

echo "EOM Found!"

files_ontape=$(mt -f ${TAPE} status | grep 'file number' | awk '{print $4}')

snapshots=()
for i in $(zfs list -t snapshot ${DS} -H -o name); do
	if [[ "$i" == *"${snap_prefix}"* ]]; then
		snapshots+=("$i")
	fi
done

count=$(( "${#snapshots[@]}" - "${files_ontape}" + 1 ))
while [ "${count}" -gt "1" ]
do
	SNAP_FROM=${snapshots[((${#snapshots[@]} - ${count}))]} 
	SNAP_TO=${snapshots[((${#snapshots[@]} - ((${count} - 1))))]}
	echo "Sending incremental snapshot from ${SNAP_FROM} to ${SNAP_TO}"
	options="-I ${SNAP_FROM} ${SNAP_TO}"
	send2tape
	((count--))
done

LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name ${DS} | grep ${snap_prefix} | tail -1)
zfs snapshot ${DS}@${snap_prefix}-$(date --utc +%Y%m%d-%H%M)
NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name ${DS} | grep ${snap_prefix} | tail -1)
options="-I ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
echo "Incremental Snapshot from ${LAST_SNAPSHOT} to ${NOW_SNAPSHOT}"
send2tape

echo "Rewinding and Unloading Tape!"
mt -f $TAPE offline

echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
