#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k
DS=$1

if [[ -z "$DS" ]]; then
	echo need dataset destination
	exit 1
fi


TAPE_ATTR=$(sudo sg_read_attr ${TAPE}) || exit 1

echo "Tape2zfs init! - $(date --utc +%Y/%m/%d-%H%M)"

echo "Rewinding Tape!"
mt -f ${TAPE} rewind

while (dd status=progress if=${TAPE} bs=${BS} | zfs receive -Fuv ${DS}); do
	:
done

echo "Rewinding and Unloading Tape!"
mt -f $TAPE offline

echo "Tape2zfs done! - $(date --utc +%Y/%m/%d-%H%M)"
