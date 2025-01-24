#!/usr/bin/env bash

ipv4enable=true
ipv6enable=true

tokens=("token1" "token2")

if [ $ipv4enable == true ]; then
	ipv4=$(curl --connect-timeout 3 -fSsk https://ipv4.json.myip.wtf 2>/dev/null)
	if [[ "$(echo $ipv4 | jq -r .YourFuckingISP)" == "Acessoline Telecom" ]]; then
		ipv4_addr=$(echo $ipv4 | jq -r .YourFuckingIPAddress)
	else
		ipv4enable=false
		ipv4fail=true
	fi
fi

ipv6_addr=$(curl --connect-timeout 3 -fSsk https://ipv6.text.myip.wtf 2>/dev/null)

if [ -z $ipv6_addr ]; then
	ipv6enable=false
fi

for token in ${tokens[*]}; do
	zones=$(curl -X GET \
		-s --connect-timeout 3 \
		-H "Accept: application/json" \
		-H "Authorization: Bearer $token" \
		"https://dynv6.com/api/v2/zones")

	zoneID=$(echo $zones | jq -r .[].id)
	hostname=$(echo $zones | jq -r .[].name)

	if [[ $ipv4enable == true && ! "$(echo $zones | jq -r .[].ipv4address)" == "$ipv4_addr" ]]; then
		curl -X PATCH \
			-s --connect-timeout 3 \
			-H "Authorization: Bearer $token" \
			-H "Accept: application/json" \
			--json $(printf '{"ipv4address":"%s"}' $ipv4_addr) \
			"https://dynv6.com/api/v2/zones/$zoneID"
	fi

	if [[ -n $ipv4fail ]]; then
		curl -X GET \
			-s --connect-timeout 10 \
			"https://dynv6.com/api/update?hostname=${hostname}&ipv4=-&token=${token}"
	fi

	if [[ "$ipv6enable" == true ]]; then
		resultv6=$(curl -X GET \
			-s --connect-timeout 3 \
			-H "Accept: application/json" \
			-H "Authorization: Bearer $token" \
			"https://dynv6.com/api/v2/zones/$zoneID/records")

		recordID=$(echo $resultv6 | jq -r .[].id)

		if [[ ! "$(echo $resultv6 | jq -r .[].data)" == "$ipv6_addr" ]]; then
			curl -X PATCH \
				-s --connect-timeout 3 \
				-H "Authorization: Bearer $token" \
				-H "Accept: application/json" \
				--json $(printf '{"data":"%s"}' $ipv6_addr) \
				"https://dynv6.com/api/v2/zones/$zoneID/records/$recordID"
		fi
	fi
done
