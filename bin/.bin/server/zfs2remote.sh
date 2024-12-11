#!/usr/bin/env bash
REMOTE="asdf@pbs.nasatto.com -i ~/.ssh/id_ed25519"

ssh -q ${REMOTE} exit
if [ "$?" -ne "0" ];then
	echo "Remote is offline"
	exit 1
fi

DS=(z/main z/alt)
BKP_TANK='zbak'
snapshot_name="remoteBkp"

echo -e "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)\n"

for i in ${DS[@]}; do
	LAST_SNAPSHOT=$(zfs list -t snapshot -H -o name ${i} | grep ${snapshot_name} | tail -1)
	zfs snapshot ${i}@${snapshot_name}-$(date --utc +%Y%m%d-%H%M)
	NOW_SNAPSHOT=$(zfs list -t snapshot -H -o name ${i} | grep ${snapshot_name} | tail -1)

	if [[ -z ${LAST_SNAPSHOT} ]]; then
		options="-R ${NOW_SNAPSHOT}"
		echo "Full Snapshot: ${NOW_SNAPSHOT}"
	else
		options="-I ${LAST_SNAPSHOT} ${NOW_SNAPSHOT}"
		echo "Incremental Snapshot from ${LAST_SNAPSHOT} to ${NOW_SNAPSHOT}"
	fi

	SNAP_SIZE=$(zfs send -Pnwc ${options} | tail -1 | awk '{print $2}' | bc)
	SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
	SNAP_SIZE_GB=$(echo "${SNAP_SIZE_MB} / 1024" | bc)
	((sum = sum + ${SNAP_SIZE_MB}))
	echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"

	newDS=$(echo ${i}|cut -d/ -f2)

	zfs send -wc ${options} | ssh ${REMOTE} zfs receive -Fu ${BKP_TANK}/${newDS}
done

((sum_gb = sum / 1024))
echo -e "Total Backup Size: ${sum}MiB / ${sum_gb}GiB\n"

echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
