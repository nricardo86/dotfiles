#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k
DS=$1

if [[ -z "$DS" ]]; then
	echo need dataset destination
	exit 1
fi

echo "Tape2zfs init! - $(date --utc +%Y/%m/%d-%H%M)"

TAPE_ATTR=$(sudo sg_read_attr ${TAPE})
if [[ "$?" -ne "0" ]]; then
	exit 1
fi
# mt -f ${TAPE} rewind

while (dd status=progress if=${TAPE} bs=${BS} | sudo zfs receive -Fuv ${DS}); do
	:
done

echo "Rewinding and Unloading Tape.."
mt -f $TAPE offline

echo "Tape2zfs done! - $(date --utc +%Y/%m/%d-%H%M)"
