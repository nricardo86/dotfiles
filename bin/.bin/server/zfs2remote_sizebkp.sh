#!/usr/bin/env bash
DS=$(zfs list -H -o name | grep 'z/')
sum=0

for i in ${DS[@]}; do
	options=()

	LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name ${i} | grep remoteBkp | tail -1)
	zfs snapshot ${i}@remoteBkp-$(date --utc +%Y%m%d-%H%M)
	NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name ${i} | grep remoteBkp | tail -1)

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

	((sum = sum + $SNAP_SIZE_MB))
	echo -e "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB\n"
done

((sum_gb = sum / 1024))

echo "Total Backup Size: ${sum}MiB / ${sum_gb}GiB"