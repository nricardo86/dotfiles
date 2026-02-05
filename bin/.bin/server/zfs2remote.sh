#!/usr/bin/env bash
ADDR="bdf5a13a.duckdns.org"
SSH_USER="asdf"
SSH_PORT="22"

if [[ -z $1 ]]; then
	echo "Need dataset list!"
	exit 1
fi

COUNT=5
while true; do
	timeout 5 bash -c "</dev/tcp/${ADDR}/${SSH_PORT}" && break
	echo "Remote server not responding!"
	sleep 5
	[[ ((COUNT--)) ]] || exit 1
done

REMOTE="ssh ${SSH_USER}@${ADDR} -p ${SSH_PORT} -i ~/.ssh/id_ed25519"
DS=$1
RT=${2:-zbak}
PREFIX=${3:-remoteBkp}

for ds in ${DS[@]}; do
	NEWDS=${ds#*/}
	RDS=${RT}/${NEWDS}

	RSNAP=$(${REMOTE} zfs list -H -o name -t snapshot "${RDS}" | tail -1)
	RSNAP="${ds}@${RSNAP#*@}"

	if ! zfs list -H "${RSNAP}" &>/dev/null; then
		echo "${RSNAP} not found locally!"
		exit 1
	fi

	zfs snapshot -r ${ds}@${PREFIX}-$(date --utc +%Y%m%d-%H%M)
	SNAP=$(zfs list -t snapshot -H -o name ${ds} | tail -1)
	OPTIONS="-RI ${RSNAP} ${SNAP}"

	zfs send -wc ${OPTIONS} | ${REMOTE} zfs receive -Fuv ${rds}
	if [ $? -ne 0 ]; then
		echo "Send Snapshot fail"
		zfs destroy ${SNAP}
	fi
done
