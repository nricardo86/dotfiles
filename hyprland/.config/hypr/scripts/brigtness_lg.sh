#!/usr/bin/env bash

current=$(ddcutil --display=1 getvcp 0x10 | cut -d',' -f1 | awk '{print $9}')

if [ "$1" == '+' ]; then
    current=$((current + $2))
else
    if [ "$1" == '-' ]; then
        current=$((current - $2))
    fi
fi

ddcutil --display=1 setvcp 0x10 $current
echo $current
