#!/usr/bin/env bash

bluetooth on
sleep 3

for i in $(bluetoothctl devices | awk '{print $2}'); do
    [[ "$(bluetoothctl info $i | grep Blocked | awk '{print $2}')" == "no" ]] && bluetoothctl connect "$i"
done
