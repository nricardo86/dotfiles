#!/usr/bin/env bash

zfs load-key z
zfs mount z/main
zfs mount z/alt

bash -c ~/pepare-mullvad-lxc.sh

if [[ -z $(zfs mount | grep -i "z/main") ]]; then exit 1;fi

containers=(100 101 105 106 302 303 304 305 306)
vms=(400)

for i in ${containers[@]};do
	if [ $(lxc-info -n $i | grep State | awk '{print $2}') != "RUNNING" ];then
	  lxc-start -n $i &
  fi
done

for i in ${vms[@]};do
	if [ $(qm status $i | grep status | awk '{print $2}') != "running" ];then
		qm start $i &
	fi
done

