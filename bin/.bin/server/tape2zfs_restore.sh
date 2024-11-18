#!/usr/bin/env bash
TAPE=/dev/nst0
BS=256k
DS=fast/teste1

echo "Tape2zfs init! - $(date --utc +%Y/%m/%d-%H%M)"

echo "Rewinding Tape.."
mt -f $TAPE rewind

if [[ ! "$(mt -f $TAPE status | tail -1)" == *"BOT"* ]]; then
	echo "Tape not Found!"
	exit 1
fi

while (dd status=progress if=$TAPE bs=$BS | sudo zfs receive -Fuv $DS); do
	:
done

echo "Rewinding and Unloading Tape.."
mt -f $TAPE offline

echo "Tape2zfs done! - $(date --utc +%Y/%m/%d-%H%M)"
