#!/usr/bin/env bash

wifi off
bluetooth off

vpn=$(sudo /usr/bin/wg show | grep interface | cut -d" " -f2)

for i in $(echo $vpn); do
    sudo /usr/bin/wg-quick down $i
done

loginctl terminate-user $USER
