#!/bin/bash

if [ $(bluetooth | awk '{print $3}') == "off" ]; then
    bluetooth on
else
    bluetooth off
fi
