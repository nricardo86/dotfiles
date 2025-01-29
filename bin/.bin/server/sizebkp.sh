#!/usr/bin/env bash
DS=(z/main z/alt)
snapshot_name="remoteBkp"

echo "ZFS snapshot size -> Remote"
for i in ${DS[@]}; do
	LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name ${i} | grep ${snapshot_name} | tail -1)
	zfs snapshot ${i}@${snapshot_name}-$(date --utc +%Y%m%d-%H%M)
	NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name ${i} | grep ${snapshot_name} | tail -1)

	options="-I ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
	echo "Incremental Snapshot from ${LAST_SNAPSHOT} to ${NOW_SNAPSHOT}"

	SNAP_SIZE=$(zfs send -Pnwc ${options} | tail -1 | awk '{print $2}' | bc)
	SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
	SNAP_SIZE_GB=$(echo "${SNAP_SIZE_MB} / 1024" | bc)

	zfs destroy ${NOW_SNAPSHOT}

	((sum = sum + ${SNAP_SIZE_MB}))
	echo -e "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"
done

((sum_gb = sum / 1024))

echo -e "Total Remote Size: ${sum}MiB / ${sum_gb}GiB\n"

echo -e "***********************************************************************\n"

DS=z/main
snapshot_name="tapebkp"

echo "ZFS snapshot size -> Tape"
LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name ${DS} | grep ${snapshot_name} | tail -1)
zfs snapshot $DS@${snapshot_name}-$(date --utc +%Y%m%d-%H%M)
NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name ${DS} | grep ${snapshot_name} | tail -1)

options="-I ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
echo "Incremental Snapshot from ${LAST_SNAPSHOT} to ${NOW_SNAPSHOT}"

SNAP_SIZE=$(zfs send -Pnwc ${options} | tail -1 | awk '{print $2}' | bc)
SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
SNAP_SIZE_GB=$(echo "${SNAP_SIZE_MB} / 1024" | bc)

zfs destroy ${NOW_SNAPSHOT}

echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"
