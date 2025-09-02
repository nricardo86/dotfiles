#!/usr/bin/env bash

dir=/var/tmp/nhs
auth="asdf:qwert@"
url="https://ntfy.nasatto.com/ups"

vbat=$(echo "scale=1; $(cat ${dir}/nhs.json | jq .VDCMED) / 10" | bc)
pot=$(echo "scale=1; $(cat ${dir}/nhs.json | jq .POTRMS) * 10" | bc)

if [ -z ${dir}/nhs.json ];then
	exit 1
fi

sendMsg () {
	curl -fSsk ${url} -u ${auth} -d "$1" -H "Title: $2"
}

sendMsg "Potência Atual: ${pot}W" "Tensão bateria: ${vbat}V"
