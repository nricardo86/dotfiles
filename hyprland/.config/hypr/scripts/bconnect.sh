#!/usr/bin/env bash

bluetooth on

devices=$(bluetoothctl devices | awk '{print $2}')

for i in $devices; do
    bluetoothctl connect $i
done
