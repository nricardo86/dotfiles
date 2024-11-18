#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k
TAPE_SERIAL=$(sudo sg_read_attr $TAPE -f 0x401 | awk '{print $4}')
DS=z/data
options=()

echo "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)"
echo "Rewinding Tape.."
mt -f $TAPE rewind

if [[ ! "$(mt -f $TAPE status | tail -1)" == *"BOT"* ]]; then
	echo "Tape not Found!"
	exit 1
fi

LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name $DS | grep tapebkp | tail -1)
zfs snapshot $DS@tapebkp-$(date --utc +%Y%m%d-%H%M)
NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name $DS | grep tapebkp | tail -1)

if [[ -z $LAST_SNAPSHOT ]]; then
	options+="-R $NOW_SNAPSHOT"
	echo "Full Snapshot: $NOW_SNAPSHOT"
else
	options+="-I $LAST_SNAPSHOT $NOW_SNAPSHOT"

	echo "Incremental Snapshot from $LAST_SNAPSHOT to $NOW_SNAPSHOT"

	echo "Finding EOD.."
	count=0
	mt -f $TAPE eod
	while ([[ ! $(mt -f $TAPE status | tail -1) == *"EOD"* ]]); do
		:
		if [[ $((count += 1)) -gt 3 ]]; then
			echo "EOD not Found!"
			echo "Destroing Snapshot: $NOW_SNAPSHOT"
			zfs destroy $NOW_SNAPSHOT
			exit 1
		fi
		mt -f $TAPE rewind
		mt -f $TAPE eod
	done
	echo "EOD Found!"
fi

SIZE_REMAIN=$(sudo sg_read_attr $TAPE -f 0x0 | awk '{print $6}' | bc)
SIZE_REMAIN_GB=$(echo "$SIZE_REMAIN / 1024" | bc)
SNAP_SIZE=$(zfs send -Pnwc $options | tail -1 | awk '{print $2}' | bc)
SNAP_SIZE_MB=$(echo "$SNAP_SIZE / 1024^2" | bc)
SNAP_SIZE_GB=$(echo "$SNAP_SIZE_MB / 1024" | bc)

echo "Remain space on tape: ${SIZE_REMAIN}MiB / ${SIZE_REMAIN_GB}GiB"
echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"

if [[ ! "$SIZE_REMAIN" -ge "$SNAP_SIZE_MB" ]]; then
	echo "Insuficient remain space on tape"
	echo "Destroing Snapshot: $NOW_SNAPSHOT"
	zfs destroy $NOW_SNAPSHOT
	exit 1
fi

echo "Sending data to Tape Serial: $TAPE_SERIAL"
zfs send -wc $options | dd status=progress of=$TAPE bs=$BS

echo "Rewinding and Unloading Tape!"
mt -f $TAPE offline

echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
