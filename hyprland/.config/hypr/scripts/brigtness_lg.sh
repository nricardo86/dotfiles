#!/usr/bin/env bash

current=$(ddcutil --display=1 getvcp 0x10 | cut -d',' -f1 | awk '{print $9}')

case $1 in
+)
    current=$((current + $2))
    ddcutil --display=1 setvcp 0x10 $current
    ;;
-)
    current=$((current - $2))
    ddcutil --display=1 setvcp 0x10 $current
    ;;
*)
    echo $current
    ;;
esac
