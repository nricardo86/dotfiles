#!/usr/bin/env bash

wifi off

vpn=$(sudo /usr/bin/wg show | grep interface | cut -d" " -f2)

for i in $(echo $vpn); do
    sudo /usr/bin/wg-quick down $i
done

i3-msg exit
