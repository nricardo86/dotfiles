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

for ((i = 0; i < ${#arr[@]} - 1; i++)); do
	sizes=$(zfs send -wcnpPI ${arr[$i]} ${arr[(($i + 1))]} | awk '{print $4}')
	sizes_mb=$(echo "${sizes} / 1024^2" | bc)
	sizes_gb=$(echo "${sizes_mb} / 1024" | bc)
	echo "inc from ${arr[$i]} to ${arr[(($i + 1))]}: ${sizes_mb}MiB / ${sizes_gb}GiB"
done
