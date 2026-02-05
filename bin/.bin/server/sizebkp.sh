#!/usr/bin/env bash
DS=(z/main z/pbs z/alt)
snapshot_name="remoteBkp"

date --utc

echo "ZFS snapshot size -> Remote"
for ds in ${DS[@]}; do
	LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name ${ds} | tail -1)
	zfs snapshot -r ${ds}@${snapshot_name}-Now
	NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name ${ds} | grep ${snapshot_name} | tail -1)

	options="-I ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
	echo "Since Snapshot ${LAST_SNAPSHOT}"

	SNAP_SIZE=$(zfs send -Pnwc ${options} | tail -1 | awk '{print $2}' | bc)
	SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
	SNAP_SIZE_GB=$(echo "scale=2;${SNAP_SIZE_MB} / 1024" | bc)

	zfs destroy ${NOW_SNAPSHOT}

	((sum = sum + ${SNAP_SIZE_MB}))
	echo -e "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"
done

sum_gb=$(echo "scale=2;$sum / 1024" | bc)
echo -e "Total Remote Size: ${sum}MiB / ${sum_gb}GiB\n"

echo -e "***********************************************************************\n"

DS=z/main
snapshot_name="tapebkp"

echo "ZFS snapshot size -> Tape"
LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name ${DS} | grep ${snapshot_name} | tail -1)
zfs snapshot -r $DS@${snapshot_name}-Now
NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name ${DS} | grep ${snapshot_name} | tail -1)

options="-I ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
echo "Since Snapshot ${LAST_SNAPSHOT}"

SNAP_SIZE=$(zfs send -Pnwc ${options} | tail -1 | awk '{print $2}' | bc)
SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
SNAP_SIZE_GB=$(echo "scale=2;${SNAP_SIZE_MB} / 1024" | bc)

zfs destroy ${NOW_SNAPSHOT}

echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"
