#!/usr/bin/env bash

bluetooth on
sleep 5

devices=$(bluetoothctl devices | awk '{print $2}')

for i in $devices; do
    bluetoothctl connect $i
done
