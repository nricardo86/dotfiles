#!/usr/bin/env bash
DS=z/main
options=()

LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name $DS | grep tapebkp | tail -1)
zfs snapshot $DS@tapebkp-$(date --utc +%Y%m%d-%H%M)
NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name $DS | grep tapebkp | tail -1)

if [[ -z $LAST_SNAPSHOT ]]; then
	options+="-R $NOW_SNAPSHOT"
	echo "Full Snapshot: $NOW_SNAPSHOT"
else
	options+="-I $LAST_SNAPSHOT $NOW_SNAPSHOT"
	echo "Incremental Snapshot from $LAST_SNAPSHOT to $NOW_SNAPSHOT"
fi

SNAP_SIZE=$(zfs send -Pnwc $options | tail -1 | awk '{print $2}' | bc)
SNAP_SIZE_MB=$(echo "$SNAP_SIZE / 1024^2" | bc)
SNAP_SIZE_GB=$(echo "$SNAP_SIZE_MB / 1024" | bc)

zfs destroy $NOW_SNAPSHOT

echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"
