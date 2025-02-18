#!/usr/bin/env bash

ipv4enable=true
ipv6enable=false
ISP="ISP's Name"

tokens=('token here')

if [[ ${ipv4enable} == true ]]; then
	ipv4=$(curl --connect-timeout 3 -fSsk https://ipv4.json.myip.wtf 2>/dev/null)
	if [[ "$(echo ${ipv4} | jq -r .YourFuckingISP)" == "${ISP}" ]]; then
		ipv4_addr=$(echo ${ipv4} | jq -r .YourFuckingIPAddress)
		echo "IPv4: ${ipv4_addr}"
	else
		ipv4enable=false
		ipv4fail=true
	fi
fi

if [[ ${ipv6enable} == true ]]; then
	ipv6_addr=$(curl --connect-timeout 3 -fSsk https://ipv6.text.myip.wtf 2>/dev/null)
fi

if [ -z ${ipv6_addr} ]; then
	echo "IPv6 disable"
	ipv6enable=false
else
	echo "IPv6: ${ipv6_addr}"
fi

for token in ${tokens[*]}; do
	zones=$(curl -X GET \
		-s --connect-timeout 10 \
		-H "Accept: application/json" \
		-H "Authorization: Bearer $token" \
		"https://dynv6.com/api/v2/zones")

	zoneID=$(echo $zones | jq -r .[].id)
	hostname=$(echo $zones | jq -r .[].name)

	echo ${zones}

	if [[ ${ipv4enable} == true && ! "$(echo ${zones} | jq -r .[].ipv4address)" == "${ipv4_addr}" ]]; then
		echo "Update IPv4"
		curl -X PATCH \
			-s --connect-timeout 10 \
			-H "Authorization: Bearer ${token}" \
			-H "Accept: application/json" \
			--json $(printf '{"ipv4address":"%s"}' ${ipv4_addr}) \
			"https://dynv6.com/api/v2/zones/${zoneID}"
	fi

	if [[ -n ${ipv4fail} ]]; then
		echo "Disable IPv4"
		curl -X GET \
			-s --connect-timeout 10 \
			"https://dynv6.com/api/update?hostname=${hostname}&ipv4=-&token=${token}"
	fi

	if [[ "${ipv6enable}" == true && ! "$(echo ${zones} | jq -r .[].ipv6prefix)" == "${ipv6_addr}" ]]; then
		echo "Update IPv6"
		curl -X PATCH \
			-s --connect-timeout 10 \
			-H "Authorization: Bearer ${token}" \
			-H "Accept: application/json" \
			--json $(printf '{"ipv6prefix":"%s"}' ${ipv6_addr}) \
			"https://dynv6.com/api/v2/zones/${zoneID}"
	fi
done
