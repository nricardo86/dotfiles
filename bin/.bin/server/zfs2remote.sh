#!/usr/bin/env bash
ADDR="srv2.nasatto.com"
SSH_USER="asdf"
SSH_PORT="22"

if [[ -z $1 ]];then
	echo "Need dataset list!"
	exit 1
fi

count=5
while true; do
  timeout 5 bash -c "</dev/tcp/${ADDR}/${SSH_PORT}"
  if [ $? -ne 0 ]; then
  	echo "Remote server not responding!"
	else
		break
  fi
	sleep 5
	if ! ((count = count -1));then
		echo end
		exit 1;
	fi
done

REMOTE="ssh ${SSH_USER}@${ADDR} -p ${SSH_PORT} -i ~/.ssh/id_ed25519"
DS=$1
RT='zbak'
prefix="remoteBkp"

for ds in ${DS[@]}; do
	newDS=${ds#*/}
	rds=${RT}/${newDS}

	rsnap=$(${REMOTE} zfs list -H -o name -t snapshot "${rds}" | tail -1)
	rsnap="${ds}@${rsnap#*@}"

	if ! zfs list -H "${rsnap}" &>/dev/null; then
		echo "${rsnap} not found locally!"
		exit 1
	fi

	zfs snapshot ${ds}@${prefix}-$(date --utc +%Y%m%d-%H%M)
	snap=$(zfs list -t snapshot -H -o name ${ds} | tail -1)
	options="-I ${rsnap} ${snap}"

	zfs send -wcv ${options} | ${REMOTE} zfs receive -Fuv ${rds}
	if [ $? -ne 0 ]; then
		echo "Send Snapshot fail"
		zfs destroy ${snap}
  fi
done
