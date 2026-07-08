#!/usr/bin/env bash

vpn=$(sudo wg show | grep interface | cut -d" " -f2)

for i in ${vpn[@]}; do
    sudo wg-quick down $i
done
