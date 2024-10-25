#!/usr/bin/env bash

bluetooth on
sleep 5

for i in $(bluetoothctl devices | awk '{print $2}'); do
    bluetoothctl connect $i
done
