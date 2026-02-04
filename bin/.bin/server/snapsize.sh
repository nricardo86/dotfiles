#!/usr/bin/env bash

if [ -z $1 ]; then
	echo "missing pool/dataset"
	exit 1
fi
repo=$1

list=$(zfs list -t snapshot -H -o name ${repo})
for i in ${list[@]}; do
	arr+=($i)
done

firstsizes=$(zfs send -Pnwc ${arr[0]} | tail -1 | awk '{print $2}')
firstsizes_mb=$(echo "${firstsizes} / 1024^2" | bc)
firstsizes_gb=$(echo "scale=2;${firstsizes_mb} / 1024" | bc)
echo "initial snapshot ${arr[0]}: ${firstsizes_mb}MiB / ${firstsizes_gb}GiB"

for ((i = 0; i < ${#arr[@]} - 1; i++)); do
	sizes=$(zfs send -wcnpPI ${arr[$i]} ${arr[(($i + 1))]} | awk '{print $4}')
	sizes_mb=$(echo "${sizes} / 1024^2" | bc)
	sizes_gb=$(echo "scale=2;${sizes_mb} / 1024" | bc)
	echo "inc from ${arr[$i]} to ${arr[(($i + 1))]}: ${sizes_mb}MiB / ${sizes_gb}GiB"
done

lastsizes=$(zfs send -PnwcR ${arr[-1]} | tail -1 | awk '{print $2}')
lastsizes_mb=$(echo "${lastsizes} / 1024^2" | bc)
lastsizes_gb=$(echo "scale=2;${lastsizes_mb} / 1024" | bc)
echo "Count snapshots: ${#arr[@]}"
echo "Total size ${1}: ${lastsizes_mb}MiB / ${lastsizes_gb}GiB"

