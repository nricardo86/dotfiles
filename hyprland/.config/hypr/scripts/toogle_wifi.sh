#!/bin/bash

if [ $(wifi | awk '{print $3}') == "off" ]; then
    wifi on
else
    wifi off
fi
