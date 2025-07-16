#!/usr/bin/env bash

vpn=$(doas wg show | grep interface | cut -d" " -f2)

for i in $(echo $vpn); do
    doas wg-quick down $i
done
