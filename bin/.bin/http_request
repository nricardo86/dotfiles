#!/usr/bin/env bash

exec 3<>/dev/tcp/myip.wtf/80 #Open Socket TCP port 80

#HTTP GET Headres
lines=(
    'GET /json HTTP/1.1'
    'Host: myip.wtf'
    'Connection: clonse'
    ''
)

#Format and send to socket
printf '%s\r\n' "${lines[@]}" >&3

#read response from server
while read -r data <&3; do
    echo "got server data: $data"
done

exec 3<&- #close file descriptor
