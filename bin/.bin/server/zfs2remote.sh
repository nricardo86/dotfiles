#!/usr/bin/env bash
REMOTE="asdf@backup.nasatto.com -i ~/.ssh/id_ed25519"

ssh -q ${REMOTE} exit
if [ "$?" -ne "0" ]; then
	echo "Remote is offline"
	exit 1
fi

DS=(z/main z/alt)
RT='zbak'
prefix="remoteBkp"

echo -e "Begin of backup - $(date --utc +%Y/%m/%d-%H:%M)\n"

for ds in ${DS[@]}; do
	newDS=${ds#*/}
	rds=${RT}/${newDS}

	zfs snapshot ${ds}@${prefix}-$(date --utc +%Y%m%d-%H%M)
	snap=$(zfs list -t snapshot -H -o name ${ds} | tail -1)

	rsnap=$(ssh ${REMOTE} zfs list -H -o name -t snapshot "${rds}" | tail -1)
	rsnap="${ds}@${rsnap#*@}"

	if [[ -n $rsnap ]]; then
		echo "latest remote snapshot: $rsnap"
		if ! zfs list -t snapshot "${rsnap}" &>/dev/null; then
			echo "${rsnap} not found locally!"
			zfs destroy $snap
			return 1
		fi
		options="-I ${rsnap} ${snap}"
	fi

	echo "sending inc snapshot from ${rsnap} to ${snap}"

	SNAP_SIZE=$(zfs send -Pnwc ${options} | tail -1 | awk '{print $2}' | bc)
	SNAP_SIZE_MB=$(echo "${SNAP_SIZE} / 1024^2" | bc)
	SNAP_SIZE_GB=$(echo "scale=2;${SNAP_SIZE_MB} / 1024" | bc)
	((sum = sum + ${SNAP_SIZE_MB}))
	echo "Snapshot Size: ${SNAP_SIZE_MB}MiB / ${SNAP_SIZE_GB}GiB"

	zfs send -wc ${options} | ssh ${REMOTE} zfs receive -Fuv ${rds}
	echo -e "\n"
done

sum_gb=$(echo "scale=2;$sum / 1024" | bc)
echo -e "Total Backup Size: ${sum}MiB / ${sum_gb}GiB\n"

echo "End of backup - $(date --utc +%Y/%m/%d-%H:%M)"
