#!/usr/bin/env bash

vpn=$(sudo /usr/bin/wg show | grep interface | cut -d" " -f2)

for i in $(echo $vpn); do
    sudo /usr/bin/wg-quick down $i
done
