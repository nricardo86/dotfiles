#!/usr/bin/env sh
synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
if [ $(synclient | grep TouchpadOff | cut -d"=" -f2 | bc) -eq "0" ]; then
    echo "Touchpad on!"
    dunstify "Touchpad on!"
else
    echo "Touchpad off!"
    dunstify "Touchpad off!"
fi
